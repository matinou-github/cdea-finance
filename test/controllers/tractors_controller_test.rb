require "test_helper"

class TractorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tractor = tractors(:one)
  end

  test "should get index" do
    get tractors_url
    assert_response :success
  end

  test "should get new" do
    get new_tractor_url
    assert_response :success
  end

  test "should create tractor" do
    assert_difference("Tractor.count") do
      post tractors_url, params: { tractor: { name: @tractor.name, user_id: @tractor.user_id } }
    end

    assert_redirected_to tractor_url(Tractor.last)
  end

  test "should show tractor" do
    get tractor_url(@tractor)
    assert_response :success
  end

  test "should get edit" do
    get edit_tractor_url(@tractor)
    assert_response :success
  end

  test "should update tractor" do
    patch tractor_url(@tractor), params: { tractor: { name: @tractor.name, user_id: @tractor.user_id } }
    assert_redirected_to tractor_url(@tractor)
  end

  test "should destroy tractor" do
    assert_difference("Tractor.count", -1) do
      delete tractor_url(@tractor)
    end

    assert_redirected_to tractors_url
  end
end
