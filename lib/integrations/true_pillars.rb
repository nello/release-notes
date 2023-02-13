require 'api'

module TruePillars
  def self.version(uri)
    Api::get(uri)['number']
  end
end
