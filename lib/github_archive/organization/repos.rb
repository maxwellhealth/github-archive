module GithubArchive
  class Organization
    # archive github repos for an organization
    class Repos
      attr_accessor :backup_count
      # archive an organizations repos
      def archive(org, path, token)
        token ||= ENV['GITHUB_TOKEN']
        require 'octokit'
        require 'open-uri'

        # use current time for path
        path.concat Time.now.utc.strftime '%Y%m%d.%H%M%S'

        # create a new github client
        client = Octokit::Client.new(access_token: token)
        # client = GithubArchive::Auth.new(token)

        # create a new datadog client
        # dog = Dogapi.Client.new(ENV['DOGAPI'])

        # get a collection of organization repos
        repos = client.organization_repositories org, per_page: 100
        repos.concat client.last_response.rels[:next].get.data

        # exit if we found no repos
        return unless repos.count > 0

        o = GithubArchive::ArchiveRepos.new
        o.archive(client, repos, path)
        self.backup_count = o.backup_count
      end
    end
  end
end
