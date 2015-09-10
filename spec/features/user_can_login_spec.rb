require 'rails_helper' # ~> LoadError: cannot load such file -- rails_helper

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

  xscenario "user cannot login without github account" do
    VCR.use_cassette("user_login_test#invalid_account") do
      visit root_path
      click_link("Login with Github")
      save_and_open_page

      expect(current_path).to eq(root_path)
    end
  end


end

# ~> LoadError
# ~> cannot load such file -- rails_helper
# ~>
# ~> /Users/Dave/.rvm/rubies/ruby-2.2.1/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /Users/Dave/.rvm/rubies/ruby-2.2.1/lib/ruby/site_ruby/2.2.0/rubygems/core_ext/kernel_require.rb:54:in `require'
# ~> /Users/Dave/Turing/module_3/bithub/spec/features/user_can_login_spec.rb:1:in `<main>'
