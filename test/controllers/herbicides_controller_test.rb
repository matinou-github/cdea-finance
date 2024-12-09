require "test_helper"

class HerbicidesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @herbicide = herbicides(:one)
  end

  test "should get index" do
    get herbicides_url
    assert_response :success
  end

  test "should get new" do
    get new_herbicide_url
    assert_response :success
  end

  test "should create herbicide" do
    assert_difference("Herbicide.count") do
      post herbicides_url, params: { herbicide: { nom: @herbicide.nom, prix: @herbicide.prix } }
    end

    assert_redirected_to herbicide_url(Herbicide.last)
  end

  test "should show herbicide" do
    get herbicide_url(@herbicide)
    assert_response :success
  end

  test "should get edit" do
    get edit_herbicide_url(@herbicide)
    assert_response :success
  end

  test "should update herbicide" do
    patch herbicide_url(@herbicide), params: { herbicide: { nom: @herbicide.nom, prix: @herbicide.prix } }
    assert_redirected_to herbicide_url(@herbicide)
  end

  test "should destroy herbicide" do
    assert_difference("Herbicide.count", -1) do
      delete herbicide_url(@herbicide)
    end

    assert_redirected_to herbicides_url
  end
end
