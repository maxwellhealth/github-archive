module GithubArchive
  # archive a set of repos
  class ArchiveRepos
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
    end

    def archive(repos)
      require 'tmpdir'
      Dir.mktmpdir('GHA') do |dir|
        repos.each do |repo|
          copy_repo(repo, dir)
          @backup_count += 1
        end

        next if dry_run
        tb = GithubArchive::Util::Tar.new
        tb.tar(dir, path)
        @total_size = tb.size
      end
    end

    def copy_repo(repo, path)
      require 'open-uri'
      if verbose || dry_run
        puts "Archiving #{repo[:full_name]}\n"
        puts "#{path}/#{repo[:name]}.tgz"
      end
      return if dry_run
      @client = GithubArchive::Auth.new(token).client
      begin
        File.open(File.join(path, "#{repo[:name]}.tgz"), 'wb') do |f|
          f.write open(@client.archive_link(repo[:full_name])).read
        end
      rescue OpenURI::HTTPError
        puts $!.message
      end
    end
  end
end
