module Cms

  # This represents a 'temporary' user who is never stored in the database, but lives only as a limited duration (generally tied to a session)
  # This can be used to represent an externally verified user who should be granted access to areas of the site.
  class TemporaryUser < User

    # Shouldn't save these users to the db.
    def save(perform_validations=true)
      false
    end

    # Shouldn't save these users to the db.
    def save!(perform_validation=true)
      raise NotImplementedError
    end

  end
end