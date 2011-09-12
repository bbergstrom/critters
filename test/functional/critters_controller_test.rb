require 'test_helper'

class CrittersControllerTest < ActionController::TestCase
  setup do
    @critter = critters(:one)
    # And lets fake a user session for now.
    session[:user_id] = User.first
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:critters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create critter" do
    assert_difference('Critter.count') do
      post :create, :critter => @critter.attributes
    end

    assert_redirected_to critter_path(assigns(:critter))
  end

  test "should show critter" do
    get :show, :id => @critter.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @critter.to_param
    assert_response :success
  end

  test "should update critter" do
    put :update, :id => @critter.to_param, :critter => @critter.attributes
    assert_redirected_to critter_path(assigns(:critter))
  end

  test "should destroy critter" do
    assert_difference('Critter.count', -1) do
      delete :destroy, :id => @critter.to_param
    end

    assert_redirected_to critters_path
  end
end
