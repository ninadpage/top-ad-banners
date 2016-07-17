require 'test_helper'

class ConversionTest < ActiveSupport::TestCase
  test 'Should not save conversion without valid click_id' do
    assert_raise { Conversion.create click: 1000000, revenue: 1.0 }
  end

  test 'Should save conversion' do
    assert_not_nil Conversion.create click: Click.find(1), revenue: 1.0
  end
end
