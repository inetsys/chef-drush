actions :install
default_action :install

attribute :profile, :name_attribute => true, :kind_of => String, :required => true
attribute :drupal_root, :kind_of => String, :required => true

attribute :force, :equal_to => [true, false], :default => false

attribute :uri, :kind_of => String, :default => 'http://default'
attribute :site_name, :kind_of => String

attr_accessor :exists
