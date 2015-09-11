require 'rails_helper'

RSpec.describe "user can visit dashboard" do
  before do
    Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  end

  scenario "user renders dashboard" do
    VCR.use_cassette("user_dashboard_test#render") do
      visit root_path
      login
      click_link "Login with Github"

      within(".col-xs-9") do
        expect(page).to have_content("dsshim")
        expect(page).to have_content("daveshim@gmail.com")
        expect(page).to have_content("Starred Repos: 1")
        expect(page).to have_content("Followers: 6")
        expect(page).to have_content("Following: 10")
      end

      within("#starred-modal") do
        expect(page).to have_content("imwithsam/the_pivot")
      end

      within("#follower-modal") do
        expect(page).to have_content("mitchashby16")
        expect(page).to have_content("mrjaimisra")
      end

      within("#following-modal") do
        expect(page).to have_content("jcasimir")
        expect(page).to have_content("stevekinney")
        expect(page).to have_content("mikedao")
      end

      within(".table-cont") do
        expect(page).to have_content("Longest Streak")
        expect(page).to have_content(11)
      end

      within(".table-issues") do
        expect(page).to have_content("Users can see all other users they are following")
        expect(page).to have_content("User can see all other users that follow him/her")
      end

      within(".table-commits") do
        expect(page).to have_content("adds user spec tests")
        expect(page).to have_content("adds homepage/navbar styling")
      end

    end
  end
end
