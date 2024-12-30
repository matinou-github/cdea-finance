require 'google/apis/drive_v3'
require 'googleauth'

DRIVE_SERVICE = Google::Apis::DriveV3::DriveService.new
DRIVE_SERVICE.authorization = Google::Auth::ServiceAccountCredentials.make_creds(
  json_key_io: File.open('config/google_drive_service_account.json'),
  scope: ['https://www.googleapis.com/auth/drive']
)
