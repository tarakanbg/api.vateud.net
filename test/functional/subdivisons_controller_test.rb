require 'test_helper'

class SubdivisonsControllerTest < ActionController::TestCase
  setup do
    @subdivison = subdivisons(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subdivisons)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subdivison" do
    assert_difference('Subdivison.count') do
      post :create, subdivison: {  }
    end

    assert_redirected_to subdivison_path(assigns(:subdivison))
  end

  test "should show subdivison" do
    get :show, id: @subdivison
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subdivison
    assert_response :success
  end

  test "should update subdivison" do
    put :update, id: @subdivison, subdivison: {  }
    assert_redirected_to subdivison_path(assigns(:subdivison))
  end

  test "should destroy subdivison" do
    assert_difference('Subdivison.count', -1) do
      delete :destroy, id: @subdivison
    end

    assert_redirected_to subdivisons_path
  end
end
