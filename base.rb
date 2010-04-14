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
git :add => ".", :commit => "-m 'clear out README'"

gem 'cucumber',                     :environment => :test
gem 'faker',                        :environment => :test
gem 'rspec',        :lib => 'spec', :environment => :test
gem 'rspec-rails',  :lib => false,  :environment => :test
gem 'machinist',                    :environment => :test
gem 'pickle',                       :environment => :test

gem 'rdiscount'
gem 'facets'
gem 'sqlite3-ruby', :lib => 'sqlite3'

git :add => '.', :commit => '-m "gem configs added"'

rake 'gems:install', :env => :test, :sudo => true

generate :rspec
generate :cucumber, '--capybara'
generate :pickle, :paths, :emails

git :add => '.'
git :commit => '-m "test scaffolding generated"'

rake 'gems:install', :env => :test, :sudo => true

