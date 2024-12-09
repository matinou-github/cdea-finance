require "application_system_test_case"

class ServiceRequestsTest < ApplicationSystemTestCase
  setup do
    @service_request = service_requests(:one)
  end

  test "visiting the index" do
    visit service_requests_url
    assert_selector "h1", text: "Service requests"
  end

  test "should create service request" do
    visit service_requests_url
    click_on "New service request"

    fill_in "Garantie", with: @service_request.garantie
    fill_in "Herbicide", with: @service_request.herbicide_id
    fill_in "Herbicide nom", with: @service_request.herbicide_nom
    fill_in "Herbicide prix", with: @service_request.herbicide_prix
    fill_in "Herbicide quantite", with: @service_request.herbicide_quantite
    fill_in "Preuve", with: @service_request.preuve
    fill_in "Status", with: @service_request.status
    fill_in "Superficie", with: @service_request.superficie
    fill_in "User", with: @service_request.user_id
    click_on "Create Service request"

    assert_text "Service request was successfully created"
    click_on "Back"
  end

  test "should update Service request" do
    visit service_request_url(@service_request)
    click_on "Edit this service request", match: :first

    fill_in "Garantie", with: @service_request.garantie
    fill_in "Herbicide", with: @service_request.herbicide_id
    fill_in "Herbicide nom", with: @service_request.herbicide_nom
    fill_in "Herbicide prix", with: @service_request.herbicide_prix
    fill_in "Herbicide quantite", with: @service_request.herbicide_quantite
    fill_in "Preuve", with: @service_request.preuve
    fill_in "Status", with: @service_request.status
    fill_in "Superficie", with: @service_request.superficie
    fill_in "User", with: @service_request.user_id
    click_on "Update Service request"

    assert_text "Service request was successfully updated"
    click_on "Back"
  end

  test "should destroy Service request" do
    visit service_request_url(@service_request)
    click_on "Destroy this service request", match: :first

    assert_text "Service request was successfully destroyed"
  end
end
