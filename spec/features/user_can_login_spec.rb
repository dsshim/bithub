require 'rails_helper'

RSpec.describe "user can login" do
  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  scenario "user can visit homepage" do
    visit root_path
    expect(page.status_code).to eq(200)
  end

  scenario "user can login with github account" do
    login
    visit root_path
    click_link("Login with Github")

    expect(current_path).to eq(dashboard_path)
  end

  scenario "user can logout" do
    VCR.use_cassette("user_login_test#logout") do
      login
      visit root_path
      click_link("Login with Github")
      click_link("Logout")

      expect(current_path).to eq(root_path)
    end
  end
end
