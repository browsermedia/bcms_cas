# This seems necessary in order for rake gems:unpack to work.
require 'browsercms'

gem_root = File.expand_path(File.join(File.dirname(__FILE__), ".."))
Cms.add_to_rails_paths gem_root
Cms.add_generator_paths gem_root, "db/migrate/[0-9]*_*.rb"
