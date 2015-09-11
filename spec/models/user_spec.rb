require 'rails_helper'


RSpec.describe User, type: :model do
  let(:user) do
    user = User.create(nickname: "dsshim",
                email:  "dave@shim.city",
                provider: "github",
                token:      ENV['github_oauth'],
                uid:   123123,
                image_url: "fake.com",
                )
  end

  scenario "#find_repositories" do
    VCR.use_cassette("user_test#repositories") do

      repos = user.repositories
      repo = repos.first

      expect(repos.count).to eq(23)
      expect(repo.name).to eq("active-record-sinatra")
      expect(repo.owner.login).to eq("dsshim")
    end
  end

  scenario "#followers" do
    VCR.use_cassette("user_test#followers") do

      followers = user.followers
      follower = followers.first

      expect(followers.count).to eq(6)
      expect(follower.login).to eq("mitchashby16")
      expect(follower.type).to eq("User")
    end
  end

  scenario "#following" do
    VCR.use_cassette("user_test#following") do

      following = user.following
      follow = following.first

      expect(following.count).to eq(10)
      expect(follow.login).to eq("jcasimir")
      expect(follow.type).to eq("User")
    end
  end

  scenario "#starred" do
    VCR.use_cassette("user_test#starred") do

      starred = user.starred
      star = starred.first

      expect(starred.count).to eq(1)
      expect(star.name).to eq("the_pivot")
      expect(star.owner.login).to eq("imwithsam")
      expect(star.owner.html_url).to eq("https://github.com/imwithsam")
    end
  end

  scenario "#open_pull_requests" do
    VCR.use_cassette("user_test#pull_requests") do

      pull_requests = user.pull_requests
      pull_req = pull_requests.first

      expect(pull_requests.count).to eq(1)
      expect(pull_req.actor.login).to eq("dsshim")
      expect(pull_req.payload.action).to eq("opened")
      expect(pull_req.payload.pull_request.html_url).to eq("https://github.com/dsshim/bithub/pull/14")
    end
  end

  scenario "#issues" do
    VCR.use_cassette("user_test#issues") do

      issues = user.issues
      issue = issues.first

      expect(issues.count).to eq(11)
      expect(issue.payload.issue.title).to eq("Users can see all other users they are following")
      expect(issue.payload.action).to eq("opened")
      expect(issue.payload.issue.html_url).to eq("https://github.com/dsshim/bithub/issues/11")
    end
  end

  scenario "#commits" do
    VCR.use_cassette("user_test#commits") do

      commits = user.commits
      commit = commits.first

      expect(commits.count).to eq(10)
      expect(commit.actor.login).to eq("dsshim")
      expect(commit.payload.commits.first.message).to eq("adds user spec tests")
      expect(commit.payload.commits.first.sha).to eq("a9feac9b5ec066ec04efb60098c40b4f79ec5137")
    end
  end

  scenario "#organizations" do
    VCR.use_cassette("user_test#organizations") do

      organizations = user.organizations

      expect(organizations.count).to eq(0)
    end
  end

  scenario "#find_scores" do
    VCR.use_cassette("user_test#find_scores") do

      scores = user.find_scores

      expect(scores[0]).to eq(365)
      expect(scores[1]).to eq(3)
      expect(scores[2]).to eq(11)
    end
  end

  scenario "#find_scores" do
    VCR.use_cassette("user_test#find_recent_commits_for_followed_users") do

      commits = user.find_recent_commits_for_followed_users
      commit = commits.first

      expect(commit.actor.login).to eq("jcasimir")
      expect(commit.payload.commits.first.message).to eq("Clarifying no arrays constraint")
      expect(commit.payload.commits.first.author.name).to eq("Jeff Casimir")
    end
  end

end
