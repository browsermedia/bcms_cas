# This assumes there is no existing LoginPortletHelper defined in the Core CMS project, and provides one
# to simplify what users need to do in the form.
module LoginPortletHelper

  # Generates the hidden field for the service_url that the CAS server expects, which tells it where to redirect to. Must create
  # an absolute URL.
  def service_url_tag
    hidden_field_tag :service, Cas::Utils.service_url(@portlet, @page, session[:return_to])
  end

  # Generates the hidden field for the login ticket that CAS server expects.
  def login_ticket_tag
    hidden_field_tag :lt, Cas::Utils.fetch_lt_from_cas
  end
end