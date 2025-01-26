class Execution < ApplicationRecord
  belongs_to :service_request
  belongs_to :user
 # has_one_attached :preuve

  has_many :machines, dependent: :destroy
  accepts_nested_attributes_for :machines, allow_destroy: true
end
