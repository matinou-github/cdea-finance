require "application_system_test_case"

class TractorsTest < ApplicationSystemTestCase
  setup do
    @tractor = tractors(:one)
  end

  test "visiting the index" do
    visit tractors_url
    assert_selector "h1", text: "Tractors"
  end

  test "should create tractor" do
    visit tractors_url
    click_on "New tractor"

    fill_in "Name", with: @tractor.name
    fill_in "User", with: @tractor.user_id
    click_on "Create Tractor"

    assert_text "Tractor was successfully created"
    click_on "Back"
  end

  test "should update Tractor" do
    visit tractor_url(@tractor)
    click_on "Edit this tractor", match: :first

    fill_in "Name", with: @tractor.name
    fill_in "User", with: @tractor.user_id
    click_on "Update Tractor"

    assert_text "Tractor was successfully updated"
    click_on "Back"
  end

  test "should destroy Tractor" do
    visit tractor_url(@tractor)
    click_on "Destroy this tractor", match: :first

    assert_text "Tractor was successfully destroyed"
  end
end
