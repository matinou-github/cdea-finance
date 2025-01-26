class Fonctionnement < ApplicationRecord
  has_many :depenses, dependent: :destroy
  accepts_nested_attributes_for :depenses, allow_destroy: true
  belongs_to :user
  belongs_to :tractor
  before_save :calculate_total_depense

  private

  def calculate_total_depense
    self.total_depense = depenses.sum { |depense| depense.cout_unitaire.to_f * depense.quantite.to_i }
  end
end