#
# Cookbook Name:: drush
# Resource:: update_settings
#

actions :create
default_action :create

# Required attributes
attribute :site, :name_attribute => true, :kind_of => String, :required => true
attribute :drupal_root, :kind_of => String, :required => true

# Settings
attribute :dbdriver, :kind_of => String, :required => true, :equal_to => ['mysql', 'pgsql', 'sqlite']
attribute :dbname, :kind_of => String, :required => true
attribute :dbuser, :kind_of => String, :default => ''
attribute :dbpass, :kind_of => String, :default => ''
attribute :dbhost, :kind_of => String, :default => ''
attribute :dbport, :kind_of => [String, Integer], :default => 3306
attribute :dbprefix, :kind_of => [String, Hash], :default => ''
attribute :hash_salt, :kind_of => String, :required => true
attribute :cookie_domain, :kind_of => String, :default => ''
attribute :readonly_variables, :kind_of => Hash, :default => {}
attribute :fast_404, :kind_of => [TrueClass, FalseClass], :default => false

# File attributes
attribute :user, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
attribute :template, :kind_of => String, :default => 'settings.php.erb'
attribute :cookbook, :kind_of => String, :default => 'drush'

attr_accessor :exists
