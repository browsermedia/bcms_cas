require 'test_helper'
require 'mocha'

class MyController < ActionController::Base
  include Cms::Authentication::Controller

  def get_at_current_user
    @current_user
  end

  def flash
    {}
  end

  def destroy
    "Exists only to be alias_method_chained"
  end
end

class CasAuthTest < ActiveSupport::TestCase

  def setup
    MyController.expects(:skip_filter).with(:check_access_to_page)
    MyController.expects(:skip_filter).with(:try_to_stream_file)
    
    MyController.expects(:before_filter).with(CASClient::Frameworks::Rails::GatewayFilter)
    MyController.expects(:before_filter).with(:login_from_cas_ticket)
    MyController.expects(:before_filter).with(:try_to_stream_file)
    MyController.expects(:before_filter).with(:check_access_to_page)

    MyController.send(:include, Cas::Authentication)

  end

  def teardown
    User.current = nil
  end


  test "adds current_user and login from session to class" do
    c = MyController.new

    assert c.respond_to?(:current_user)
    assert c.respond_to?(:login_from_cas_ticket)

  end


  test "login_from_cas_ticket will create and set the current user and User.current if a session attribute was found." do
    c = MyController.new
    c.session = {}
    c.session[:cas_user] = "1234"

    User.current = Group.find_by_code("guest")

    c.login_from_cas_ticket

    current_user = c.get_at_current_user
    assert_equal CasUser, current_user.class
    assert_equal "1234", current_user.login
    assert_equal current_user, User.current
  end

  test "Cms::ContentController gets augmented" do
    assert (Cms::ContentController.new.respond_to? :login_from_cas_ticket)
  end

end

class CasSessionControllerTest < ActiveSupport::TestCase


  test "alias_method_chain the normal methods" do
    MyController.send(:include, Cas::SingleLogOut)

    c = MyController.new
    
    assert( c.respond_to? :destroy)
    assert( c.respond_to? :destroy_with_cas)
    assert( c.respond_to? :destroy_without_cas)

  end

  test "destroy_with_cas redirects to server and calls logout_user" do
    MyController.send(:include, Cas::SingleLogOut)
    c = MyController.new

    c.expects(:logout_user)

    Cas::Utils.expects(:logout).with(c, "http://#{SITE_DOMAIN}/")

    c.destroy_with_cas


  end

  test "that BrowserCMS 3.0.3 installed." do
    assert Cms::SessionsController.new.respond_to?(:logout_user), "Need to have BrowserCMS 3.0.3 installed for Cas module to work."
  end
  
  test "Cms::SessionController gets augmented" do
    assert (Cms::SessionsController.new.respond_to? :destroy_with_cas)    
  end
end
