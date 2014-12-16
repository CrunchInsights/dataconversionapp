require 'test_helper'

class DatauploadersControllerTest < ActionController::TestCase
  setup do
    @datauploader = datauploaders(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:datauploaders)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create datauploader" do
    assert_difference('Datauploader.count') do
      post :create, datauploader: {  }
    end

    assert_redirected_to datauploader_path(assigns(:datauploader))
  end

  test "should show datauploader" do
    get :show, id: @datauploader
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @datauploader
    assert_response :success
  end

  test "should update datauploader" do
    patch :update, id: @datauploader, datauploader: {  }
    assert_redirected_to datauploader_path(assigns(:datauploader))
  end

  test "should destroy datauploader" do
    assert_difference('Datauploader.count', -1) do
      delete :destroy, id: @datauploader
    end

    assert_redirected_to datauploaders_path
  end
end
