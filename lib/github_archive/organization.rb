module GithubArchive
  class Organization
    def archive(org)
      begin
        # require 'dogapi'
        require 'octokit'
        require 'open-uri'

        # get the current time
        time = Time.now.utc.strftime '%Y%m%d.%H%M%S'

        # create a new github client
        client = Octokit::Client.new(access_token: ENV['GITHUB_TOKEN'])

        # create a new datadog client
        # dog = Dogapi.Client.new(ENV['DOGAPI'])

        # get a collection of organization repos
        repos = client.organization_repositories org, per_page: 100
        repos.concat client.last_response.rels[:next].get.data

        # exit if we found no repos
        return unless repos.count > 0

        Dir.mkdir time

        repos.each do |repo|
          puts "Archiving #{repo[:full_name]}"
          p "#{time}/#{repo[:name]}"
          IO.copy_stream(open(client.archive_link(repo[:full_name])), "#{time}/#{repo[:name]}.tgz")
          # p client.archive_link(repo[:full_name])
        end
      rescue
        require 'pry'
        binding.pry
      end
    end
  end
end
