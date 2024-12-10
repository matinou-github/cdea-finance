class Execution < ApplicationRecord
  belongs_to :service_request
  has_one_attached :preuve
  belongs_to :user
end
