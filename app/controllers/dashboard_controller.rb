class DashboardController < ApplicationController
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
        @users = User.all
    end
    def bilan
        @service_requests = ServiceRequest.includes(:remboursements).all
        @indice_setting = IndiceSetting.last
        @valeur_soja = @indice_setting.valeur_soja
        @indice_pourcentage = @indice_setting.taux_majoration.to_f * 0.01
        # Calculer les sommes pour chaque service request
        @service_requests.each do |service_request|
           
            valeur_soja = @valeur_soja.to_f
            indice_pourcentage = @indice_pourcentage.to_f


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

           
        end

        
    end
end