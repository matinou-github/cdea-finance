class DashboardController < ApplicationController
    before_action :authorize_secretaire_or_admin, only: [:index]
    def accueil
        
    end
    
    def index  
        @user_count = User.where.not(identification: [nil, '']).count
        @zone = ZoneAssignment.all.count
        @total_demande = ServiceRequest.all.count
        @demande_attente = ServiceRequest.where(status_request: "pending").count
        @dette_total_due = Balance.sum(:total_kg_paye)
        @total_du_par_village = Balance.joins(:user)
                                          .group('users.village')
                                          .sum(:total_kg_paye)
        @Total_soja_recu = Balance.sum(:total_remboursement)
        @total_remboursement_par_village = Balance.joins(:user)
                                          .group('users.village')
                                          .sum(:total_remboursement)
        @total_soja_restants = @dette_total_due - @Total_soja_recu
        
        @total_soja_restants_par_village = Balance.joins(:user)
                                        .group('users.village')
                                        .sum(:kg_restants)

    @difference_par_village = {}

    # Itération sur les villages pour lesquels il y a des données
    @total_du_par_village.each do |village, total_kg_paye|
    total_remboursement = @total_remboursement_par_village[village] || 0
    @difference_par_village[village] = total_kg_paye - total_remboursement
    end

        @service_requests = ServiceRequest.all

    end

    def list_user
        @user = User.new 
        if current_user.role == "technicien"
            # Récupérer la commune et le village du technicien
            commune = current_user.commune
            village = current_user.village

            # Trouver les utilisateurs dans la même commune et le même village
            @users = User.where(commune: commune, village: village) 
        else  
        @users = User.order(created_at: :asc)    
        end
        @users = @users.where(role: "agriculteur") if params[:agri].present?
        @users = @users.where('LOWER(nom) LIKE LOWER(?) OR LOWER(prenom) LIKE LOWER(?)', "%#{params[:full_name].downcase}%", "%#{params[:full_name].downcase}%") if params[:full_name].present?
        @users = @users.where('id = ?', params[:id]) if params[:id].present?
        @users = @users.where(village: params[:village]) if params[:village].present?
        @users =@users.page(params[:page]).per(10)
        @village = params[:village]
    end
 
    def bilan
        @service_requests = ServiceRequest.includes(:remboursements).page(params[:page]).per(10).order(created_at: :desc)
        @indice_setting = IndiceSetting.last
        @frais_dossier = @indice_setting.frais_dossier
        @valeur_soja = @indice_setting.valeur_soja
        @indice_pourcentage = @indice_setting.taux_majoration.to_f * 0.01
        # Calculer les sommes pour chaque service request
        @service_requests.each do |service_request|
           
            valeur_soja = @valeur_soja.to_f
            indice_pourcentage = @indice_pourcentage.to_f
            frais_dossier = @indice_setting.frais_dossier.to_f


            service_request.define_singleton_method(:nature_sum) do
                service_request.remboursements.where(type_remboursement: 'nature').sum(:valeurs)
            end
    
            service_request.define_singleton_method(:numeraire_sum) do
                service_request.remboursements.where(type_remboursement: 'numeraire').sum(:valeurs).to_f
            end

            # Ajouter la variable soja_restant
            service_request.define_singleton_method(:soja_restant) do
                service_request.kg_paye.present? ? (service_request.kg_paye.to_f - service_request.nature_sum.to_f) : 0
            end
            
            # Ajouter la variable valeur_deduit
            service_request.define_singleton_method(:valeur_deduit) do
                if soja_restant > 0
                    (soja_restant * valeur_soja) + ((soja_restant * valeur_soja) * indice_pourcentage)
                else
                    0
                end
             end

            service_request.define_singleton_method(:dette) do
                if valeur_deduit > 0
                    service_request.valeur_deduit.to_f - service_request.numeraire_sum.to_f
                else
                    0
                end
            end

            garantie_disponible_calcul = service_request.garantie.to_f - frais_dossier.to_f

            service_request.define_singleton_method(:garantie_disponible) do
                if garantie_disponible_calcul > 0
                    garantie_disponible_calcul
                else
                    0
                end
            end
        
          
        end  
    end

    def success_payment
        @demande_id = params[:demande_id]
    end

    def export_pdf
        @indice_setting = IndiceSetting.last
        manager_name = @indice_setting.gerant_name
        
        @village = params[:village] 
        if @village.present?
          @users = User.where(village: @village, role: "agriculteur")
          pdf = Prawn::Document.new
          pdf.image Rails.root.join('public', 'logo.png'), width: 75, position: :center
          pdf.text "LISTE DES CLIENTS DE #{@village}", size: 18, style: :bold, align: :center
          pdf.move_down 10
          table_data = [["Client ID", "Nom & Prénom", "Commune", "Village", "Téléphone", "Email"]]
          table_data += @users.map { |user| [user.identification, user.full_name, user.commune,user.village, user.phone_number, user.email] }
          pdf.table(table_data, header: true, row_colors: ["DDDDDD", "FFFFFF"])
          pdf.move_cursor_to(pdf.bounds.bottom + 60) # Ajustez la valeur pour le positionnement
          # Ajouter le texte du gérant de manière dynamique
          pdf.text "GERANT,", size: 10, align: :right, style: :italic
          pdf.move_down 35
          pdf.text "#{manager_name}", size: 10, align: :right, style: :italic
          respond_to do |format|
            format.pdf { send_data pdf.render, filename: "list_client_#{@village}.pdf", type: "application/pdf" }
          end 
        else
          @users = User.all
          pdf = Prawn::Document.new
          pdf.image Rails.root.join('public', 'logo.png'), width: 75, position: :center
          pdf.text "Liste des utilisateurs", size: 18, style: :bold, align: :center
          pdf.move_down 10
          table_data = [["Client ID", "Nom & Prénom", "Commune", "Village", "Téléphone", "Email"]]
          table_data += @users.map { |user| [user.identification, user.full_name, user.commune,user.village, user.phone_number, user.email] }
          pdf.table(table_data, header: true, row_colors: ["DDDDDD", "FFFFFF"])
          pdf.move_cursor_to(pdf.bounds.bottom + 60) # Ajustez la valeur pour le positionnement
          # Ajouter le texte du gérant de manière dynamique
          pdf.text "GERANT,", size: 10, align: :right, style: :italic
          pdf.move_down 35
          pdf.text "#{manager_name}", size: 10, align: :right, style: :italic
          respond_to do |format|
            format.pdf { send_data pdf.render, filename: "list_user.pdf", type: "application/pdf" }
          end 
        end
    end
    
private

def authorize_secretaire_or_admin
    unless current_user.admin? || current_user.secretaire?
      redirect_to root_path, alert: "Vous n'avez pas la permission d'accéder à cette page."
    end
  end
      
end