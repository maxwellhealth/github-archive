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
      fullpath = prefix + '/' + Time.now.utc.strftime('%Y%m%d.%H%M%S')
      Dir.mktmpdir('GHA') do |dir|
        repos.each do |repo|
          copy_repo(repo, dir, client, verbose)
          self.backup_count += 1
        end

        p "Writing #{fullpath}.tar"
        tb = GithubArchive::Util::Tar.new
        tb.tar(dir, "#{fullpath}.tar")
        p tb.path
        self.total_size = tb.total_size
      end
    end

    def copy_repo(repo, path, client, verbose)
      require 'open-uri'
      if verbose
        puts "Archiving #{repo[:full_name]}\n"
        puts client.archive_link(repo[:full_name])
        puts "#{path}/#{repo[:name]}.tgz"
      end
      File.open(File.join(path, "#{repo[:name]}.tgz"), 'wb') do |f|
        f.write open(client.archive_link(repo[:full_name])).read
      end
    end
  end
end
