class ServiceRequest < ApplicationRecord
  belongs_to :user
  after_update :update_balance_if_paid
  #has_many :remboursements, dependent: :destroy

  has_many :service_request_herbicides, dependent: :destroy
  has_many :herbicides, through: :service_request_herbicides, dependent: :destroy

  accepts_nested_attributes_for :service_request_herbicides

validates :superficie, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
validates :herbicide_quantite, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

belongs_to :balance, optional: true







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
      'Validé'
    when 'execute'
      'Executé'
    else
      'Rejeté'
    end
  end
  
  private

  def update_balance_if_paid
    update_balance if saved_change_to_status? && status == "paid" && status_request == "execute"
  end


  def update_balance
    @indice_setting = IndiceSetting.last
  
    # Calcul des frais de dossier
    if self.superficie.present?
      frais_dossier = @indice_setting.frais_dossier * self.superficie
    else
      frais_dossier = @indice_setting.frais_dossier
    end
    year = self.created_at.year
    balance = Balance.find_or_create_by(user_id: self.user_id, year: year)
    balance.total_kg_paye += self.kg_paye.to_f
    balance.total_garantie += self.garantie - frais_dossier
    balance.save
  end

 
end
