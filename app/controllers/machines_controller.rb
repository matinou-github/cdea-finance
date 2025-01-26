class MachinesController < ApplicationController
  layout "dashboard"
  
    # Affiche le formulaire de complétion du profil
    def index
      @machines = Machine.page(params[:page]).per(10)
    end
  
   
  end
  