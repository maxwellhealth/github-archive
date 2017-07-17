module GithubArchive
  class Organization
    # archive github repos for an organization
    class Repos
      attr_accessor :token, :dry_run, :path, :verbose
      attr_reader :backup_count, :total_size

      def initialize(token, path, dry_run, verbose)
        @backup_count = 0
        @total_size = 0
        @path = path
        @token = token
        @dry_run = dry_run
        @verbose = verbose
        @client = false
        puts "Output File: #{path}" if dry_run || verbose
      end

      # archive an organizations repos
      def archive(org)
        # get a collection of organization repos
        @client = GithubArchive::Auth.new(token).client
        repos = all_repos(org)

        # exit if we found no repos
        return unless repos.count > 0

        o = GithubArchive::ArchiveRepos.new(token, path, dry_run, verbose)
        o.archive(repos)
        @backup_count = o.backup_count
        @total_size = o.total_size
      end

      def all_repos(org)
        repos = @client.organization_repositories org, per_page: 100
        if repos.count >= 100
          repos.concat @client.last_response.rels[:next].get.data
        end
        repos
      end
    end
  end
end
