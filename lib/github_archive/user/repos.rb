module GithubArchive
  class User
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
      def archive(user)
        # get a collection of organization repos
        repos = all_repos(user)

        # exit if we found no repos
        return unless repos.count > 0

        o = GithubArchive::ArchiveRepos.new(client, path, verbose)
        o.archive(repos)
        @backup_count = o.backup_count
        @total_size = o.total_size
      end

      def all_repos(user)
        repos = client.repositories user, per_page: 100
        if repos.count >= 100
          repos.concat client.last_response.rels[:next].get.data
        end
        repos
      end
    end
  end
end
