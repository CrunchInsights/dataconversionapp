require 'test_helper'

class TrendAnalysisControllerTest < ActionController::TestCase
  test "should get simple_trend" do
    get :simple_trend
    assert_response :success
  end

end
