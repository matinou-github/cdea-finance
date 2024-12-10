json.extract! remboursement, :id, :user_id, :type_remboursement, :valeurs, :credite_par_id, :created_at, :updated_at
json.url remboursement_url(remboursement, format: :json)
