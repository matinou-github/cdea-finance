json.extract! service_request, :id, :user_id, :superficie, :herbicide_nom, :herbicide_prix, :herbicide_quantite, :garantie, :herbicide_id, :preuve, :status, :created_at, :updated_at
json.url service_request_url(service_request, format: :json)
