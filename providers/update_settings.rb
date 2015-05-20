#
# Cookbook Name:: drush
# Provider:: update_settings
#

# Support whyrun
def whyrun_supported?
    true
end

action :update do
    if @current_resource.exists
        converge_by("Create #{@current_resource}") do

            Chef::Log.info("Update settings in #{@current_resource.site}...")

            settings_file = ::File.join(new_resource.drupal_root, 'sites', new_resource.site, 'settings.php')
            original_content = ::File.open(settings_file).read
            ::File.delete(settings_file)

            template settings_file do
                source          new_resource.template
                owner           new_resource.user
                group           new_resource.group
                mode            '0644'
                cookbook        new_resource.cookbook
                variables(
                    :original_content => original_content,
                    :cookie_domain => new_resource.cookie_domain,
                    :db_prefix => new_resource.db_prefix
                )
            end

            Chef::Log.info("Settings updated")
        end
    end
end

def load_current_resource
    @current_resource = Chef::Resource::DrushUpdateSettings.new(@new_resource.site)

    @current_resource.template(@new_resource.template)
    @current_resource.cookbook(@new_resource.cookbook)
    @current_resource.user(@new_resource.user)
    @current_resource.group(@new_resource.group)

    @current_resource.drupal_root(@new_resource.drupal_root)
    @current_resource.cookie_domain(@new_resource.cookie_domain)
    @current_resource.db_prefix(@new_resource.db_prefix)

    settings_file = ::File.join(@new_resource.drupal_root, 'sites', @new_resource.site, 'settings.php')

    if ::File.exist?(settings_file)
        @current_resource.exists = true
    else
        Chef::Log.warn("File #{settings_file} does not exist")
    end

    @current_resource
end
