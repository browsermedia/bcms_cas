require 'test_helper'

class CasUserTest < ActiveSupport::TestCase

  def setup
    @s = Section.create!(:name=>"root", :root=>true, :path=>"/")
    @p = Page.create!(:name=>"Home", :section=>@s, :path=>"/p")
    @g = Group.create!(:name=>"G", :code=>"cas_group")
    @g.sections = Section.all
  end

  test "group returns the cas_group" do
    user = CasUser.new

    assert_equal @g, user.group
  end

  test "cas_user should be able to view all sections (based on group)" do
    user = CasUser.new

    assert user.able_to_view?(@p)
  end

  test "setting login" do
    user = CasUser.new(:login=>"bob")
    assert_equal "bob", user.login
  end

  test "that CasUsers are not considered guests" do
    user = CasUser.new
    assert !user.guest?
  end


end
