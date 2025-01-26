class Remboursement < ApplicationRecord
  belongs_to :user
  belongs_to :credite_par, class_name: 'User'
  validates :type_remboursement, presence: true, inclusion: { in: ['nature', 'numeraire', 'Remb/garantie', 'Remb/mais', 'Remb/surplus'] }
  validates :valeurs, presence: true
  validates :credite_par, presence: true
  
  # Validation du type de remboursement
  #validates :type_remboursement, inclusion: { in: ['nature', 'numeraire'] }

  # Callbacks
  after_create :update_balance
  after_update :update_balance
  def update_balance
    # On récupère l'année de la demande de service
    year = self.year
    indice_setting = IndiceSetting.last
    valeur_soja = indice_setting.valeur_soja
    # On récupère ou crée la balance de l'utilisateur pour l'année
    balance = Balance.find_or_create_by(user_id: self.user_id, year: year)

    if self.saved_change_to_valeurs?
      old_valeurs = self.valeurs_before_last_save || 0
    else
      old_valeurs = self.valeurs
    end
    
    # Calculer la différence
    delta = self.valeurs - old_valeurs
     p delta

    # Si le remboursement est de type 'nature'
    if self.type_remboursement == 'nature'
      # Mise à jour du total des remboursements pour 'nature'
      balance.total_remboursement += delta
      new_kg_restants = balance.total_kg_paye - balance.total_remboursement
      new_kg_restants = [new_kg_restants, 0].max
      new_valeur_restant = new_kg_restants * valeur_soja
      
      balance.kg_restants = new_kg_restants
      balance.valeur_restants = new_valeur_restant
  
    elsif self.type_remboursement == 'Remb/garantie'
      # Mise à jour du total des remboursements pour 'nature'
      balance.total_remboursement += delta
      new_kg_restants = balance.total_kg_paye - balance.total_remboursement
      new_kg_restants = [new_kg_restants, 0].max
      new_valeur_restant = new_kg_restants * valeur_soja
      
      balance.kg_restants = new_kg_restants
      balance.valeur_restants = new_valeur_restant

      

    elsif self.type_remboursement == 'Remb/mais'
      # Mise à jour du total des remboursements pour 'nature'
      balance.total_remboursement += delta
      new_kg_restants = balance.total_kg_paye - balance.total_remboursement
      new_kg_restants = [new_kg_restants, 0].max
      new_valeur_restant = new_kg_restants * valeur_soja
      
      balance.kg_restants = new_kg_restants
      balance.valeur_restants = new_valeur_restant

    elsif self.type_remboursement == 'Remb/surplus'
      # Mise à jour du total des remboursements pour 'nature'
      balance.total_remboursement += delta
      new_kg_restants = balance.total_kg_paye - balance.total_remboursement
      new_kg_restants = [new_kg_restants, 0].max
      new_valeur_restant = new_kg_restants * valeur_soja
      
      balance.kg_restants = new_kg_restants
      balance.valeur_restants = new_valeur_restant
      balance.etat_garantie = 'Remb/surplus'


    elsif self.type_remboursement == 'numeraire'
      # Si le remboursement est en numéraire, on applique les calculs nécessaires

      # Récupérer le montant du remboursement numéraire
      montant = delta.to_f

      # Vérification que le montant est inférieur ou égal à la valeur majorée numéraire

        # Calcul de l'équivalent en kg pour le remboursement
        kg_equivalent = (montant / IndiceSetting.last.valeur_soja).round(2)
        p '1111111111111111'
        p kg_equivalent
        # Mise à jour des balances
        new_remboursement = balance.total_remboursement + kg_equivalent
        #new_kg_restants = balance.kg_restants - kg_equivalent
        new_kg_restants = balance.total_kg_paye - new_remboursement
        # Si les valeurs deviennent négatives, on les réinitialise à zéro
        new_kg_restants = [new_kg_restants, 0].max
        new_valeur_restant = new_kg_restants * valeur_soja
        # Mise à jour de la balance avec les nouvelles valeurs
        balance.update!(
          kg_restants: new_kg_restants,
          total_remboursement: new_remboursement,
          valeur_restants: new_valeur_restant
        )

    end

    # Sauvegarde de la balance après modification
    if balance.total_remboursement == balance.total_kg_paye
      balance.update!(status: "Terminé")
    else
      balance.update!(status: "en cours")
    end
    balance.save


  end

 
end
