require "application_system_test_case"

class ZoneAssignmentsTest < ApplicationSystemTestCase
  setup do
    @zone_assignment = zone_assignments(:one)
  end

  test "visiting the index" do
    visit zone_assignments_url
    assert_selector "h1", text: "Zone assignments"
  end

  test "should create zone assignment" do
    visit zone_assignments_url
    click_on "New zone assignment"

    fill_in "Assigned by", with: @zone_assignment.assigned_by_id
    fill_in "User", with: @zone_assignment.user_id
    fill_in "Zone", with: @zone_assignment.zone_id
    click_on "Create Zone assignment"

    assert_text "Zone assignment was successfully created"
    click_on "Back"
  end

  test "should update Zone assignment" do
    visit zone_assignment_url(@zone_assignment)
    click_on "Edit this zone assignment", match: :first

    fill_in "Assigned by", with: @zone_assignment.assigned_by_id
    fill_in "User", with: @zone_assignment.user_id
    fill_in "Zone", with: @zone_assignment.zone_id
    click_on "Update Zone assignment"

    assert_text "Zone assignment was successfully updated"
    click_on "Back"
  end

  test "should destroy Zone assignment" do
    visit zone_assignment_url(@zone_assignment)
    click_on "Destroy this zone assignment", match: :first

    assert_text "Zone assignment was successfully destroyed"
  end
end
