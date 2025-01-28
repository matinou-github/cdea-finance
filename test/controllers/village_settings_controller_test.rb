require "test_helper"

class VillageSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @village_setting = village_settings(:one)
  end

  test "should get index" do
    get village_settings_url
    assert_response :success
  end

  test "should get new" do
    get new_village_setting_url
    assert_response :success
  end

  test "should create village_setting" do
    assert_difference("VillageSetting.count") do
      post village_settings_url, params: { village_setting: { kg_ha_labouree: @village_setting.kg_ha_labouree, village: @village_setting.village } }
    end

    assert_redirected_to village_setting_url(VillageSetting.last)
  end

  test "should show village_setting" do
    get village_setting_url(@village_setting)
    assert_response :success
  end

  test "should get edit" do
    get edit_village_setting_url(@village_setting)
    assert_response :success
  end

  test "should update village_setting" do
    patch village_setting_url(@village_setting), params: { village_setting: { kg_ha_labouree: @village_setting.kg_ha_labouree, village: @village_setting.village } }
    assert_redirected_to village_setting_url(@village_setting)
  end

  test "should destroy village_setting" do
    assert_difference("VillageSetting.count", -1) do
      delete village_setting_url(@village_setting)
    end

    assert_redirected_to village_settings_url
  end
end
