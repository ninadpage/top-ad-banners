require 'test_helper'

class ImpressionTest < ActiveSupport::TestCase
  test 'Should return 12 banners for campaign 2' do
    assert_equal 12, Impression.for_campaign(2).count
  end
end
