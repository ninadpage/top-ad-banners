require 'test_helper'

class ClickTest < ActiveSupport::TestCase
  test 'Should save two clicks for same banner and campaign' do
    assert_not_nil Click.create banner_id: 3, campaign_id: 1
    assert_not_nil Click.create banner_id: 3, campaign_id: 1
  end
end
