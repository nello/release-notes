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
    sha = '[]'

    (1..10).each do |page|
      batch = Api::get(GITHUB_URI + "?sha=master&page=#{page}", ENV['GITHUB_API_TOKEN'])
      batch.each do |commit|
        sha = commit['sha']
        last_sha ||= sha
        if sha == last_sha
          STDERR.print "[#{sha}]"
          selected = {}
        end
        selected[sha] = commit['commit']['message'] if selected
        if sha == first_sha
          STDERR.puts "[#{sha}]"
          selected.each {|commit| puts commit.inspect}
          return selected
        end
        earliest_commit = commit
      end
      STDERR.putc '.'
    end

    STDERR.puts "[#{sha}] #{earliest_commit['commit']['author']['date']} #{earliest_commit['commit']['message']}"
    selected
  end
end
