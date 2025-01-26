require "test_helper"

class FonctionnementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @fonctionnement = fonctionnements(:one)
  end

  test "should get index" do
    get fonctionnements_url
    assert_response :success
  end

  test "should get new" do
    get new_fonctionnement_url
    assert_response :success
  end

  test "should create fonctionnement" do
    assert_difference("Fonctionnement.count") do
      post fonctionnements_url, params: { fonctionnement: { campagne: @fonctionnement.campagne, cout_unitaire: @fonctionnement.cout_unitaire, total_depense: @fonctionnement.total_depense, tractor_id: @fonctionnement.tractor_id, user_id: @fonctionnement.user_id } }
    end

    assert_redirected_to fonctionnement_url(Fonctionnement.last)
  end

  test "should show fonctionnement" do
    get fonctionnement_url(@fonctionnement)
    assert_response :success
  end

  test "should get edit" do
    get edit_fonctionnement_url(@fonctionnement)
    assert_response :success
  end

  test "should update fonctionnement" do
    patch fonctionnement_url(@fonctionnement), params: { fonctionnement: { campagne: @fonctionnement.campagne, cout_unitaire: @fonctionnement.cout_unitaire, total_depense: @fonctionnement.total_depense, tractor_id: @fonctionnement.tractor_id, user_id: @fonctionnement.user_id } }
    assert_redirected_to fonctionnement_url(@fonctionnement)
  end

  test "should destroy fonctionnement" do
    assert_difference("Fonctionnement.count", -1) do
      delete fonctionnement_url(@fonctionnement)
    end

    assert_redirected_to fonctionnements_url
  end
end
