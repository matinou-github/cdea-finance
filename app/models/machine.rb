class Machine < ApplicationRecord
  belongs_to :execution
  belongs_to :tractor
  has_one_attached :preuve
end
