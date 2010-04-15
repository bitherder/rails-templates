def spec_config_add(data = nil, options = {}, &block)
  sentinel = 'Spec::Runner.configure do |config|'

  data = block.call if !data && block_given?

  in_root do
    gsub_file 'spec/spec_helper.rb', /(#{Regexp.escape(sentinel)})/mi do |match|
      "#{match}\n  " << data
    end
  end
end

def spec_config(name, value = '')
  log 'spec_config', name
  spec_config_add "config.#{name} = #{value.inspect}"
end

git :init

file 'tmp/.gitignore', <<-END
**/*
END

file 'log/.gitignore', <<-END
*.log
END

run 'touch vendor/.gitignore'

file ".gitignore", <<-END
config/database.yml
db/*.sqlite3
.DS_Store
**/.DS_Store
*.html
**/*.bak
**/*.back
rerun.txt
archive
END

git :add => '.', :commit => '-m "just generated from rails command"'

run "echo 'TODO add readme content' > README"
git :add => '.', :commit => '-m "clear out README"'

gem 'rspec',        :lib => 'spec', :environment => :test
gem 'rspec-rails',  :lib => false,  :environment => :test
gem 'faker',                        :environment => :test
gem 'machinist',                    :environment => :test
gem 'rr',                           :environment => :test
gem 'cucumber',                     :environment => :test
gem 'pickle',                       :environment => :test

gem 'rdiscount'
gem 'facets'
gem 'sqlite3-ruby', :lib => 'sqlite3'

git :add => '.', :commit => '-m "gem configs added"'

rake 'gems:install', :env => :test, :sudo => true

generate :rspec
generate :cucumber, '--capybara'
generate :pickle, :paths, :emails

spec_config :mock_with, :mocha

git :add => '.'
git :commit => '-m "test scaffolding generated"'

rake 'gems:install', :env => :test, :sudo => true

