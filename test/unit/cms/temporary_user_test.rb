require "test_helper"

class TemporaryUserTest < ActiveSupport::TestCase

  MINIMUM_VALID_ATTRIBUTES = {:login=>"abc@bm.com", :password=>"123", :password_confirmation=>"123", :email=>"abc@bm.com"}
  def setup
    @user = Cms::TemporaryUser.new(MINIMUM_VALID_ATTRIBUTES)
  end

  def teardown

  end

  test "Should not be able to save or save!" do
    
    assert_equal false, @user.save
    assert_equal true, @user.valid?

    assert_raise NotImplementedError do
      @user.save! 
    end

  end
  test "Shouldn't be able to update attributes" do
    assert_equal false, @user.update_attribute(:login, "OTHER")
    assert_equal false, @user.update_attributes({:login =>"OTHER"})
  end

  test "Should belong to no groups by default" do
    assert_equal 0, @user.groups.size
  end

  test "Temp users should be able to view sections their groups have permissions to" do
    group = Group.create!(:name=>"My Group")
    section = Section.create!(:name=>"My Section", :path=>"/mysection")
    section.groups << group
    section.save!

    user = Cms::TemporaryUser.new
    user.groups << group

    assert user.able_to_view?(section)


  end

  test "Viewable sections" do
    group = Group.create!(:name=>"Group 1")
    first_section = Section.create!(:name=>"Section1", :path=>"/section1")
    first_section.groups << group
    first_section.save!

    group2 = Group.create!(:name=>"Group 2")
    second_section = Section.create!(:name=>"Section 2", :path=>"/section2")
    second_section.groups << group2
    second_section.save!

    user = Cms::TemporaryUser.new
    user.groups << group << group2

    assert_equal [first_section, second_section], user.viewable_sections
    assert user.able_to_view?(first_section)
    assert user.able_to_view?(second_section)

  end

  test "A user with no groups should not have CMS access" do
    user = Cms::TemporaryUser.new
    assert_equal false, user.cms_access? 
  end
end


class GuestUserTest <ActiveSupport::TestCase

  test "Verify save behavior of Guest is similar to TemporaryUser" do
    guest = GuestUser.new(TemporaryUserTest::MINIMUM_VALID_ATTRIBUTES)
    assert_equal false, guest.save()
    assert_equal true, guest.valid?
  end
end