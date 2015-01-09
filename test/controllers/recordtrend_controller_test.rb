require 'test_helper'

class RecordtrendControllerTest < ActionController::TestCase
  test "should get simpletrend" do
    get :simpletrend
    assert_response :success
  end

end
