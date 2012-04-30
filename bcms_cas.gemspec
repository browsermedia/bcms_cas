# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bcms_cas/version"

Gem::Specification.new do |s|
  s.name        = "bcms_cas"
  s.version     = BcmsCas::VERSION

  s.authors = ["BrowserMedia"]
  s.description = %q{Allows a BrowserCMS project to connect to a CAS server to authenticate users.}
  s.summary = %q{A CAS Module for BrowserCMS}
  s.email = %q{github@browsermedia.com}
  s.extra_rdoc_files = [
    "README.markdown"
  ]
  s.files = Dir["{app,lib}/**/*"]
  s.files += Dir["db/bcms_seeds.rb"]
  s.files += Dir["Gemfile", "LICENSE.txt", "COPYRIGHT.txt", "GPL.txt" ]

  s.test_files += Dir["test/**/*"]
  s.test_files -= Dir['test/dummy/**/*']
  
  s.homepage = %q{https://github.com/browsermedia/bcms_cas}
  s.require_paths = ["lib"]

  s.add_dependency("browsercms", "~> 3.3.4")
  s.add_dependency("rubycas-client")
  
end


