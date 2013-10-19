require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

# Support whyrun
def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists
    Chef::Log.info("#{ new_resource }: Drupal install already exists - nothing to do.")
  else
    converge_by("Create #{ new_resource }") do
      Chef::Log.info("Running #{ new_resource } for #{ new_resource.makefile }")

      resource_name = new_resource.build_path.gsub('/', '_')

      # @todo - how do I execute `which drush`? Or is this not necessary?
      drush_bin = "drush"

      # ensure the build path directory is present.
      directory new_resource.build_path do
        owner "root"
        group "root"
        mode "0755"
        action :create
      end

      # Use the execute resource to execute the drush make call.
      execute "drush_make_#{ resource_name }" do
        # Drush make fails if the directory exists *unless* it's the current
        # directory, so use the cwd parameter here.
        command "#{ drush_bin } -y make #{ new_resource.makefile } ."
        cwd new_resource.build_path
      end
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::DrushMake.new(@new_resource.name)
  @current_resource.build_path(@new_resource.build_path)
  if drupal_exists?(current_resource.build_path)
    @current_resource.exists = true
  end
end

def drupal_exists?(path)
  Chef::Log.debug("Checking to see if #{ path } is a valid Drupal install")
  p = shell_out("drush -r #{ path } status")
  response = nil
  if p.stdout =~ /^\s+Drupal version\s+\:\s+\d+\.\d+/i
    Chef::Log.debug("Drush found a valid install of Drupal at #{ path }")
    response = true
  end
  response
end
