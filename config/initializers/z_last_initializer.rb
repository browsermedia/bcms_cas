# This is the 'last' initialzer to ensure that the module has been initialized first.

# Configure a sample service to point to a local CAS Server.
CASClient::Frameworks::Rails::Filter.configure(
        :cas_base_url => "https://localhost",
        :extra_attributes_session_key => :cas_extra_attributes
)