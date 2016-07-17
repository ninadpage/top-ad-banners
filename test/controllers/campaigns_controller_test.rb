require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get '/campaigns/index'
    assert_response :success
  end

  test "should get show" do
    get '/campaigns/show'
    assert_response :success
  end

end
