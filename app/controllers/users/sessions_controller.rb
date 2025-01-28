# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :configure_sign_in_params, only: [:create]

  # POST /resource/sign_in
  def create
  
    self.resource = warden.authenticate!(auth_options)
  
    if resource
      set_flash_message!(:notice, :signed_in)
      sign_in resource_name, resource
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      flash[:alert] = "Identifiant ou mot de passe incorrect."
      render :new
    end
  end
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # Permettre d'ajouter le paramètre :login
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end
  # Redirection après connexion
  def after_sign_in_path_for(resource)
    # Exemple : redirige vers une page spécifique ou le dashboard
    if current_user.role == "agriculteur" || current_user.role == "technicien" || current_user.role == "tractoriste"
      dashboard_accueil_path
    else
      dashboard_index_path
    end
  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
