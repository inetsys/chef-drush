#
# Cookbook Name:: drush
# Resource:: features
#

actions :revert, :revert_all
default_action :revert

# Required attributes
attribute :site, :name_attribute => true, :kind_of => String, :required => true
attribute :features, :kind_of => [ String, Array ], :default => []

attribute :drupal_root, :kind_of => String, :required => true
attribute :drupal_uri, :kind_of => String

# Chef::Mixin::ShellOut options
attribute :shell_user, :regex => Chef::Config[:user_valid_regex]
attribute :shell_group, :regex => Chef::Config[:group_valid_regex]
attribute :shell_timeout, :kind_of => Integer, :default => 900

attr_accessor :exists
