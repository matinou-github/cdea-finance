class Depense < ApplicationRecord
  belongs_to :fonctionnement

  validates :intitule, presence: true
  validates :cout_unitaire, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true
  validates :montant_total, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

end
