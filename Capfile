require 'capistrano/setup'

require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/passenger'
require 'capistrano/yarn'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
