class ServiceRequestHerbicide < ApplicationRecord
    belongs_to :service_request
    belongs_to :herbicide
  end
  