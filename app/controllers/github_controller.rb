class GithubController < ApplicationController

  def authorize
    address = github.authorize_url redirect_uri: 'http://...', scope: 'repo'
    redirect_to address
  end

  def callback
    authorization_code = params[:code]
    access_token = github.get_token authorization_code
    access_token.token   # => returns token value
  end

  private

   def github
    @github ||= Github.new client_id: env['github_id'], client_secret: env['github_secret']
    @github.authorize_url redirect_uri: 'http://...', scope: 'repo'
    @github
   end
end
