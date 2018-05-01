require 'api'

VERSION_URI=ENV['VERSION_URI'] || "https://api.truepillars.com/version"

module TruePillars
  def self.version
    Api::get(VERSION_URI)['number']
  end
end
