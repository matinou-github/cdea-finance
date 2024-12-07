class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # Permet la connexion avec un email ou un numéro de téléphone
  attr_writer :login

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
