require 'google/apis/drive_v3'
require 'googleauth'
require 'json'
require 'dotenv/load' if Rails.env.development? || Rails.env.test?

# Vérifiez si GOOGLE_DRIVE_CREDENTIALS est définie
google_drive_credentials = Rails.application.credentials.dig(:google_drive, :credentials)



begin
  # Charge et parse le contenu de GOOGLE_DRIVE_CREDENTIALS
  google_drive_credentials = JSON.parse(ENV['GOOGLE_DRIVE_CREDENTIALS'])
rescue JSON::ParserError => e
  raise "Erreur de parsing du JSON dans GOOGLE_DRIVE_CREDENTIALS : #{e.message}"
end

# Configure le service Google Drive
DRIVE_SERVICE = Google::Apis::DriveV3::DriveService.new

begin
  DRIVE_SERVICE.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: StringIO.new(ENV['GOOGLE_DRIVE_CREDENTIALS']),
    scope: ['https://www.googleapis.com/auth/drive']
  )
rescue => e
  raise "Erreur lors de la configuration des credentials Google Drive : #{e.message}"
end

puts "Service Google Drive configuré avec succès."
