module GithubArchive
  class Organization
    # archive github repos for an organization
    class Repos
      attr_accessor :backup_count, :total_size
      # archive an organizations repos
      def archive(org, path, client, verbose)
        # get a collection of organization repos
        repos = client.organization_repositories org, per_page: 100
        repos.concat client.last_response.rels[:next].get.data

        # exit if we found no repos
        return unless repos.count > 0

        o = GithubArchive::ArchiveRepos.new
        o.archive(client, repos, path, verbose)
        self.backup_count = o.backup_count
      end
    end
  end
end
