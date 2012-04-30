require 'cms/module_installation'

class BcmsCas::InstallGenerator < Cms::ModuleInstallation
  source_root File.expand_path("../templates", __FILE__)
  
  def add_seeds
    template "bcms_cas.seeds.rb", "db/bcms_cas.seeds.rb"
    append_file "db/seeds.rb", "\nrequire File.expand_path('../bcms_cas.seeds.rb', __FILE__)\n"
  
  end
  
  def override_login_form_template
    template "render.html.erb", "app/views/portlets/login/render.html.erb"
  end
end
