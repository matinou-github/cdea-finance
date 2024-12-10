require "test_helper"

class ExecutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @execution = executions(:one)
  end

  test "should get index" do
    get executions_url
    assert_response :success
  end

  test "should get new" do
    get new_execution_url
    assert_response :success
  end

  test "should create execution" do
    assert_difference("Execution.count") do
      post executions_url, params: { execution: { preuve: @execution.preuve, service_request_id: @execution.service_request_id, superficie: @execution.superficie } }
    end

    assert_redirected_to execution_url(Execution.last)
  end

  test "should show execution" do
    get execution_url(@execution)
    assert_response :success
  end

  test "should get edit" do
    get edit_execution_url(@execution)
    assert_response :success
  end

  test "should update execution" do
    patch execution_url(@execution), params: { execution: { preuve: @execution.preuve, service_request_id: @execution.service_request_id, superficie: @execution.superficie } }
    assert_redirected_to execution_url(@execution)
  end

  test "should destroy execution" do
    assert_difference("Execution.count", -1) do
      delete execution_url(@execution)
    end

    assert_redirected_to executions_url
  end
end
