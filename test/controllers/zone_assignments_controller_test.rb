require "test_helper"

class ZoneAssignmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @zone_assignment = zone_assignments(:one)
  end

  test "should get index" do
    get zone_assignments_url
    assert_response :success
  end

  test "should get new" do
    get new_zone_assignment_url
    assert_response :success
  end

  test "should create zone_assignment" do
    assert_difference("ZoneAssignment.count") do
      post zone_assignments_url, params: { zone_assignment: { assigned_by_id: @zone_assignment.assigned_by_id, user_id: @zone_assignment.user_id, zone_id: @zone_assignment.zone_id } }
    end

    assert_redirected_to zone_assignment_url(ZoneAssignment.last)
  end

  test "should show zone_assignment" do
    get zone_assignment_url(@zone_assignment)
    assert_response :success
  end

  test "should get edit" do
    get edit_zone_assignment_url(@zone_assignment)
    assert_response :success
  end

  test "should update zone_assignment" do
    patch zone_assignment_url(@zone_assignment), params: { zone_assignment: { assigned_by_id: @zone_assignment.assigned_by_id, user_id: @zone_assignment.user_id, zone_id: @zone_assignment.zone_id } }
    assert_redirected_to zone_assignment_url(@zone_assignment)
  end

  test "should destroy zone_assignment" do
    assert_difference("ZoneAssignment.count", -1) do
      delete zone_assignment_url(@zone_assignment)
    end

    assert_redirected_to zone_assignments_url
  end
end
