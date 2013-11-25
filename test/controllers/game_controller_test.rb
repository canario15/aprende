require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test "should get new_game" do
    get :new_game
    assert_response :success
  end

  test "should get eval_answer" do
    get :eval_answer
    assert_response :success
  end

  test "should get reset_game" do
    get :reset_game
    assert_response :success
  end

end
