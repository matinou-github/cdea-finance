require "test_helper"

class RestitutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restitution = restitutions(:one)
  end

  test "should get index" do
    get restitutions_url
    assert_response :success
  end

  test "should get new" do
    get new_restitution_url
    assert_response :success
  end

  test "should create restitution" do
    assert_difference("Restitution.count") do
      post restitutions_url, params: { restitution: { balance_id_id: @restitution.balance_id_id, garantie: @restitution.garantie, user_id_id: @restitution.user_id_id } }
    end

    assert_redirected_to restitution_url(Restitution.last)
  end

  test "should show restitution" do
    get restitution_url(@restitution)
    assert_response :success
  end

  test "should get edit" do
    get edit_restitution_url(@restitution)
    assert_response :success
  end

  test "should update restitution" do
    patch restitution_url(@restitution), params: { restitution: { balance_id_id: @restitution.balance_id_id, garantie: @restitution.garantie, user_id_id: @restitution.user_id_id } }
    assert_redirected_to restitution_url(@restitution)
  end

  test "should destroy restitution" do
    assert_difference("Restitution.count", -1) do
      delete restitution_url(@restitution)
    end

    assert_redirected_to restitutions_url
  end
end
