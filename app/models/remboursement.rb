class Remboursement < ApplicationRecord
  belongs_to :user
  belongs_to :credite_par, class_name: 'User'
  validates :type_remboursement, presence: true, inclusion: { in: ['nature', 'numeraire'] }
  validates :valeurs, presence: true
  validates :credite_par, presence: true
  
  # Validation du type de remboursement
  validates :type_remboursement, inclusion: { in: ['nature', 'numeraire'] }

  # Callbacks
  after_create :update_balance

  def update_balance
    # On récupère l'année de la demande de service
    year = self.year
    indice_setting = IndiceSetting.last
    valeur_soja = indice_setting.valeur_soja
    # On récupère ou crée la balance de l'utilisateur pour l'année
    balance = Balance.find_or_create_by(user_id: self.user_id, year: year)

    # Si le remboursement est de type 'nature'
    if self.type_remboursement == 'nature'
      # Mise à jour du total des remboursements pour 'nature'
      balance.total_remboursement += self.valeurs
      new_kg_restants = balance.total_kg_paye - balance.total_remboursement
      new_kg_restants = [new_kg_restants, 0].max
      new_valeur_restant = new_kg_restants * valeur_soja
      
      balance.kg_restants = new_kg_restants
      balance.valeur_restants = new_valeur_restant

    elsif self.type_remboursement == 'numeraire'
      # Si le remboursement est en numéraire, on applique les calculs nécessaires

      # Récupérer le montant du remboursement numéraire
      montant = self.valeurs.to_f

      # Vérification que le montant est inférieur ou égal à la valeur majorée numéraire
      if montant <= balance.valeur_majoree_numeraire
        # Calcul de l'équivalent en kg pour le remboursement
        kg_equivalent = (montant / IndiceSetting.last.valeur_soja).round(2)

        # Mise à jour des balances
        new_valeur_kg = balance.valeur_majoree_kg - kg_equivalent
        new_remboursement = balance.total_remboursement + kg_equivalent
        new_kg_restants = balance.kg_restants - kg_equivalent

        # Si les valeurs deviennent négatives, on les réinitialise à zéro
        new_valeur_kg = [new_valeur_kg, 0].max
        new_kg_restants = [new_kg_restants, 0].max
        new_valeur_restant = new_kg_restants * valeur_soja
        # Mise à jour de la balance avec les nouvelles valeurs
        balance.update!(
          valeur_majoree_numeraire: balance.valeur_majoree_numeraire - montant,
          valeur_majoree_kg: new_valeur_kg,
          kg_restants: new_kg_restants,
          total_remboursement: new_remboursement,
          valeur_restants: new_valeur_restant
        )
      else
        errors.add(:valeurs, "Le montant du remboursement numéraire dépasse la valeur majorée.")
        return false
      end
    end

    # Sauvegarde de la balance après modification
    balance.save


  end

 
end
