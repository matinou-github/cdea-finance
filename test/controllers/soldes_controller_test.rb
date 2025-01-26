require "test_helper"

class SoldesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @solde = soldes(:one)
  end

  test "should get index" do
    get soldes_url
    assert_response :success
  end

  test "should get new" do
    get new_solde_url
    assert_response :success
  end

  test "should create solde" do
    assert_difference("Solde.count") do
      post soldes_url, params: { solde: { campagne: @solde.campagne, cout_unitaire: @solde.cout_unitaire, montant_prestation: @solde.montant_prestation, superficie_labouree: @solde.superficie_labouree, tractor_id: @solde.tractor_id, user_id: @solde.user_id } }
    end

    assert_redirected_to solde_url(Solde.last)
  end

  test "should show solde" do
    get solde_url(@solde)
    assert_response :success
  end

  test "should get edit" do
    get edit_solde_url(@solde)
    assert_response :success
  end

  test "should update solde" do
    patch solde_url(@solde), params: { solde: { campagne: @solde.campagne, cout_unitaire: @solde.cout_unitaire, montant_prestation: @solde.montant_prestation, superficie_labouree: @solde.superficie_labouree, tractor_id: @solde.tractor_id, user_id: @solde.user_id } }
    assert_redirected_to solde_url(@solde)
  end

  test "should destroy solde" do
    assert_difference("Solde.count", -1) do
      delete solde_url(@solde)
    end

    assert_redirected_to soldes_url
  end
end
