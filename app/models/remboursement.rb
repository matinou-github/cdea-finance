class Remboursement < ApplicationRecord
  belongs_to :user
  belongs_to :credite_par, class_name: 'User'
  belongs_to :service_request
  validates :type_remboursement, presence: true, inclusion: { in: ['nature', 'numeraire'] }
  validates :valeurs, presence: true
  validates :credite_par, presence: true
end
