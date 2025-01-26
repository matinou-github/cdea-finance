require "application_system_test_case"

class SoldesTest < ApplicationSystemTestCase
  setup do
    @solde = soldes(:one)
  end

  test "visiting the index" do
    visit soldes_url
    assert_selector "h1", text: "Soldes"
  end

  test "should create solde" do
    visit soldes_url
    click_on "New solde"

    fill_in "Campagne", with: @solde.campagne
    fill_in "Cout unitaire", with: @solde.cout_unitaire
    fill_in "Montant prestation", with: @solde.montant_prestation
    fill_in "Superficie labouree", with: @solde.superficie_labouree
    fill_in "Tractor", with: @solde.tractor_id
    fill_in "User", with: @solde.user_id
    click_on "Create Solde"

    assert_text "Solde was successfully created"
    click_on "Back"
  end

  test "should update Solde" do
    visit solde_url(@solde)
    click_on "Edit this solde", match: :first

    fill_in "Campagne", with: @solde.campagne
    fill_in "Cout unitaire", with: @solde.cout_unitaire
    fill_in "Montant prestation", with: @solde.montant_prestation
    fill_in "Superficie labouree", with: @solde.superficie_labouree
    fill_in "Tractor", with: @solde.tractor_id
    fill_in "User", with: @solde.user_id
    click_on "Update Solde"

    assert_text "Solde was successfully updated"
    click_on "Back"
  end

  test "should destroy Solde" do
    visit solde_url(@solde)
    click_on "Destroy this solde", match: :first

    assert_text "Solde was successfully destroyed"
  end
end
