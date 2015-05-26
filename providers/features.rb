#
# Cookbook Name:: drush
# Provider:: features
#

# Support whyrun
def whyrun_supported?
    true
end

action :revert_all do
    if @current_resource.exists
        converge_by("Create #{@new_resource}") do
            Chef::Log.info("Reverting overriden features in #{new_resource.site}...")

            drush_cmd "fra" do
                drupal_root     new_resource.drupal_root
                drupal_uri      new_resource.drupal_uri ? new_resource.drupal_uri : "http://#{new_resource.site}/"
                shell_user      new_resource.shell_user
                shell_group     new_resource.shell_group
                shell_timeout   new_resource.shell_timeout
            end
            Chef::Log.info("Features reverted")
        end
    end
end

action :revert do
    to_revert = @new_resource.features.is_a?(String) ? [ @new_resource.features ] : @new_resource.features

    if !@current_resource.exists
        # Nothing to do
    elsif to_revert.any?
        converge_by("Create #{@new_resource}") do
            Chef::Log.info("Reverting features in #{new_resource.site}...")

            drush_cmd "fr" do
                arguments       to_revert
                drupal_root     new_resource.drupal_root
                drupal_uri      new_resource.drupal_uri
                shell_user      new_resource.shell_user
                shell_group     new_resource.shell_group
                shell_timeout   new_resource.shell_timeout
            end
            Chef::Log.info("Features reverted")
        end
    else
        Chef::Log.info("Empty list of features to revert in #{new_resource.site}")
    end
end

def load_current_resource
    @current_resource = Chef::Resource::DrushFeatures.new(@new_resource.site)

    @current_resource.drupal_root(@new_resource.drupal_root)
    @current_resource.drupal_uri(@new_resource.drupal_uri ? @new_resource.drupal_uri : "http://#{@new_resource.site}/")
    @current_resource.features(@new_resource.features)

    if DrushHelper.drupal_installed?(@new_resource.shell_user, @current_resource.drupal_root, @current_resource.drupal_uri) && DrushHelper.is_enabled?(@new_resource.shell_user, @current_resource.drupal_root, @current_resource.drupal_uri, 'features')
        @current_resource.exists = true
    else
        Chef::Log.debug("Drush could not bootstrap Drupal with module \"features\" enabled at #{@current_resource.drupal_root}")
    end

    @current_resource
end
