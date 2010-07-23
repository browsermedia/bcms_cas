class BcmsCasGenerator < Rails::Generator::Base

  def manifest
    record do |m|
      m.template "initializer.rb", "config/initializers/bcms_cas.rb"
    end
  end
end