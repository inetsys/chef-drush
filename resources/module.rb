#
# Cookbook Name:: drush
# Resource:: module
#

actions :enable, :disable
default_action :enable

# Required attributes
attribute :site, :name_attribute => true, :kind_of => String, :required => true
attribute :modules, :kind_of => [ String, Array ], :required => true

attribute :drupal_root, :kind_of => String, :required => true
attribute :drupal_uri, :kind_of => String

# Chef::Mixin::ShellOut options
attribute :shell_user, :regex => Chef::Config[:user_valid_regex]
attribute :shell_group, :regex => Chef::Config[:group_valid_regex]
attribute :shell_timeout, :kind_of => Integer, :default => 900

attr_accessor :exists
