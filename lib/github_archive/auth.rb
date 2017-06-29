module GithubArchive
  require 'octokit'
  # starts the github api client
  class Auth
    attr_accessor :client
    def initialize(token)
      token ||= ENV['GITHUB_TOKEN']
      require 'octokit'

      # create a new github client
      self.client = Octokit::Client.new(access_token: token)
    end
  end
end
