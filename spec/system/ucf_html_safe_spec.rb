# frozen_string_literal: true

RSpec.describe "User Custom Fields - HTML Safe", type: :system do
  fab!(:user) { Fabricate(:user) }
  let(:field_1) { Fabricate(:user_field, name: "Field 1", show_on_profile: true) }
  let(:field_2) { Fabricate(:user_field, name: "Field 2", show_on_profile: true) }

  before do
    upload_theme_or_component
    
    # Set up values for the custom fields
    user.custom_fields["user_field_#{field_1.id}"] = "<b>bold</b>"
    user.custom_fields["user_field_#{field_2.id}"] = "<i>italic</i>"
    user.save_custom_fields

    # Update theme settings - assuming the setting name matches settings.yml
    # Discourse system tests often use the setting directly if it's a theme component
    # We use field_1.id as the safe field
    set_site_setting(:custom_user_field_ids, field_1.id.to_s)
  end

  it "renders HTML safely for specified fields and as raw text for others" do
    visit("/u/#{user.username}/summary")

    # Field 1 should render HTML (bold tag exists)
    expect(page).to have_css(".html-safe-ucf[data-field-id='#{field_1.id}'] .user-field-value b", text: "bold")

    # Field 2 should NOT render HTML (italic tag does not exist as an element)
    expect(page).to have_no_css(".html-safe-ucf[data-field-id='#{field_2.id}'] .user-field-value i")
    
    # Field 2 should show the raw text
    expect(page).to have_css(".html-safe-ucf[data-field-id='#{field_2.id}'] .user-field-value", text: "<i>italic</i>")
  end
end
