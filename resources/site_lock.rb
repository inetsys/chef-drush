#
# Cookbook Name:: drush
# Resource:: site_lock
#

actions :close, :open
default_action :close

attribute :site, :name_attribute => true, :kind_of => String, :required => true
attribute :version, :kind_of => Integer, :default => 7
attribute :drupal_root, :kind_of => String, :required => true
attribute :drupal_uri, :kind_of => String

# Chef::Mixin::ShellOut options
attribute :shell_user, :regex => Chef::Config[:user_valid_regex]
attribute :shell_group, :regex => Chef::Config[:group_valid_regex]
attribute :shell_timeout, :kind_of => Integer, :default => 30

attr_accessor :exists
