class Tractor < ApplicationRecord
  belongs_to :user
  validates :name, presence: true
  has_many :machines
end
