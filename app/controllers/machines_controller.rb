class MachinesController < ApplicationController
  layout "dashboard"
  
    # Affiche le formulaire de complétion du profil
    def index
      if current_user.role == "tractoriste"
        # Si l'utilisateur est un tractoriste
        @tractors = Tractor.where(user_id: current_user.id)
    
        @executions = Execution
          .joins(machines: :tractor)
          .where(tractors: { user_id: current_user.id })
          .includes(machines: :tractor)
          .order(created_at: :desc)
    
        # Application des filtres
        if params[:conducteur_info].present?
          @executions = @executions.where("tractors.name ILIKE ?", "%#{params[:conducteur_info]}%")
        end
    
        if params[:year].present?
          @executions = @executions.where(year: params[:year])
        end
    
        @executions = @executions.page(params[:page]).per(10)
      else
        # Pour les autres utilisateurs
        @machines = Machine.order(created_at: :desc)
    
        # Application des filtres
        if params[:conducteur_info].present?
          @machines = @machines.joins(:tractor)
                               .where("tractors.name ILIKE ?", "%#{params[:conducteur_info]}%")
        end
    
        if params[:year].present?
          @machines = @machines.where(year: params[:year])
        end
    
        @machines = @machines.page(params[:page]).per(10)
      end
    end
    
  end
  