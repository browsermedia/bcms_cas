##
#   This file needs to be included in a file called app/portlets/helpers/login_portlet_helper.rb
#   in the project. See installation instructions in the README for details.
module CasModule::LoginPortlet

  # Generates the hidden field for the service_url that the CAS server expects, which tells it where to redirect to. Must create
  # an absolute URL.
  def service_url_tag
    hidden_field_tag :service, CasModule::Utils.service_url(@portlet, @page, session[:return_to])
  end

  # Generates the hidden field for the login ticket that CAS server expects.
  def login_ticket_tag
    hidden_field_tag :lt, CasModule::Utils.fetch_lt_from_cas
  end

  ##
  # Returns the URL to the CAS login service.
  def login_url
    CASClient::Frameworks::Rails::Filter.login_url         
  end
end