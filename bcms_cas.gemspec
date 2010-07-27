# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{bcms_cas}
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["BrowserMedia"]
  s.date = %q{2010-07-27}
  s.description = %q{Allows a BrowserCMS project to connect to a CAS server to authenticate users.}
  s.email = %q{github@browsermedia.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = [
    "app/models/cas_user.rb",
     "app/models/cms/temporary_user.rb",
     "db/migrate/20091002162550_add_cas_user_group.rb",
     "lib/bcms_cas.rb",
     "lib/bcms_cas/authentication.rb",
     "lib/bcms_cas/configuration.rb",
     "lib/bcms_cas/login_portlet_extension.rb",
     "lib/bcms_cas/routes.rb",
     "lib/bcms_cas/utils.rb",
     "rails/init.rb",
     "rails_generators/bcms_cas/bcms_cas_generator.rb",
     "rails_generators/bcms_cas/templates/initializer.rb",
     "rails_generators/bcms_cas/templates/login_portlet_helper.rb",
     "rails_generators/bcms_cas/templates/render.html.erb"
  ]
  s.homepage = %q{http://browsercms.org}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{browsercms}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A CAS Module for BrowserCMS}
  s.test_files = [
    "test/performance/browsing_test.rb",
     "test/test_helper.rb",
     "test/unit/cas/cas_authentication_test.rb",
     "test/unit/cas/configuration_test.rb",
     "test/unit/cas/login_portlet_test.rb",
     "test/unit/cas_user_test.rb",
     "test/unit/cas_utils_test.rb",
     "test/unit/cms/temporary_user_test.rb",
     "test/unit/helpers/login_portlet_helper_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<browsercms>, [">= 3.1"])
      s.add_runtime_dependency(%q<rubycas-client>, [">= 0"])
    else
      s.add_dependency(%q<browsercms>, [">= 3.1"])
      s.add_dependency(%q<rubycas-client>, [">= 0"])
    end
  else
    s.add_dependency(%q<browsercms>, [">= 3.1"])
    s.add_dependency(%q<rubycas-client>, [">= 0"])
  end
end

