require 'google/apis/drive_v3'
require 'googleauth'
require 'json'
require 'dotenv/load' # Charge les variables d'environnement depuis .env

# Charge les informations d'identification JSON depuis la variable d'environnement
begin
  google_drive_credentials = JSON.parse(ENV['GOOGLE_DRIVE_CREDENTIALS'])
rescue JSON::ParserError => e
  raise "Erreur de parsing des credentials Google Drive : #{e.message}. Vérifiez le format de la variable GOOGLE_DRIVE_CREDENTIALS."
end

# Crée un service Google Drive
DRIVE_SERVICE = Google::Apis::DriveV3::DriveService.new

# Autorisation via les informations d'identification de service
DRIVE_SERVICE.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: StringIO.new(google_drive_credentials.to_json), # Passe les informations d'identification sous forme de JSON
  scope: ['https://www.googleapis.com/auth/drive'] # Définissez les autorisations requises
)

# Test pour vérifier la connexion
begin
  response = DRIVE_SERVICE.list_files(page_size: 10)
  puts "Fichiers récupérés avec succès:"
  response.files.each { |file| puts "#{file.name} (#{file.id})" }
rescue Google::Apis::Error => e
  puts "Erreur lors de l'appel à l'API Google Drive: #{e.message}"
end
