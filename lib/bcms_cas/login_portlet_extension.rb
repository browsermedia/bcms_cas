##
#   This file needs to be included in a file called app/portlets/helpers/login_portlet_helper.rb
#   in the project. See installation instructions in the README for details.
module Cas::LoginPortlet

  # Generates the hidden field for the service_url that the CAS server expects, which tells it where to redirect to. Must create
  # an absolute URL.
  def service_url_tag
    hidden_field_tag :service, Cas::Utils.service_url(@portlet, @page, session[:return_to])
  end

  # Generates the hidden field for the login ticket that CAS server expects.
  def login_ticket_tag
    hidden_field_tag :lt, Cas::Utils.fetch_lt_from_cas
  end

  ##
  # Returns the URL to the CAS login service.
  #
  def login_url_tag
    CASClient::Frameworks::Rails::Filter.login_url         
  end

  alias_method :login_url, :login_url_tag
end