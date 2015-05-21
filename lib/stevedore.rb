require "tmpdir"

module Stevedore
  class CommandLineError < StandardError #:nodoc:
  end

  private

  def self.run(command, expected_outcodes = 0)
    output = `#{command}`
    unless [expected_outcodes].flatten.include?($?.exitstatus)
      raise CommandLineError, "Error while running #{command}"
    end
    output.force_encoding('UTF-8')
  end
end

require "stevedore/pdf"
