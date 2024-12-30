class GoogleDriveUploader
  FOLDER_ID = '1r7lP6VfEEYeOLuaXa0DnWhJ5mfeSeXes' # ID du dossier cible dans Google Drive

  def self.upload_identity_card(file, user)
    return unless file

    begin
      # Créer des métadonnées pour le fichier
      file_metadata = {
        name: "#{user.id}_identity_card.jpg",
        parents: [FOLDER_ID] # Place le fichier dans le dossier cible
      }

      # Téléverser le fichier sur Google Drive
      uploaded_file = DRIVE_SERVICE.create_file(
        file_metadata,
        fields: 'id',
        upload_source: file.path,
        content_type: file.content_type
      )

      # Définir les permissions pour rendre le fichier public
      DRIVE_SERVICE.create_permission(
        uploaded_file.id,
        Google::Apis::DriveV3::Permission.new(
          type: 'anyone',
          role: 'reader'
        )
      )

      # Générer et retourner l'URL publique
      "https://drive.google.com/uc?id=#{uploaded_file.id}"
    rescue Google::Apis::ClientError => e
      Rails.logger.error "Erreur Google Drive: #{e.message}"
      nil
    rescue => e
      Rails.logger.error "Erreur inattendue: #{e.message}"
      nil
    end
  end
end
