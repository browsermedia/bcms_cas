# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bcms_cas_session',
  :secret      => '08655e28987ab7b355dffb84d8963a4f66b82ae43a2e9644040be6bc5c062524666086ff4b2d180724bf6bf9dd11e7bec7c271ba16d321e94dd478a011a91ed0'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
