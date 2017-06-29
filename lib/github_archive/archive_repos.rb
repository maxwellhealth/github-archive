module GithubArchive
  # archive a set of repos
  class ArchiveRepos
    attr_accessor :backup_count, :total_size

    def initialize
      self.backup_count = 0
      self.total_size = 0
    end

    def archive(client, repos, prefix, verbose)
      fullpath = path(prefix)
      repos.each do |repo|
        copy_repo(repo, fullpath, client, verbose)
        self.backup_count += 1
      end
    end

    private

    def path(prefix)
      # use current time for path
      path = prefix + Time.now.utc.strftime('%Y%m%d.%H%M%S')
      # create backup directory
      Dir.mkdir path
      path
    end

    def copy_repo(repo, path, client, verbose)
      require 'open-uri'

      puts "Archiving #{repo[:full_name]}\n" if verbose
      # IO.copy_stream(
      #   open(client.archive_link(repo[:full_name])),
      #   "#{path}/#{repo[:name]}.tgz"
      # )
      puts client.archive_link(repo[:full_name]) if verbose
      puts "#{path}/#{repo[:name]}.tgz" if verbose
    end

    def bundle_archives(path)
    end
  end
end
