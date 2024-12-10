require "test_helper"

class RemboursementsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @remboursement = remboursements(:one)
  end

  test "should get index" do
    get remboursements_url
    assert_response :success
  end

  test "should get new" do
    get new_remboursement_url
    assert_response :success
  end

  test "should create remboursement" do
    assert_difference("Remboursement.count") do
      post remboursements_url, params: { remboursement: { credite_par_id: @remboursement.credite_par_id, type_remboursement: @remboursement.type_remboursement, user_id: @remboursement.user_id, valeurs: @remboursement.valeurs } }
    end

    assert_redirected_to remboursement_url(Remboursement.last)
  end

  test "should show remboursement" do
    get remboursement_url(@remboursement)
    assert_response :success
  end

  test "should get edit" do
    get edit_remboursement_url(@remboursement)
    assert_response :success
  end

  test "should update remboursement" do
    patch remboursement_url(@remboursement), params: { remboursement: { credite_par_id: @remboursement.credite_par_id, type_remboursement: @remboursement.type_remboursement, user_id: @remboursement.user_id, valeurs: @remboursement.valeurs } }
    assert_redirected_to remboursement_url(@remboursement)
  end

  test "should destroy remboursement" do
    assert_difference("Remboursement.count", -1) do
      delete remboursement_url(@remboursement)
    end

    assert_redirected_to remboursements_url
  end
end
