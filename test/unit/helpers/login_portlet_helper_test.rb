require 'test_helper'
require 'mocha'

class LoginPortletHelperTest < ActionView::TestCase

  test "Fetching login ticket" do
    ticket = Cas::Utils.expects(:fetch_lt_from_cas).with().returns("ABC")
    assert_equal hidden_field_tag( :lt, "ABC"), login_ticket_tag
  end

  test "Get login URL" do
    @controller = mock
    CASClient::Frameworks::Rails::Filter.expects(:login_url).with(@controller).returns("http://someurl.com")
    assert_equal "http://someurl.com", login_url_tag
  end
end
