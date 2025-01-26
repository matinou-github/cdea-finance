Cloudinary.config do |config|
  config.cache_storage = :file
  config.fog_provider = 'fog/cloudinary'
  config.fog_credentials = {
    provider: "Cloudinary",
    cloud_name: "cdae",
    api_key: "812923897776882",
    api_secret: "rPl85HI8dbOdU5fNjMYKDwTE-Ng"
  }

end
