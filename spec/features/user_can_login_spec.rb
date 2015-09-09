require 'rails_helper'

feature "user can login" do
  before do
  Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]

end

  scenario "user can login with github account" do
    login
    visit root_path
    click_link("Login with Github")

    expect(current_path).to eq(dashboard_path)
  end
end
