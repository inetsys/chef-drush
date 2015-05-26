#
# Cookbook Name:: drush
# Provider:: module
#

# Support whyrun
def whyrun_supported?
    true
end

action :enable do
    if !@current_resource.exists
        Chef::Log.info("#{@new_resource}: Drupal could not be bootstrapped - nothing to do.")
    elsif @new_resource.modules.any?
        converge_by("Create #{@new_resource}") do
            Chef::Log.info("Running #{@new_resource} at #{@new_resource.drupal_root}")

            site_modules = DrushHelper.get_module_list(new_resource.shell_user, @current_resource.drupal_root, @current_resource.drupal_uri)

            to_enable = []
            error = []

            @new_resource.modules.each do |name|
                if site_modules[name].nil? then
                    Chef::Log.error("Module #{name} does not exist")
                    error.push(name)
                elsif site_modules[name] then
                    Chef::Log.info("Module #{name} is already enabled")
                else
                    to_enable.push(name)
                end
            end

            if error.any? then
                raise "Drush enable: Some modules cannot be enabled: #{error}"
            end

            drush_cmd "en" do
                arguments       to_enable.join(' ')
                drupal_root     new_resource.drupal_root
                drupal_uri      new_resource.drupal_uri ? new_resource.drupal_uri : "http://#{new_resource.site}/"
                shell_user      new_resource.shell_user
                shell_group     new_resource.shell_group
                shell_timeout   new_resource.shell_timeout
                only_if { to_enable.any? }
            end
        end
    end
end

action :disable do
    # ...
end

def load_current_resource
    @current_resource = Chef::Resource::DrushModule.new(@new_resource.site)

    @current_resource.drupal_root(@new_resource.drupal_root)
    @current_resource.drupal_uri(@new_resource.drupal_uri)
    @current_resource.modules(@new_resource.modules)

    if DrushHelper.drupal_installed?(@new_resource.shell_user, @current_resource.drupal_root, @current_resource.drupal_uri)
        Chef::Log.debug("Drush bootstrapped Drupal at #{@current_resource.drupal_root}")
        @current_resource.exists = true
    else
        Chef::Log.debug("Drush could not bootstrap Drupal at #{@current_resource.drupal_root}")
    end

    @current_resource
end
