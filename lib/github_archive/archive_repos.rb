module GithubArchive
  # archive a set of repos
  class ArchiveRepos
    attr_accessor :backup_count, :total_size

    def initialize
      self.backup_count = 0
      self.total_size = 0
    end

    def archive(client, repos, prefix, verbose)
      require 'tmpdir'
      fullpath = path(prefix)
      Dir.mktmpdir('GHA') do |dir|
        repos.each do |repo|
          copy_repo(repo, dir, client, verbose)
          self.backup_count += 1
        end

        # p "#{fullpath}.tgz"
        # File.open("#{fullpath}.tgz", 'w') do |f|
        #   f.puts(GithubArchive::Util::Tar.tar(dir))
        # end
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
      if verbose
        puts "Archiving #{repo[:full_name]}\n"
        puts client.archive_link(repo[:full_name])
        puts "#{path}/#{repo[:name]}.tgz"
      end
      File.open(File.join(path, "#{repo[:name]}.tgz"), 'w') do |f|
        open(client.archive_link(repo[:full_name]), 'rb') do |r|
          f.write r.read
        end
      end
    end
  end
end
