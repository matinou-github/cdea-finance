require "test_helper"

class ServiceRequestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @service_request = service_requests(:one)
  end

  test "should get index" do
    get service_requests_url
    assert_response :success
  end

  test "should get new" do
    get new_service_request_url
    assert_response :success
  end

  test "should create service_request" do
    assert_difference("ServiceRequest.count") do
      post service_requests_url, params: { service_request: { garantie: @service_request.garantie, herbicide_id: @service_request.herbicide_id, herbicide_nom: @service_request.herbicide_nom, herbicide_prix: @service_request.herbicide_prix, herbicide_quantite: @service_request.herbicide_quantite, preuve: @service_request.preuve, status: @service_request.status, superficie: @service_request.superficie, user_id: @service_request.user_id } }
    end

    assert_redirected_to service_request_url(ServiceRequest.last)
  end

  test "should show service_request" do
    get service_request_url(@service_request)
    assert_response :success
  end

  test "should get edit" do
    get edit_service_request_url(@service_request)
    assert_response :success
  end

  test "should update service_request" do
    patch service_request_url(@service_request), params: { service_request: { garantie: @service_request.garantie, herbicide_id: @service_request.herbicide_id, herbicide_nom: @service_request.herbicide_nom, herbicide_prix: @service_request.herbicide_prix, herbicide_quantite: @service_request.herbicide_quantite, preuve: @service_request.preuve, status: @service_request.status, superficie: @service_request.superficie, user_id: @service_request.user_id } }
    assert_redirected_to service_request_url(@service_request)
  end

  test "should destroy service_request" do
    assert_difference("ServiceRequest.count", -1) do
      delete service_request_url(@service_request)
    end

    assert_redirected_to service_requests_url
  end
end
