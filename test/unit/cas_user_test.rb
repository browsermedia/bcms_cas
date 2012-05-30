require 'test_helper'

module Cms
  class CasUserTest < ActiveSupport::TestCase

    def setup
      @viewable_section = Section.create!(:name=>"root", :root=>true, :path=>"/")
      @viewable_page = Page.create!(:name=>"Home", :section=>@viewable_section, :path=>"/p")
      @cas_group = Group.create!(:name=>"G", :code=>"cas_group")
      @cas_group.sections = Section.all
    end

    test "group returns the cas_group" do
      user = CasUser.new
      assert_equal @cas_group, user.group
    end

    test "cas_user should be able to view all sections (based on group)" do
      user = CasUser.new
      assert user.able_to_view?(@viewable_page)
    end

    test "setting login" do
      user = CasUser.new(:login=>"bob")
      assert_equal "bob", user.login
    end

    test "that CasUsers are not considered guests" do
      user = CasUser.new
      assert !user.guest?
    end

    test "determine if a user has cms_access" do
      user = CasUser.new
      user.groups << @cas_group

      @cas_group.expects(:cms_access?).returns(true)
      assert_equal true, user.cms_access? 
    end
  end
end