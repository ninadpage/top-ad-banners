# Ideally, this should be a subclass of ApplicationRecord, but since its schema is not known,
# let's define it as Plain Old Ruby Object
class Campaign

  MAX_BANNERS = 10
  MIN_BANNERS = 5

  def initialize(campaign_id)
    @campaign_id = campaign_id
  end

  # Returns top x banners which have a click-to-conversion record for this campaign,
  # ordered by total revenue for that banner-campaign combination (it's possible to have multiple click-to-conversions
  # for same banner & campaign)
  # rtype: Array of Click with attributes: banner_id, total_revenue
  def top_x_banners_with_conversions(x)
    Click.joins(:conversions)
        .select('clicks.banner_id, SUM(conversions.revenue) as total_revenue')
        .where(:clicks => {:campaign_id => @campaign_id})
        .group('clicks.banner_id')
        .order('total_revenue DESC')
        .limit(x)
        .to_a
  end

  # Returns top x banners with most clicks associated with this campaign
  # rtype: Array of Click with attributes: banner_id, click_count
  def top_x_banners_with_most_clicks(x)
    Click.select('clicks.banner_id, COUNT(*) as click_count')
        .where({:campaign_id => @campaign_id})
        .group(:banner_id)
        .order('click_count DESC')
        .limit(x)
        .to_a
  end

  # Returns random x banners associated with this campaign
  # rtype: Array of Impression with attributes: banner_id
  def random_x_banners_for_campaign(x)
    Impression.for_campaign(@campaign_id).select(:banner_id).to_a.sample(x)
  end

  # Returns a collection of banners associated with given campaign_id.
  # Banner is chosen according to following criteria:
  # Where x is the amount of banners with click-to-conversion record within a campaign,
  # consider following scenarios -
  #     x > 10 : Top 10 banners based on revenue within that campaign.
  #     5 < x <= 10 : Top x banners based on revenue within that campaign.
  #     0 < x <= 5 : Collection of 5 banners, containing:
  #                 - The Top x banners based on revenue within that campaign.
  #                 - Banners with the most clicks within that campaign, or if no sufficient banners with clicks
  #                   found, random banners within that campaign are added to make up a collection of 5 unique
  #                   banners when needed.
  #     x == 0 : Collection of 5 banners, containing:
  #             - The Top-5 banners based on clicks within that campaign.
  #             - If there are less than 5 banners with clicks within that campaign,
  #               then random banners within that campaign are added to make up a
  #               collection of 5 unique banners.
  #
  # Returns a list of hashes with keys :banner_id and optionally :total_revenue, :click_count
  def get_top_banners_for_campaign
    result = []
    self.top_x_banners_with_conversions(MAX_BANNERS).each do |b|
      result << {:banner_id => b.banner_id, :total_revenue => b.total_revenue}
    end
    return result if result.size > MIN_BANNERS

    self.top_x_banners_with_most_clicks(MIN_BANNERS - result.size).each do |b|
      result << {:banner_id => b.banner_id, :click_count => b.click_count}
    end
    return result if result.size > MIN_BANNERS

    self.random_x_banners_for_campaign(MIN_BANNERS - result.size).each { |b| result << {:banner_id => b.banner_id} }

    result
  end

  # Static method
  def self.get_all_campaign_ids
    Impression.select(:campaign_id).distinct.order(:campaign_id).map { |row| row.campaign_id }
  end
end