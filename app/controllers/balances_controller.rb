class BalancesController < ApplicationController
    before_action :authenticate_user!  # Si tu utilises Devise pour l'authentification
    layout 'dashboard'
    def index
      if current_user.role == "agriculteur"
        @balances = Balance.where(user_id: current_user.id).page(params[:page]).per(10).order(:year)
      else
        @balances = Balance.page(params[:page]).per(10).order(:year)
      end

      @indice_setting = IndiceSetting.last
      @frais_dossier = @indice_setting.frais_dossier
      @valeur_soja = @indice_setting.valeur_soja
      @indice_pourcentage = @indice_setting.taux_majoration.to_f
    end

    def convertir_garantie
        balance_request = Balance.find(params[:id])
        @indice_setting = IndiceSetting.last
        @valeur_soja = @indice_setting.valeur_soja
      
        kg_to_convert = params[:kg_to_convert].to_f
        guarantee_to_deduct = params[:guarantee_to_deduct].to_f
      
        if balance_request.total_garantie >= guarantee_to_deduct
          Remboursement.create!(
            user: balance_request.user,
            year: balance_request.year,
            type_remboursement: "nature",
            valeurs: kg_to_convert,
            credite_par: current_user
          )
      
          balance_request.update!(total_garantie: balance_request.total_garantie - guarantee_to_deduct)
      
          flash[:success] = "Garantie convertie avec succès en #{kg_to_convert} kg de soja."
        else
          flash[:error] = "Garantie insuffisante pour effectuer cette conversion."
        end
      
        redirect_to balances_path
    end


    def appliquer_majoration
        balance = Balance.find(params[:id])
        @indice_setting = IndiceSetting.last
        @indice_pourcentage = @indice_setting.taux_majoration
        @valeur_soja = @indice_setting.valeur_soja
    
        # Calcul des nouvelles valeurs majorées
        kg_restants = balance.kg_restants
        valeur_majoree_kg = kg_restants + (kg_restants * @indice_pourcentage * 0.01)
        valeur_majoree_numeraire = valeur_majoree_kg * @valeur_soja
        valeur_majoree_kg = valeur_majoree_kg.round
        # Mise à jour de la balance
        balance.update!(
        valeur_majoree_kg: valeur_majoree_kg,
        valeur_majoree_numeraire: valeur_majoree_numeraire
        )
    
        flash[:success] = "Majoration appliquée avec succès."
        redirect_to balances_path
    end

    def reporter_valeur
        balance = Balance.find(params[:id])
        next_year = balance.year + 1
      
        # Vérifier la valeur majorée
        if balance.valeur_majoree_kg <= 0
          flash[:error] = "Aucune valeur majorée à reporter."
          return redirect_to balances_path
        end
      
        # Trouver ou créer la balance pour l'année suivante
        next_balance = Balance.find_or_initialize_by(user_id: balance.user_id, year: next_year)
        next_balance.total_kg_paye += balance.valeur_majoree_kg
        next_balance.total_garantie += balance.total_garantie if next_balance.new_record?
      
        # Sauvegarder la nouvelle balance
        next_balance.save!
      
        # Réinitialiser la balance actuelle
        balance.update!(valeur_majoree_kg: 0,
        valeur_majoree_numeraire: 0,
        status: 'reporté')
      
        flash[:success] = "Valeur majorée reportée avec succès à l'année #{next_year}."
        redirect_to balances_path
      end
      

  end

  