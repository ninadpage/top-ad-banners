class Click < ApplicationRecord
  has_many :conversions

  scope :for_campaign, ->(campaign_id) {where(campaign_id: campaign_id)}
end
