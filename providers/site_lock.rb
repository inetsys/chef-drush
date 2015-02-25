#
# Cookbook Name:: drush
# Provider:: site_lock
#

# Support whyrun
def whyrun_supported?
    true
end

action :close do
    if !@current_resource.exists
        Chef::Log.info("#{@new_resource}: Drupal could not be bootstrapped - nothing to do.")
    else
        converge_by("Close #{@new_resource.site}") do
            Chef::Log.info("Running #{@new_resource} at #{@new_resource.drupal_root}")

            if @new_resource.version == 7 then
                drush_variable 'maintenance_mode' do
                    value           1
                    drupal_root     new_resource.drupal_root
                    drupal_uri      new_resource.drupal_uri ? new_resource.drupal_uri : "http://#{new_resource.site}/"
                    shell_user      new_resource.shell_user
                    shell_group     new_resource.shell_group
                end
            elsif @new_resource.version == 6 then
                drush_variable 'site_offline' do
                    value           1
                    drupal_root     new_resource.drupal_root
                    drupal_uri      new_resource.drupal_uri ? new_resource.drupal_uri : "http://#{new_resource.site}/"
                    shell_user      new_resource.shell_user
                    shell_group     new_resource.shell_group
                end
            else
                raise "Drupal version is invalid"
            end

            drush_cmd 'cache-clear' do
                drupal_root     new_resource.drupal_root
                drupal_uri      new_resource.drupal_uri ? new_resource.drupal_uri : "http://#{new_resource.site}/"
                arguments       [ 'menu' ]
                shell_user      new_resource.shell_user
                shell_group     new_resource.shell_group
            end
        end
    end
end

action :open do
    if !@current_resource.exists
        Chef::Log.info("#{@new_resource}: Drupal could not be bootstrapped - nothing to do.")
    else
        converge_by("Open #{@new_resource.site}") do
            Chef::Log.info("Running #{@new_resource} at #{@new_resource.drupal_root}")

            if @new_resource.version == 7 then
                drush_variable 'maintenance_mode' do
                    value           0
                    drupal_root     new_resource.drupal_root
                    drupal_uri      new_resource.drupal_uri
                end
            elsif @new_resource.version == 6 then
                drush_variable 'site_offline' do
                    value           0
                    drupal_root     new_resource.drupal_root
                    drupal_uri      new_resource.drupal_uri
                end
            else
                raise "Drupal version is invalid"
            end

            drush_cmd 'cache-clear' do
                drupal_root     new_resource.drupal_root
                drupal_uri      new_resource.drupal_uri
                arguments       [ 'menu' ]
                shell_user      new_resource.shell_user
                shell_group     new_resource.shell_group
            end
        end
    end
end

def load_current_resource
    @current_resource = Chef::Resource::DrushSiteLock.new(@new_resource.site)

    @current_resource.drupal_root(@new_resource.drupal_root)
    @current_resource.drupal_uri(@new_resource.drupal_uri ? @new_resource.drupal_uri : "http://#{@new_resource.site}/")
    @current_resource.version(@new_resource.version)
    @current_resource.shell_user(@new_resource.shell_user)
    @current_resource.shell_group(@new_resource.shell_group)

    if DrushHelper.drupal_installed?(@current_resource.drupal_root, @current_resource.drupal_uri)
        Chef::Log.debug("Drush bootstrapped Drupal at #{@current_resource.drupal_root}")
        @current_resource.exists = true
    else
        Chef::Log.debug("Drush could not bootstrap Drupal at #{@current_resource.drupal_root}")
    end

    @current_resource
end
