class Balance < ApplicationRecord
    belongs_to :user
    validates :year, presence: true, numericality: { only_integer: true }

    
  end