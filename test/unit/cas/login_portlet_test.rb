require "test_helper"
require 'mocha'

class LoginObject
  include Cas::LoginPortlet
end

class LoginPortletTest < ActiveSupport::TestCase

  def setup
    @obj = LoginObject.new
  end

  test "service_url_tag" do
    obj = LoginObject.new
    assert obj.respond_to?(:service_url_tag)
  end

  test "login_ticket_tag" do
    obj = LoginObject.new
    assert obj.respond_to?(:login_ticket_tag)
  end

  test "login_service_url exists" do
    obj = LoginObject.new
    assert obj.respond_to?(:login_url)
  end

  test "Returns the login service from Cas" do
    CASClient::Frameworks::Rails::Filter.expects(:login_url).returns("http://example.com")

    obj = LoginObject.new

    assert_equal "http://example.com", obj.login_url
  end

  test "Alias (to avoid helper conflicts)" do
    CASClient::Frameworks::Rails::Filter.expects(:login_url).returns("http://example.com")

    assert_equal "http://example.com", @obj.login_url_tag
  end


end