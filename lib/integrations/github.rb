require 'api'

OWNER='truepillars'
GITHUB_REPO=ENV['GITHUB_REPO'] || 'truepillars'
GITHUB_URI="https://api.github.com/repos/#{OWNER}/#{GITHUB_REPO}/commits"

module Github
  def self.commit(sha)
    Api::get(GITHUB_URI + "/" + sha, ENV['GITHUB_API_TOKEN'])['commit']
  end

  def self.commits(first_sha, last_sha)
    selected = nil
    earliest_commit = nil

    (1..10).each do |page|
      STDERR.putc '.'
      batch = Api::get(GITHUB_URI + "?sha=master&page=#{page}", ENV['GITHUB_API_TOKEN'])
      batch.each do |commit|
        sha = commit['sha']
        if sha == last_sha
          STDERR.putc '$'
          selected = {}
        end
        selected[sha] = commit['commit']['message'] if selected
        if sha == first_sha
          STDERR.putc '^'
          return selected
        end
      end
    end

    STDERR.puts " - earliest commit: #{earliest_commit}"
    selected
  end
end
