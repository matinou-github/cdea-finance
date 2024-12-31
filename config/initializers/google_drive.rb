require 'google/apis/drive_v3'
require 'googleauth'
require 'json'
require 'dotenv/load' # Charge les variables depuis .env

credentials = JSON.parse(ENV['GOOGLE_DRIVE_CREDENTIALS'])

DRIVE_SERVICE = Google::Apis::DriveV3::DriveService.new
DRIVE_SERVICE.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: StringIO.new(credentials.to_json),
  scope: ['https://www.googleapis.com/auth/drive']
)
