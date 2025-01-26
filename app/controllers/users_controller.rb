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
        redirect_to dashboard_accueil_path
      else
        flash[:alert] = "Veuillez corriger les erreurs."
        render :complete_profile
      end
    end
    def show

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


    def upload_identity_card
      uploaded_file = params[:user][:file]
      commune = params[:user][:commune]
      village = params[:user][:village]
    
      if uploaded_file.present?
        Rails.logger.info "Fichier reçu : #{uploaded_file.original_filename}"
    
        # Métadonnées pour le fichier
        file_metadata = {
          name: "#{current_user.id}_identity_card",
          parents: ['1r7lP6VfEEYeOLuaXa0DnWhJ5mfeSeXes'] # Placer le fichier dans le dossier cible
        }

        # Téléversement du fichier vers Google Drive
        file = DRIVE_SERVICE.create_file(
          file_metadata,
          fields: 'id',
          upload_source: uploaded_file.tempfile,
          content_type: uploaded_file.content_type
        )
    
        # Définir les permissions pour que le fichier soit accessible publiquement
        DRIVE_SERVICE.create_permission(
          file.id,
          Google::Apis::DriveV3::Permission.new(
            type: 'anyone',
            role: 'reader'
          )
        )
    
        Rails.logger.info "Fichier envoyé à Google Drive avec l'ID : #{file.id}"
    
        # Générer l'URL publique et l'enregistrer
        url = "https://drive.google.com/uc?id=#{file.id}"

        current_user.update(identity_card_photo: url, commune: commune, village: village)
    
        redirect_to dashboard_profile_path, notice: 'Fichier téléversé avec succès.'
      else
        flash[:alert] = 'Aucun fichier reçu.'
        redirect_to dashboard_profile_path
      end
    rescue Google::Apis::Error => e
      Rails.logger.error "Erreur lors de l'envoi à Google Drive : #{e.message}"
      flash[:alert] = "Une erreur s'est produite lors de l'envoi à Google Drive."
      redirect_to dashboard_profile_path
    rescue => e
      Rails.logger.error "Erreur inattendue : #{e.message}"
      flash[:alert] = "Une erreur inattendue s'est produite."
      redirect_to dashboard_profile_path
    end
    
 
    private

    def set_user
      @user = User.find(params[:id])
    end
  
    # Strong parameters pour les champs supplémentaires
    def user_profile_params
      params.require(:user).permit(:nom, :prenom, :email, :phone_number, :commune, :role, :village, :identity_card_photo, :zone, :password, :password_confirmation, :identification, :photo_courte, :photo_complete)
    end
  end
  