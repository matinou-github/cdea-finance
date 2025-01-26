require "application_system_test_case"

class FonctionnementsTest < ApplicationSystemTestCase
  setup do
    @fonctionnement = fonctionnements(:one)
  end

  test "visiting the index" do
    visit fonctionnements_url
    assert_selector "h1", text: "Fonctionnements"
  end

  test "should create fonctionnement" do
    visit fonctionnements_url
    click_on "New fonctionnement"

    fill_in "Campagne", with: @fonctionnement.campagne
    fill_in "Cout unitaire", with: @fonctionnement.cout_unitaire
    fill_in "Total depense", with: @fonctionnement.total_depense
    fill_in "Tractor", with: @fonctionnement.tractor_id
    fill_in "User", with: @fonctionnement.user_id
    click_on "Create Fonctionnement"

    assert_text "Fonctionnement was successfully created"
    click_on "Back"
  end

  test "should update Fonctionnement" do
    visit fonctionnement_url(@fonctionnement)
    click_on "Edit this fonctionnement", match: :first

    fill_in "Campagne", with: @fonctionnement.campagne
    fill_in "Cout unitaire", with: @fonctionnement.cout_unitaire
    fill_in "Total depense", with: @fonctionnement.total_depense
    fill_in "Tractor", with: @fonctionnement.tractor_id
    fill_in "User", with: @fonctionnement.user_id
    click_on "Update Fonctionnement"

    assert_text "Fonctionnement was successfully updated"
    click_on "Back"
  end

  test "should destroy Fonctionnement" do
    visit fonctionnement_url(@fonctionnement)
    click_on "Destroy this fonctionnement", match: :first

    assert_text "Fonctionnement was successfully destroyed"
  end
end
