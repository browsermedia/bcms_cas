#
# Customizes behavior of CASFilter.
#
module Cas
  class Utils
    # This is a wrapper around the default behavior of the CASClient Rails filter.
    #
    # The only difference is that it generates a return URL that the user can click on to get back to the homepage.
    def self.logout(controller, service = nil)
      # Copy/Paste from Filter
      referer = reset_session_and_get_referrer(controller, service)

      # New lines
      client = CASClient::Frameworks::Rails::Filter.client

      # Adding gateway=true param to this logout URL will cause immediate redirect, which is preferable
      #   since it means users aren't left stranded on the CAS server logout page.
      url = client.logout_url(referer, referer)
      controller.send(:redirect_to, "#{url}&gateway=true")
    end

    # Copy/Paste from CAS Filter
    def self.reset_session_and_get_referrer(controller, service)
      referer = service || controller.request.referer
      st = controller.session[:cas_last_valid_ticket]
      delete_service_session_lookup(st) if st
      controller.send(:reset_session)
      referer
    end
    #
    # Gets a valid login_ticket from the CAS Server, which will allow us to submit directly from our CMS login forms.
    #
    def self.fetch_lt_from_cas
      url = URI.parse("#{self.cas_server_url}/loginTicket")
      post = Net::HTTP::Post.new(url.path)
      post.set_form_data({'dummy'=>'data'})

      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true

      res = https.start {|http| http.request(post) }
      lt = res.body
      lt
    end

    def self.check(portlet)
      portlet.current_page.path
    end

    # Calculates which URL the user should be redirect to, after completing registration on the CAS server.
    def self.service_url(portlet, page, redirect_to = nil)
      path = page.path if page
      path = "" unless page
      goto = redirect_to || portlet.success_url || path
      unless goto.starts_with?("http://")
        goto = to_absolute_url(goto)
      end
      goto
    end

    # Looks up the URL of the CAS server from the environment
    def self.cas_server_url
      CASClient::Frameworks::Rails::Filter.config[:cas_base_url]
    end

    private

    def self.to_absolute_url(path)
      "http://#{SITE_DOMAIN}#{path}"
    end
  end
end
