module Cas

  module Module

    class << self

      attr_accessor :configuration
      
      def configure()
        self.configuration ||= Configuration.new
        yield(configuration)
        self.configuration.execute
      end
    end
  end

  class Configuration
    attr_accessor :server_url

    def execute
      params = {:cas_base_url => server_url, :extra_attributes_session_key => :cas_extra_attributes}
      CASClient::Frameworks::Rails::Filter.configure(params)
    end
  end
end