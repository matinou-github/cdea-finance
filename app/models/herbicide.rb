class Herbicide < ApplicationRecord

  has_many :service_request_herbicides
  has_many :service_requests, through: :service_request_herbicides
  #   def as_json(options = {})
  #   super(options).merge(prix: prix)
  # end
end
