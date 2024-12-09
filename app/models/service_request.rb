class ServiceRequest < ApplicationRecord
  belongs_to :user
  belongs_to :herbicide, optional: true
  

validates :superficie, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validates :herbicide_quantite, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validate :au_moins_un_champ



  private



  def au_moins_un_champ
    if superficie.blank? && herbicide_quantite.blank?
      errors.add(:base, "Vous devez renseigner au moins une superficie ou une quantité d'herbicide.")
    end
  end
end
