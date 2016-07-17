class CampaignsController < ApplicationController
  def index
    @campaign_ids = Campaign.get_all_campaign_ids
  end

  def show
    cache_key = "banners|session|#{session.id}|campaign_id|#{params[:id]}"

    # To make sure all top banners are displayed to a unique visitors, we store the banner IDs in cache
    # for each session ID - campaign ID combination.
    banners = Rails.cache.read(cache_key)

    if banners.nil? or banners.empty?
      campaign = Campaign.new(params[:id])
      # Additionally, to avoid saturation, the order of banners is not based on their revenue/click performance.
      # So we shuffle the result after it is compiled.
      banners = campaign.get_top_banners_for_campaign.shuffle
      if banners.empty?
        # No banners found for this campaign
        banners = [{:banner_id => 0}] * 5
      end
    end
    banner = banners.shift
    # banner always contains its ID, which we store in an instance variable, which is then rendered by the view.
    @banner_id = banner[:banner_id]

    # Now store the remaining banners array back in cache, so that a different banner will be served
    # on the next visit.
    Rails.cache.write(cache_key, banners)
  end
end
