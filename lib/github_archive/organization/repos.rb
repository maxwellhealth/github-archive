module GithubArchive
  class Organization
    # archive github repos for an organization
    class Repos
      attr_accessor :client, :path, :verbose
      attr_reader :backup_count, :total_size

      def initialize(client, path, verbose)
        @backup_count = 0
        @total_size = 0
        @path = path
        @client = client
        @verbose = verbose
      end

      # archive an organizations repos
      def archive(org)
        # get a collection of organization repos
        repos = all_repos(org)

        # exit if we found no repos
        return unless repos.count > 0

        o = GithubArchive::ArchiveRepos.new(client, path, verbose)
        o.archive(repos)
        @backup_count = o.backup_count
        @total_size = o.total_size
      end

      def all_repos(org)
        repos = client.organization_repositories org, per_page: 100
        if repos.count >= 100
          repos.concat client.last_response.rels[:next].get.data
        end
        repos
      end
    end
  end
end
