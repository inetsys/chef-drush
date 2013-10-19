require 'chef/mixin/shell_out'
require 'chef/mixin/language'
include Chef::Mixin::ShellOut

# Support whyrun
def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists && !@new_resource.force
    Chef::Log.info("#{ new_resource }: Drupal site already installed - nothing to do.")
  else
    converge_by("Create #{ new_resource }") do
      Chef::Log.info("Running #{ new_resource } for #{ new_resource.uri } in #{ new_resource.drupal_root }")

      resource_name = new_resource.drupal_root.gsub('/', '_')

      # @todo - how do I execute `which drush`? Or is this not necessary?
      drush_bin = "drush"

      # Use the execute resource to execute the drush site-install call.
      execute "drush_si_#{ resource_name }" do
        command "#{ drush_bin } -l #{ new_resource.uri } -y site-install #{ new_resource.profile } --site-name=\"#{ new_resource.site_name }\""
        cwd new_resource.drupal_root
      end
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::DrushSiteInstall.new(@new_resource.name)
  @current_resource.drupal_root(@new_resource.drupal_root)
  @current_resource.uri(@new_resource.uri)
  if drupal_installed?(current_resource.drupal_root, current_resource.uri)
    @current_resource.exists = true
  end
end

def drupal_installed?(path, uri)
  Chef::Log.debug("Checking to see if #{ path } is a valid Drupal install")
  p = shell_out("drush -r #{ path } -l #{ uri } status")
  response = nil
  if p.stdout =~ /^\s+Drupal bootstrap \s+\:\s+Successful/i
    Chef::Log.debug("Drush was able to bootstrap Drupal at #{ path }")
    response = true
  end
  response
end
