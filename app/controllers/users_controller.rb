class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  layout "dashboard"
  
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

    def edit

    end
  
    # PATCH/PUT /users/:id
    def update
      # Convertir les paramètres en Hash et supprimer les champs vides pour le mot de passe
      clean_params = user_profile_params.to_h
      clean_params.except!(:password, :password_confirmation) if clean_params[:password].blank?
    
      if @user.update(clean_params)
        if current_user.role == "admin" && current_user.id !=  @user.id
          redirect_to dashboard_list_user_path
        else
          redirect_to dashboard_accueil_path, notice: "Profil mis à jour avec succès."
        end
      else
        # Debugger pour inspecter les erreurs
        puts @user.errors.full_messages
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      redirect_to dashboard_list_user_path, notice: 'Utilisateur supprimé avec succès.'
    end
  
    private

    def set_user
      @user = User.find(params[:id])
    end
  
    # Strong parameters pour les champs supplémentaires
    def user_profile_params
      params.require(:user).permit(:nom, :prenom, :email, :phone_number, :commune, :role, :village, :identity_card_photo, :zone, :password, :password_confirmation)
    end
  end
  