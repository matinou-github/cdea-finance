class Stock < ApplicationRecord
  belongs_to :user

  validates :produit, presence: true, inclusion: { in: ['soja', 'mais', 'cash'] }
end
