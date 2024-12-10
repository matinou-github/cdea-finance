require "application_system_test_case"

class ExecutionsTest < ApplicationSystemTestCase
  setup do
    @execution = executions(:one)
  end

  test "visiting the index" do
    visit executions_url
    assert_selector "h1", text: "Executions"
  end

  test "should create execution" do
    visit executions_url
    click_on "New execution"

    fill_in "Preuve", with: @execution.preuve
    fill_in "Service request", with: @execution.service_request_id
    fill_in "Superficie", with: @execution.superficie
    click_on "Create Execution"

    assert_text "Execution was successfully created"
    click_on "Back"
  end

  test "should update Execution" do
    visit execution_url(@execution)
    click_on "Edit this execution", match: :first

    fill_in "Preuve", with: @execution.preuve
    fill_in "Service request", with: @execution.service_request_id
    fill_in "Superficie", with: @execution.superficie
    click_on "Update Execution"

    assert_text "Execution was successfully updated"
    click_on "Back"
  end

  test "should destroy Execution" do
    visit execution_url(@execution)
    click_on "Destroy this execution", match: :first

    assert_text "Execution was successfully destroyed"
  end
end
