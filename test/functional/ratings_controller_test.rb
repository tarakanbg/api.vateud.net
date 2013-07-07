require 'test_helper'

class RatingsControllerTest < ActionController::TestCase
  setup do
    @rating = ratings(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ratings)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rating" do
    assert_difference('Rating.count') do
      post :create, rating: {  }
    end

    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should show rating" do
    get :show, id: @rating
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rating
    assert_response :success
  end

  test "should update rating" do
    put :update, id: @rating, rating: {  }
    assert_redirected_to rating_path(assigns(:rating))
  end

  test "should destroy rating" do
    assert_difference('Rating.count', -1) do
      delete :destroy, id: @rating
    end

    assert_redirected_to ratings_path
  end
end
