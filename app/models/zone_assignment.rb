class ZoneAssignment < ApplicationRecord
    belongs_to :user
    belongs_to :assigned_by, class_name: 'User'
  
    validates :user_id, :zone, :assigned_by_id, presence: true
  
    after_save :update_user_zone
  
    private
  
    def update_user_zone
      user.update(zone: zone) if user.present?
    end
end
