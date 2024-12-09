require "application_system_test_case"

class HerbicidesTest < ApplicationSystemTestCase
  setup do
    @herbicide = herbicides(:one)
  end

  test "visiting the index" do
    visit herbicides_url
    assert_selector "h1", text: "Herbicides"
  end

  test "should create herbicide" do
    visit herbicides_url
    click_on "New herbicide"

    fill_in "Nom", with: @herbicide.nom
    fill_in "Prix", with: @herbicide.prix
    click_on "Create Herbicide"

    assert_text "Herbicide was successfully created"
    click_on "Back"
  end

  test "should update Herbicide" do
    visit herbicide_url(@herbicide)
    click_on "Edit this herbicide", match: :first

    fill_in "Nom", with: @herbicide.nom
    fill_in "Prix", with: @herbicide.prix
    click_on "Update Herbicide"

    assert_text "Herbicide was successfully updated"
    click_on "Back"
  end

  test "should destroy Herbicide" do
    visit herbicide_url(@herbicide)
    click_on "Destroy this herbicide", match: :first

    assert_text "Herbicide was successfully destroyed"
  end
end
