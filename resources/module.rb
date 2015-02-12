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

attr_accessor :exists
