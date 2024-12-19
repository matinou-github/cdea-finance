class ServiceRequest < ApplicationRecord

  after_save :update_annual_balance
  
  belongs_to :user
  #has_many :remboursements, dependent: :destroy

  has_many :service_request_herbicides, dependent: :destroy
  has_many :herbicides, through: :service_request_herbicides

  accepts_nested_attributes_for :service_request_herbicides

validates :superficie, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validates :herbicide_quantite, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validate :au_moins_un_champ

# def nature_sum
#   remboursements.where(type_remboursement: "nature").sum(:valeurs)
# end

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

  def update_annual_balance
    # Trouver ou créer le balance annuel de l'utilisateur pour l'année courante
    annual_balance = AnnualBalance.find_or_create_by(year: Time.current.year, user_id: user_id)

    # Mettre à jour les valeurs du cumul
    annual_balance.total_kg += kg_paye.to_f
    annual_balance.remaining_due += garantie.to_f
    annual_balance.save!
  end



  def au_moins_un_champ
    if superficie.blank? && herbicide_quantite.blank?
      errors.add(:base, "Vous devez renseigner au moins une superficie ou une quantité d'herbicide.")
    end
  end
end
