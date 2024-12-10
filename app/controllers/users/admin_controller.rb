# app/controllers/users/admin_controller.rb

module Users
  class AdminController < ApplicationController
    layout "dashboard"
    def new
      @user = User.new 
    end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to dashboard_list_user_path, notice: "Utilisateur créé avec succès !"
      else
        Rails.logger.error("Échec de la sauvegarde de l'utilisateur : #{@user.errors.full_messages}")
        flash.now[:alert] = @user.errors.full_messages.join(", ")
        render :new
      end
    end

    private

    def user_params
      params.require(:user).permit(:nom, :prenom, :email, :phone_number, :commune, :role, :village, :identity_card_photo, :zone, :password, :password_confirmation)
    end

    # Méthode pour rediriger en fonction du rôle
    
  end
end
