class UsersController < ApplicationController
    before_action :authenticate_user!
  
    # Affiche le formulaire de complétion du profil
    def complete_profile
      @user = current_user
    end
  
    # Met à jour les informations du profil
    def update_profile
      @user = current_user
      if @user.update(user_profile_params)
        flash[:notice] = "Profil complété avec succès !"
        redirect_to dashboard_index_path
      else
        flash[:alert] = "Veuillez corriger les erreurs."
        render :complete_profile
      end
    end
  
    private
  
    # Strong parameters pour les champs supplémentaires
    def user_profile_params
      params.require(:user).permit(:commune, :village, :identity_card_photo)
    end
  end
  