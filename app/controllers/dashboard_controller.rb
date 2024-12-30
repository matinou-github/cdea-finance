class DashboardController < ApplicationController
    
    def accueil
        
    end
    
    def index  
        @user_count = User.all.count
        @zone = ZoneAssignment.all.count
        @total_demande = ServiceRequest.all.count
        @demande_attente = ServiceRequest.where(status_request: "pending").count
        @Total_soja_recu = Remboursement.where(type_remboursement: 'nature').sum(:valeurs)
        @Total_numeraire_recu = Remboursement.where(type_remboursement: 'numeraire').sum(:valeurs)

        @service_requests = ServiceRequest.all

    end

    def list_user
        @user = User.new 
        @users = User.order(created_at: :asc)
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
        @village = params[:village] 
        if @village.present?
          @users = User.where(village: @village)
          pdf = Prawn::Document.new
          pdf.text "Liste client #{@village}", size: 18, style: :bold
          pdf.move_down 10
          table_data = [["Client ID", "Nom & Prénom", "Commune", "Village", "Téléphone", "Email"]]
          table_data += @users.map { |user| [user.id, user.full_name, user.commune,user.village, user.phone_number, user.email] }
          pdf.table(table_data, header: true, row_colors: ["DDDDDD", "FFFFFF"])
          respond_to do |format|
            format.pdf { send_data pdf.render, filename: "list_user.pdf", type: "application/pdf" }
          end 
        else
          @users = User.all
          pdf = Prawn::Document.new
          pdf.text "Liste des utilisateurs", size: 18, style: :bold
          pdf.move_down 10
          table_data = [["Client ID", "Nom & Prénom", "Commune", "Village", "Téléphone", "Email"]]
          table_data += @users.map { |user| [user.id, user.full_name, user.commune,user.village, user.phone_number, user.email] }
          pdf.table(table_data, header: true, row_colors: ["DDDDDD", "FFFFFF"])
          respond_to do |format|
            format.pdf { send_data pdf.render, filename: "list_user.pdf", type: "application/pdf" }
          end 
        end
    end
    
    
      
end