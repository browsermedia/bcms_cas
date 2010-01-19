# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'tasks/rails'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |spec|
    spec.name = "bcms_cas"
    spec.rubyforge_project = "browsercms"
    spec.summary = "A CAS Module for BrowserCMS"
    spec.author = "BrowserMedia"
    spec.email = "github@browsermedia.com"
    spec.homepage = "http://browsercms.org"
    spec.description = "Allows a BrowserCMS project to connect to a CAS server to authenticate users."
    spec.files = Dir["app/**/*"]
    spec.files -= Dir["app/portlets/helpers/login_portlet_helper.rb"]
    spec.files += Dir["db/migrate/*.rb"]
    spec.files -= Dir["db/migrate/*_browsercms_*.rb"]
    spec.files -= Dir["db/migrate/*_load_seed_data.rb"]
    spec.files += Dir["lib/bcms_cas.rb"]
    spec.files += Dir["lib/bcms_cas/*"]
    spec.files += Dir["lib/cas/*"]
    spec.files += Dir["rails/init.rb"]
    spec.has_rdoc = true
    spec.extra_rdoc_files = ["README.markdown"]
  end

  Jeweler::RubyforgeTasks.new do |rubyforge|

  end

rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end
