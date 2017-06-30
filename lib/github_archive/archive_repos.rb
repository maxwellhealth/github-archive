module GithubArchive
  # archive a set of repos
  class ArchiveRepos
    attr_accessor :client, :path, :verbose
    attr_reader :backup_count, :total_size

    def initialize(client, path, verbose)
      @backup_count = 0
      @total_size = 0
      @path = path
      @client = client
      @verbose = verbose
    end

    def archive(repos)
      require 'tmpdir'
      Dir.mktmpdir('GHA') do |dir|
        repos.each do |repo|
          copy_repo(repo, dir)
          @backup_count += 1
        end

        tb = GithubArchive::Util::Tar.new
        tb.tar(dir, path)
        @total_size = tb.size
      end
    end

    def copy_repo(repo, path)
      require 'open-uri'
      if self.verbose
        puts "Archiving #{repo[:full_name]}\n"
        puts self.client.archive_link(repo[:full_name])
        puts "#{path}/#{repo[:name]}.tgz"
      end
      File.open(File.join(path, "#{repo[:name]}.tgz"), 'wb') do |f|
        f.write open(self.client.archive_link(repo[:full_name])).read
      end
    end
  end
end
