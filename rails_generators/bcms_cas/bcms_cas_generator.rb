class BcmsCasGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.template "initializer.rb", "config/initializers/bcms_cas.rb"

      # Provide a different default template for the Login Form.
      m.directory File.join('app/views/portlets/login')
      m.template "render.html.erb", "app/views/portlets/login/render.html.erb"

      # Provide a helper for Login Form Portlet (this is a workaround for a core CMS bug where portlet helpers are not loaded from gems)
      m.directory File.join('app/portlets/helpers')
      m.template "login_portlet_helper.rb", "app/portlets/helpers/login_portlet_helper.rb"
    end
  end
end