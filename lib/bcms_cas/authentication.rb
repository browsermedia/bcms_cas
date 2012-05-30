require 'bcms_cas/utils'
require 'casclient'
require 'casclient/frameworks/rails/filter'

#
# Augments the core Cms::Controllers to add Cas Authentication behavior.
#
module Cas
  module Authentication

    # Called when this module is included on the given class.
    def self.included(controller_class)
      controller_class.send(:include, InstanceMethods)

      # This reorders the filters applied to requests so that CAS authenticates a user first, before Authorization for documents or pages is checked.
      controller_class.skip_filter :check_access_to_page
      controller_class.skip_filter :try_to_stream_file
      
      controller_class.before_filter :verify_cas_configured
      controller_class.before_filter CASClient::Frameworks::Rails::GatewayFilter
      controller_class.before_filter :login_from_cas_ticket
      controller_class.before_filter :try_to_stream_file      
      controller_class.before_filter :check_access_to_page
      
    end

    # Each instance of the controller will gain these methods.
    module InstanceMethods

      # Provide a more helpful warning if developers forgot to configure the server correctly.
      def verify_cas_configured
        unless BcmsCas::Engine.configured?
          BcmsCas::Engine.raise_configuration_error
        end
      end
      
      # Attempts to set the current user based on the session attribute set by CAS.
      def login_from_cas_ticket
        logger.debug "Checking for cas login. The current_user is '#{@current_user.login}'." if @current_user
        if session[:cas_user]
          user = CasUser.new(:login=>session[:cas_user])

          # Having to set both of these feels very duplicative. Ideally I would like a way
          #   to set only once, but calling current_user= has side effects.
          @current_user = Cms::User.current = user

          logger.debug "CasUser information found in session. Setting current_user as '#{user.login}" if @current_user
        end
        @current_user
      end
    end
  end


  # Extends the core SessionController to properly destroy the local session on logout, and redirect to CAS for Single Log out.
  module SingleLogOut
    def self.included(controller_class)
      controller_class.send(:include, InstanceMethods)
      controller_class.alias_method_chain :destroy, :cas
    end

    module InstanceMethods

      def destroy_with_cas
        logger.debug "Logging user out of both cms and CAS server."
        logout_user
        Cas::Utils.logout(self, "http://#{Rails.application.config.cms.site_domain}/")
      end
    end
  end
end
