#
# This represents a user was authenticated using a CAS service. Their user data is not saved in the database (in the users table_,
# but is retrieved from an external service and stored purely as session data.
#
#
class CasUser < GuestUser

  GROUP_NAME = "cas_group"

  def initialize(attributes={})
    super({ :first_name => "CAS", :last_name => "User"}.merge(attributes))
    @guest = false
  end

  # Using a single group for now. (This will need to be mapped to more groups later).
  def group
    @group ||= Group.find_by_code(GROUP_NAME)
  end

end
