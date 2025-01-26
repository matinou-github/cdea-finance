require "application_system_test_case"

class RestitutionsTest < ApplicationSystemTestCase
  setup do
    @restitution = restitutions(:one)
  end

  test "visiting the index" do
    visit restitutions_url
    assert_selector "h1", text: "Restitutions"
  end

  test "should create restitution" do
    visit restitutions_url
    click_on "New restitution"

    fill_in "Balance id", with: @restitution.balance_id_id
    fill_in "Garantie", with: @restitution.garantie
    fill_in "User id", with: @restitution.user_id_id
    click_on "Create Restitution"

    assert_text "Restitution was successfully created"
    click_on "Back"
  end

  test "should update Restitution" do
    visit restitution_url(@restitution)
    click_on "Edit this restitution", match: :first

    fill_in "Balance id", with: @restitution.balance_id_id
    fill_in "Garantie", with: @restitution.garantie
    fill_in "User id", with: @restitution.user_id_id
    click_on "Update Restitution"

    assert_text "Restitution was successfully updated"
    click_on "Back"
  end

  test "should destroy Restitution" do
    visit restitution_url(@restitution)
    click_on "Destroy this restitution", match: :first

    assert_text "Restitution was successfully destroyed"
  end
end
