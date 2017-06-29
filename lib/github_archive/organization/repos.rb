module GithubArchive
  class Organization
    class Repos
      def archive(org, path)
        # require 'dogapi'
        require 'octokit'
        require 'open-uri'

        # get the current time
        time = Time.now.utc.strftime '%Y%m%d.%H%M%S'
        path.concat time

        # create a new github client
        client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

        # create a new datadog client
        # dog = Dogapi.Client.new(ENV['DOGAPI'])

        # get a collection of organization repos
        repos = client.organization_repositories org, per_page: 100
        repos.concat client.last_response.rels[:next].get.data

        # exit if we found no repos
        return unless repos.count > 0

        # create backup directory
        Dir.mkdir path

        backup_count = 0
        repos.each do |repo|
          puts "Archiving #{repo[:full_name]}"
          # p "#{path}/#{repo[:name]}.tgz"
          # IO.copy_stream(open(client.archive_link(repo[:full_name])), "#{time}/#{repo[:name]}.tgz")
          # p client.archive_link(repo[:full_name])
          backup_count += 1
        end
        backup_count
      end
    end
  end
end
