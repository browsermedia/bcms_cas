require 'test_helper'
require 'mocha'

class CasUtilsTest < ActiveSupport::TestCase

  def setup
    @current_page = Page.new(:path=>"/expected")
    @portlet = LoginPortlet.new
  end

  test "service_url returns absolute success_url if specified" do
    @portlet.success_url = "/stuff"
    assert_equal "http://localhost:3000/stuff", Cas::Utils.service_url(@portlet, @current_page), "This really need to be an absolute path for it work w/ CAS."
  end

  test "service_url returns current page if specified" do
    p = LoginPortlet.new
    p.current_page = Page.new(:path=>"/expected")

    s = Cas::Utils.service_url(p, @current_page)
    assert_equal "http://localhost:3000/expected", s
  end

  test "service_url returns redirect_to if available" do
    s = Cas::Utils.service_url(@portlet, @current_page, "/redirected")
    assert_equal "http://localhost:3000/redirected", s
  end

  test "Nil page doesn't cause Nil exception" do
    s = Cas::Utils.service_url(@portlet, nil, nil)
    assert_equal "http://localhost:3000", s
  end

  test "Portlets work as expected (CMS Core check)" do
    p = LoginPortlet.new

    assert_equal nil, p.success_url, "Validate that LoginPortlet returns nil if no success_url is set (rather than an empty string."
  end

  test "cas_server_url looks up CAS server from config in environment" do
    expected = "https://127.0.0.1"
    CASClient::Frameworks::Rails::Filter.expects(:config).returns({:cas_base_url=>expected})

    assert_equal expected, Cas::Utils.cas_server_url
  end

  test "get login ticket" do
    expected_host = "https://random.com"
    Cas::Utils.expects(:cas_server_url).with.returns(expected_host)

    Net::HTTP.any_instance.stubs(:start).returns(mock(:body=>"Ticket 100"))
    uri = stub(:path=>"#{expected_host}/loginTicket", :host=>"", :port=>80)
    URI.expects(:parse).with("#{expected_host}/loginTicket").returns(uri)

    ticket = Cas::Utils.fetch_lt_from_cas
    assert_equal "Ticket 100", ticket
  end

  # Verification test of CasClient API behavior.
  test "[CASClient] Verify expected behavior of CASClient#logout_url" do
    destination_url = "localhost"

    client = CASClient::Client.new({:cas_base_url=>"/", :logout_url=>"/"})

    logout_url = client.logout_url(destination_url, destination_url)
    assert_equal "/?destination=localhost&url=localhost", logout_url, "Verifies that logout_url generates a correct URL."
    assert_equal String, logout_url.class
  end

  test "Cas::Utils#logout redirects and attaches gateway=true to logout_url" do
    destination_url = "localhost"
    logout_url = "/?destination=localhost&url=localhost"

    CASClient::Frameworks::Rails::Filter.expects(:client).returns(CASClient::Client.new({:cas_base_url=>""}))
    CASClient::Client.any_instance.expects(:logout_url).with(destination_url, destination_url).returns(logout_url)

    controller = stub()
    controller.expects(:redirect_to).with("#{logout_url}&gateway=true")
    Cas::Utils.expects(:reset_session_and_get_referrer).returns(destination_url)
    
    Cas::Utils.logout(controller, "/")
  end
end
