require 'browsercms'
module BcmsCas
  class Engine < Rails::Engine
    include Cms::Module
    
    NOT_CONFIGURED = "https://localhost:3000/cas-not-configured"
    
    # Delay loading until Rails and BrowserCMS app directory has been loaded
    initializer 'bcms_cas.load_dependencies' do
      require 'bcms_cas/configuration'
      require 'bcms_cas/authentication'
      require 'bcms_cas/login_portlet_extension'
      require 'bcms_cas/acts_as_content_page_extention'
    end
    
    config.after_initialize do
      CASClient::Frameworks::Rails::Filter.configure(
              :cas_base_url => BcmsCas::Engine.cas_server,
              :extra_attributes_session_key => :cas_extra_attributes
      )
    end
    
    config.to_prepare do
      Cms::ContentController.send(:include, Cas::Authentication)
      Cms::SessionsController.send(:include, Cas::SingleLogOut)
      Cms::Acts::ContentPage.send(:include, Cas::Acts::ContentPage)
      
      Cms::ContentController.class_eval do
        helper Cas::LoginPortlet
      end
    end
    
    def self.cas_server
      if Rails.configuration.respond_to? :bcms_cas_server
        Rails.configuration.bcms_cas_server
      else
        NOT_CONFIGURED
      end
    end
    
    def self.configured?
      NOT_CONFIGURED != cas_server
    end
    
    def self.raise_configuration_error      
      error_message = <<message

      Configuration Issue: You must configure a CAS server for the bcms_cas module to work.
      Add the following to 'config/environments/#{Rails.env}.rb'
      
          config.bcms_cas_server = "https://cas.some-domain.com"

message
      raise error_message
    end
  end
end