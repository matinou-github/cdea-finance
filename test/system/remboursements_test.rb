require "application_system_test_case"

class RemboursementsTest < ApplicationSystemTestCase
  setup do
    @remboursement = remboursements(:one)
  end

  test "visiting the index" do
    visit remboursements_url
    assert_selector "h1", text: "Remboursements"
  end

  test "should create remboursement" do
    visit remboursements_url
    click_on "New remboursement"

    fill_in "Credite par", with: @remboursement.credite_par_id
    fill_in "Type remboursement", with: @remboursement.type_remboursement
    fill_in "User", with: @remboursement.user_id
    fill_in "Valeurs", with: @remboursement.valeurs
    click_on "Create Remboursement"

    assert_text "Remboursement was successfully created"
    click_on "Back"
  end

  test "should update Remboursement" do
    visit remboursement_url(@remboursement)
    click_on "Edit this remboursement", match: :first

    fill_in "Credite par", with: @remboursement.credite_par_id
    fill_in "Type remboursement", with: @remboursement.type_remboursement
    fill_in "User", with: @remboursement.user_id
    fill_in "Valeurs", with: @remboursement.valeurs
    click_on "Update Remboursement"

    assert_text "Remboursement was successfully updated"
    click_on "Back"
  end

  test "should destroy Remboursement" do
    visit remboursement_url(@remboursement)
    click_on "Destroy this remboursement", match: :first

    assert_text "Remboursement was successfully destroyed"
  end
end
