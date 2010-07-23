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

      controller_class.skip_filter :check_access_to_page
      controller_class.before_filter CASClient::Frameworks::Rails::GatewayFilter
      controller_class.before_filter :login_from_cas_ticket
      controller_class.before_filter :check_access_to_page_normally
    end

    # Each instance of the controller will gain these methods.
    module InstanceMethods
      def check_access_to_page_normally
        logger.warn "Checking auth using normal Cms filter."
        check_access_to_page
      end

      # Attempts to set the current user based on the session attribute set by CAS.
      def login_from_cas_ticket
        logger.debug "Attempting to login using CAS session variable."
        if session[:cas_user]
          logger.info "Who is @current_user '#{@current_user.login}'?" if @current_user
          logger.info "Who is User.current '#{User.current.login}'?" if User.current

          user = CasUser.new(:login=>session[:cas_user])

          # Having to set both of these feels very duplicative. Ideally I would like a way
          #   to set only once, but calling current_user= has sideeffects.
          @current_user = User.current = user

          logger.info "Found session[:cas_user]. Created CasUser with login '#{user.login}' and set as current_user." if @current_user
        end
        @current_user
      end
    end
  end
  Cms::ContentController.send(:include, Cas::Authentication)


  # Extends the core SessionController to properly destroy the local session on logout, and redirect to CAS for Single Log out.
  module SingleLogOut
    def self.included(controller_class)
      controller_class.send(:include, InstanceMethods)
      controller_class.alias_method_chain :destroy, :cas
    end

    module InstanceMethods

      def destroy_with_cas
        logger.info "Handle single logout."
        logout_user
        Cas::Utils.logout(self, "http://#{SITE_DOMAIN}/")
      end
    end
  end
  Cms::SessionsController.send(:include, Cas::SingleLogOut)
end
