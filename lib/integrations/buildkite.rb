require 'api'
require 'github'

class Buildkite
  def initialize(project, branch='master')
    @project = project
    @branch = branch
  end

  def commits_for(old_build_number, new_build_number) 
    Github::commits(sha_for(old_build_number), sha_for(new_build_number))
  end

  def sha_for(build_number)
     json = Api::get(uri(build_number) + '&access_token=' + ENV['BUILDKITE_API_TOKEN'])
     json['commit']
  end

  def uri(number)
    "https://api.buildkite.com/v1/organizations/true-pillars/projects/#{@project}/builds/#{number}?branch=#{@branch}"
  end
end
