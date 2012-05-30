#
# This represents a user was authenticated using a CAS service. Their user data is not saved in the database (in the users table_,
# but is retrieved from an external service and stored purely as session data.
#
#
class CasUser < Cms::TemporaryUser

  GROUP_NAME = "cas_group"

  def initialize(attributes={})
    super({ :first_name => "CAS", :last_name => "User"}.merge(attributes))
  end

  # Using a single group for now. (This will need to be mapped to more groups later).
  def groups
    @groups ||= [group]
  end

  # @deprecated
  # This exists only for backwards compatibility for when this used to inherit from GuestUser. It should be removed in 1.2.
  def group
    Cms::Group.find_by_code(GROUP_NAME)
  end
end
