class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

         enum role: {
          admin: "admin",
          agriculteur: "agriculteur",
          technicien: "technicien",
          secretaire: "secretaire"
        }
  has_many :zone_assignments, dependent: :destroy
  # Permet la connexion avec un email ou un numéro de téléphone
  attr_writer :login
  has_many :service_requests
  has_many :executions
  has_many :remboursements
  has_many :remboursements_credite_par, class_name: 'Remboursement', foreign_key: 'credite_par_id'
  def login
    @login || self.phone_number || self.email
  end

  # Ajuster la recherche pour l'authentification
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    where(conditions).where(["phone_number = :value OR email = :value", { value: login }]).first
  end
  
end
