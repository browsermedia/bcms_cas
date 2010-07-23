require "test_helper"
require 'mocha'

class CasConfigurationTest < ActiveSupport::TestCase

  def setup

  end

  def teardown

  end

  test "Simplified syntax for configuration that hides the details of the RubyCas-Client" do
    expected_params = {:cas_base_url => "https://some.domain.com", :extra_attributes_session_key => :cas_extra_attributes}
    CASClient::Frameworks::Rails::Filter.expects(:configure).with(expected_params)

    Cas::Module.configure do |config|
      config.server_url = "https://some.domain.com"
    end

    cfg = Cas::Module.configuration
    assert_equal "https://some.domain.com", cfg.server_url
  end
end