require "application_system_test_case"

class VillageSettingsTest < ApplicationSystemTestCase
  setup do
    @village_setting = village_settings(:one)
  end

  test "visiting the index" do
    visit village_settings_url
    assert_selector "h1", text: "Village settings"
  end

  test "should create village setting" do
    visit village_settings_url
    click_on "New village setting"

    fill_in "Kg ha labouree", with: @village_setting.kg_ha_labouree
    fill_in "Village", with: @village_setting.village
    click_on "Create Village setting"

    assert_text "Village setting was successfully created"
    click_on "Back"
  end

  test "should update Village setting" do
    visit village_setting_url(@village_setting)
    click_on "Edit this village setting", match: :first

    fill_in "Kg ha labouree", with: @village_setting.kg_ha_labouree
    fill_in "Village", with: @village_setting.village
    click_on "Update Village setting"

    assert_text "Village setting was successfully updated"
    click_on "Back"
  end

  test "should destroy Village setting" do
    visit village_setting_url(@village_setting)
    click_on "Destroy this village setting", match: :first

    assert_text "Village setting was successfully destroyed"
  end
end
