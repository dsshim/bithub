require 'rails_helper'

feature "user can login" do
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
    expect(page).to have_content("dave@dave.com")
    expect(page).to have_content("Logged in as nickname")
    expect(page).to have_content("Logout")
    expect(page).to have_content("Repository")
    expect(page).to have_content("Contributions in Past Year")
    expect(page).to have_content("Recent Activity")
  end
end
