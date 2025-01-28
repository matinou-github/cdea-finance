class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

        enum :role, {:admin=>"admin", :agriculteur=>"agriculteur", :technicien=>"technicien", :secretaire=>"secretaire", :tractoriste=>"tractoriste"}
        has_one_attached :photo_courte
        has_one_attached :photo_complete
        has_one_attached :identity_card_photo
  has_many :zone_assignments, dependent: :destroy
  # Permet la connexion avec un email ou un numéro de téléphone
  attr_writer :login
  has_many :stocks
  has_many :restitutions
  has_many :tractors, dependent: :destroy
  has_many :service_requests, dependent: :destroy
  before_save :set_identification, if: :service_request_executed?
  has_many :executions, dependent: :destroy
  has_many :remboursements, dependent: :destroy
  has_many :fonctionnements, dependent: :destroy
  has_many :remboursements_credite_par, class_name: 'Remboursement', foreign_key: 'credite_par_id'
  def login
    @login || self.phone_number || self.email
  end
  def full_name
    "#{nom} #{prenom}"
  end

  def code_client
    "CL0#{id}#{village}"
  end
  
  # Ajuster la recherche pour l'authentification
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["phone_number = :value OR email = :value", { value: login }]).first
  end

  private

  def set_identification
    # Récupérer tous les utilisateurs du même village qui ont déjà une identification
    users_with_identification = User.where(village: village).where.not(identification: [nil, ''])
  puts users_with_identification
    # Calculer le prochain numéro d'identification basé sur le nombre existant d'utilisateurs avec une identification
    next_number = users_with_identification.count + 1

    # Formater l'identification avec le numéro incrémenté
    self.identification = "CL#{format('%02d', next_number)}#{village.upcase}"
  end

  def service_request_executed?
    service_requests.where(status_request: 'execute').exists?
  end
  
end
