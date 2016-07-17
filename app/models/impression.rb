class Impression < ApplicationRecord
  scope :for_campaign, ->(campaign_id) {where(campaign_id: campaign_id)}
end
