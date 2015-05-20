#
# Cookbook Name:: drush
# Resource:: update_settings
#

actions :update
default_action :update

# Required attributes
attribute :site, :name_attribute => true, :kind_of => String, :required => true
attribute :drupal_root, :kind_of => String, :required => true

# Settings
attribute :cookie_domain, :kind_of => String, :default => ''
attribute :db_prefix, :kind_of => [ String, Hash ], :default => ''
# TODO: maintenance theme, cache settings, transactions, etc

# File attributes
attribute :user, :regex => Chef::Config[:user_valid_regex]
attribute :group, :regex => Chef::Config[:group_valid_regex]
attribute :template, :kind_of => String, :default => 'settings.php.erb'
attribute :cookbook, :kind_of => String, :default => 'drush'

attr_accessor :exists
