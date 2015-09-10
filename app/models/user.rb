
class User < ActiveRecord::Base
  def self.find_or_create_from_auth(auth)
    user = User.find_or_create_by(provider: auth.provider, uid: auth.uid)

    user.email = auth.info.email
    user.nickname = auth.info.nickname
    user.image_url = auth.info.image
    user.token = auth.credentials.token
    user.save

    user
  end

  def find_recent_commits_for_followed_users
    commits = []
    users = following.map do |user|
      user.login
    end
    users.each do |user|
      commits << Github.activity.events.performed(user)
        .find_all{|event| event.type == "PushEvent"}.last(1)
    end
    commits
  end

  def find_scores
    stats
    scores = []
    scores.push(@stats.data.scores.reverse[0..364]
      .inject(:+), current_streak, longest_streak )
    scores
  end

  def repositories
    Github.repos.list user: self.nickname
  end

  def followers
    github_auth.users.followers.list
  end

  def following
    github_auth.users.followers.following
  end

  def starred
    github_auth.activity.starring.starred
  end

  def pull_requests
    github_auth.activity.events.performed(self.nickname)
      .find_all{|event| event.type == "PullRequestEvent"}
  end

  def issues
    github_auth.activity.events.performed(self.nickname)
      .find_all{|event| event.type == "IssuesEvent"}
  end

  def commits
    github_auth.activity.events.performed(self.nickname)
      .find_all{|event| event.type == "PushEvent"}
  end

  def organizations
    github_auth.orgs.list(user: self.nickname)
  end

  private

  def github_auth
    Github.new :oauth_token => self.token
  end


  def stats
    @stats ||= GithubStats.new(self.nickname)
  end

  def current_streak
    days = @stats.data.streak.last.date - @stats.data.streak.first.date
    days.numerator + days.denominator
  end

  def longest_streak
    days = @stats.data.longest_streak.last.date - @stats.data.longest_streak.first.date
    days.numerator + days.denominator
  end

end
