require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test 'Should return 10 conversions' do
    campaign = Campaign.new(2)
    result = campaign.get_top_banners_for_campaign
    assert_equal 10, result.size
    result.each {|r| assert_not_nil r[:total_revenue]}
    result.each {|r| assert_not r.key? (:click_count)}
  end

  test 'Should return most revenue first' do
    campaign = Campaign.new(2)
    result = campaign.get_top_banners_for_campaign
    assert_equal 15, result[0][:banner_id]
  end

  test 'Should return 8 conversions' do
    campaign = Campaign.new(3)
    result = campaign.get_top_banners_for_campaign
    assert_equal 8, result.size
    result.each {|r| assert_not_nil r[:total_revenue]}
    result.each {|r| assert_not r.key? (:click_count)}
  end

  test 'Should return 3 conversions 2 clicks' do
    campaign = Campaign.new(4)
    result = campaign.get_top_banners_for_campaign
    assert_equal 5, result.size
    result[0..2].each {|r| assert_not_nil r[:total_revenue]}
    result[0..2].each {|r| assert_not r.key? (:click_count)}
    result[3..4].each {|r| assert_not_nil r[:click_count]}
    result[3..4].each {|r| assert_not r.key? (:total_revenue)}
  end

  test 'Should return most clicks first for clicks' do
    campaign = Campaign.new(4)
    result = campaign.get_top_banners_for_campaign
    # First 3 are be banners with revenue
    assert_equal 45, result[3][:banner_id]
  end

  test 'Should return 3 clicks 2 random' do
    campaign = Campaign.new(5)
    result = campaign.get_top_banners_for_campaign
    assert_equal 5, result.size
    result[0..2].each {|r| assert_not_nil r[:click_count]}
    result[0..2].each {|r| assert_not r.key? (:total_revenue)}
    result[3..4].each {|r| assert_not r.key? (:total_revenue)}
    result[3..4].each {|r| assert_not r.key? (:click_count)}
  end

  test 'Should return most clicks first for clicks+random' do
    campaign = Campaign.new(5)
    result = campaign.get_top_banners_for_campaign
    assert_equal 52, result[0][:banner_id]
  end

  test 'Should return 2 random' do
    campaign = Campaign.new(6)
    result = campaign.get_top_banners_for_campaign
    assert_equal 2, result.size
    result.each {|r| assert_not r.key? (:total_revenue)}
    result.each {|r| assert_not r.key? (:click_count)}
  end

  test 'Should return empty for invalid input' do
    # Non-existing campaign
    campaign = Campaign.new(0)
    result = campaign.get_top_banners_for_campaign
    assert_empty result
  end

  test 'Should return distinct banner ids' do
    2.upto(6) do |i|
      campaign = Campaign.new(i)
      result = campaign.get_top_banners_for_campaign.pluck(:banner_id)
      assert_equal result.uniq, result, "distinct banners expected for campaign id #{i}"
    end
  end
end