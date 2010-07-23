require 'test_helper'
require 'mocha'

class LoginPortletHelperTest < ActionView::TestCase

  test "Fetching login ticket" do
    ticket = Cas::Utils.expects(:fetch_lt_from_cas).with().returns("ABC")
    assert_equal hidden_field_tag( :lt, "ABC"), login_ticket_tag
  end
end
