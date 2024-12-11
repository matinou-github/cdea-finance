class ServiceRequest < ApplicationRecord
  belongs_to :user
  belongs_to :herbicide, optional: true
  has_many :remboursements, dependent: :destroy

validates :superficie, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validates :herbicide_quantite, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validate :au_moins_un_champ

def nature_sum
  remboursements.where(type_remboursement: "nature").sum(:valeurs)
end

 def dette(valeur_deduit)
    if valeur_deduit > 0
      valeur_deduit.to_f - numeraire_sum.to_f
    else
      0
    end
  end

  def status_payement
    case status
    when 'paid'
      'Payé'
    else
      'Impayé'
    end
  end

  def status_demande
    case status_request
    when 'pending'
      'En attente'
    when 'confirm'
      'Confirmé'
    when 'execute'
      'Terminé'
    else
      'Rejeté'
    end
  end
  
  private



  def au_moins_un_champ
    if superficie.blank? && herbicide_quantite.blank?
      errors.add(:base, "Vous devez renseigner au moins une superficie ou une quantité d'herbicide.")
    end
  end
end
