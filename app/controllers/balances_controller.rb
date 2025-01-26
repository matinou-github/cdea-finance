class BalancesController < ApplicationController
    before_action :authenticate_user!  # Si tu utilises Devise pour l'authentification
    layout 'dashboard'
    before_action :set_filtered_balances, only: [:index, :print_balances]
    def index
      @restitution = Restitution.new
      @remboursement = Remboursement.new
      
      if current_user.role == "agriculteur"
        @balances = Balance.where(user_id: current_user.id).page(params[:page]).per(10).order(:year)
      elsif current_user.role == "technicien"
        # Trouver les utilisateurs associés au technicien courant
        user_ids = User.where(commune: current_user.commune, village: current_user.village).pluck(:id)

        # Récupérer les demandes de service de ces utilisateurs
        @balances = Balance.where(user_id: user_ids).page(params[:page]).per(10).order(:year)
      else
        @balances = @balances.page(params[:page]).per(10)
      end

      @indice_setting = IndiceSetting.last
      @frais_dossier = @indice_setting.frais_dossier
      @valeur_soja = @indice_setting.valeur_soja
      @indice_pourcentage = @indice_setting.taux_majoration.to_f
      @kg_mais_par_soja = @indice_setting.kg_mais_par_soja
    end


    # def convertir_garantie
    #     balance_request = Balance.find(params[:id])
    #     @indice_setting = IndiceSetting.last
    #     @valeur_soja = @indice_setting.valeur_soja
      
    #     kg_to_convert = params[:kg_to_convert].to_f
    #     guarantee_to_deduct = params[:guarantee_to_deduct].to_f
      
    #     if balance_request.total_garantie >= guarantee_to_deduct
    #       Remboursement.create!(
    #         user: balance_request.user,
    #         year: balance_request.year,
    #         type_remboursement: "nature",
    #         valeurs: kg_to_convert,
    #         credite_par: current_user
    #       )
      
    #       balance_request.update!(total_garantie: balance_request.total_garantie - guarantee_to_deduct)
      
    #       flash[:success] = "Garantie convertie avec succès en #{kg_to_convert} kg de soja."
    #     else
    #       flash[:error] = "Garantie insuffisante pour effectuer cette conversion."
    #     end
      
    #     redirect_to balances_path
    # end


    # def appliquer_majoration
    #     balance = Balance.find(params[:id])
    #     @indice_setting = IndiceSetting.last
    #     @indice_pourcentage = @indice_setting.taux_majoration
    #     @valeur_soja = @indice_setting.valeur_soja
    
    #     # Calcul des nouvelles valeurs majorées
    #     kg_restants = balance.kg_restants
    #     valeur_majoree_kg = kg_restants + (kg_restants * @indice_pourcentage * 0.01)
    #     valeur_majoree_numeraire = valeur_majoree_kg * @valeur_soja
    #     valeur_majoree_kg = valeur_majoree_kg.round
    #     # Mise à jour de la balance
    #     balance.update!(
    #     valeur_majoree_kg: valeur_majoree_kg,
    #     valeur_majoree_numeraire: valeur_majoree_numeraire
    #     )
    
    #     flash[:success] = "Majoration appliquée avec succès."
    #     redirect_to balances_path
    # end

    # def reporter_valeur
    #   balance = Balance.find(params[:id])
    #   next_year = balance.year + 1
    
    #   # Vérifier la valeur majorée
    #   if balance.valeur_majoree_kg <= 0
    #     flash[:error] = "Aucune valeur majorée à reporter."
    #     return redirect_to balances_path
    #   end
    
    #   # Trouver ou créer la balance pour l'année suivante
    #   next_balance = Balance.find_or_initialize_by(user_id: balance.user_id, year: next_year)
    #   next_balance.total_kg_paye += balance.valeur_majoree_kg
    #   next_balance.total_garantie += balance.total_garantie if next_balance.new_record?
    
    #   # Sauvegarder la nouvelle balance
    #   next_balance.save!
    
    #   # Réinitialiser la balance actuelle
    #   balance.update!(valeur_majoree_kg: 0,
    #   valeur_majoree_numeraire: 0,
    #   status: 'reporté')
    
    #   flash[:success] = "Valeur majorée reportée avec succès à l'année #{next_year}."
    #   redirect_to balances_path
    # end


    def kg_restants
      balance = Balance.find_by(user_id: params[:user_id], year: params[:year])
      if balance
        if balance.total_remboursement > 0
        render json: { kg_restants: balance.kg_restants }
        else
          render json: { kg_restants: balance.total_kg_paye }
        end
      else
        render json: { kg_restants: nil }, status: :not_found
      end
    end

      
    def traiter_toutes_balances
      #balances = Balance.where("kg_restants > 0")
      balances = Balance.where(status: 'en cours')
      @indice_setting = IndiceSetting.last
      @indice_pourcentage = @indice_setting.taux_majoration
      @valeur_soja = @indice_setting.valeur_soja
    
      ActiveRecord::Base.transaction do
        balances.each do |balance|
          # Étape 1 : Conversion de la garantie en kg
          if balance.kg_restants > 0
            kg_to_convert = [balance.kg_restants, balance.total_garantie / @valeur_soja].min
          else
            kg_to_convert = [balance.kg_restants, balance.total_garantie / @valeur_soja].max
          end
          guarantee_to_deduct = kg_to_convert * @valeur_soja
          
          if balance.total_garantie >= guarantee_to_deduct 
            Remboursement.create!(
              user: balance.user,
              year: balance.year,
              type_remboursement: "Remb/garantie", 
              valeurs: kg_to_convert,
              credite_par: current_user
            )
            guarantee_restant = balance.total_garantie - guarantee_to_deduct
            balance.update!(
              total_garantie: guarantee_restant, 
              status: 'Terminé'
              )
          else
            next # Si la garantie est insuffisante, passer à la balance suivante
          end
    
          # Étape 2 : Appliquer la majoration
          kg_restants = [balance.kg_restants - kg_to_convert, 0].max

          if balance.kg_restants > 0
            kg_restants = balance.kg_restants - kg_to_convert # Soustraire les kg convertis
          else
            kg_restants =balance.total_kg_paye - kg_to_convert
          end
          if kg_restants > 0
            valeur_majoree_kg = kg_restants + (kg_restants * @indice_pourcentage * 0.01)
            balance.valeur_majoree_kg = valeur_majoree_kg.round
            balance.valeur_majoree_numeraire = balance.valeur_majoree_kg * @valeur_soja
    
            # Étape 3 : Reporter la valeur à l'année suivante
            next_year = balance.year + 1
            next_balance = Balance.find_or_initialize_by(user_id: balance.user_id, year: next_year)
            next_balance.total_kg_paye += balance.valeur_majoree_kg
            next_balance.total_garantie += balance.total_garantie if next_balance.new_record?
            next_balance.save!
          end
    
          # Étape 4 : Réinitialiser la balance actuelle
          balance.update!(
            kg_restants: kg_restants,
            valeur_majoree_kg: 0,
            valeur_majoree_numeraire: 0,
            status: kg_restants > 0 ? 'Reporté' : 'Terminé',
            etat_garantie: "Remb/Garantie"
          )
        end
    
        
      end
      render json: { message: "Les actions ont été appliquées avec succès à toutes les balances éligibles." }, status: :ok
      
    rescue => e
      render json: { error: "Une erreur s'est produite : #{e.message}" }, status: :unprocessable_entity
      
    end

    def print_balances
      # @balances = Balance.order(:year)
      # if params[:user_id].present?
      #   @balances = @balances.where(user_id: params[:user_id])
      # end
    
      # if params[:search].present?
      #   @balances = @balances.joins(:user).where("users.nom ILIKE :search OR users.prenom ILIKE :search", search: "%#{params[:search]}%")
      # end
      @indice_setting = IndiceSetting.last
        @manager_name = @indice_setting.gerant_name
      render layout: 'print' # Utiliser le layout d'impression
    end
    
    
    private

    def set_filtered_balances
      @balances = Balance.order(:year)
      if params[:id].present?
        id_term = "%#{params[:id]}%"
        @balances = @balances.joins(:user).where("users.identification ILIKE :id", id: id_term)
      elsif params[:search].present?
        search_term = "%#{params[:search]}%"
        @balances = @balances.joins(:user).where("users.nom ILIKE :search OR users.prenom ILIKE :search", search: search_term)
      end
    end

end
