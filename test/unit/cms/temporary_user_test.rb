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
end


class GuestUserTest <ActiveSupport::TestCase

  test "Verify save behavior of Guest is similar to TemporaryUser" do
    guest = GuestUser.new(TemporaryUserTest::MINIMUM_VALID_ATTRIBUTES)
    assert_equal false, guest.save()
    assert_equal true, guest.valid?
  end
end