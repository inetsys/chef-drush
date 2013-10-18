actions :install
default_action :install

# Required attributes
attribute :build_path, :name_attribute => true, :kind_of => String, :required => true
attribute :makefile, :kind_of => String, :required => true

attr_accessor :exists
