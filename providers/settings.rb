#
# Cookbook Name:: drush
# Provider:: update_settings
#

# Support whyrun
def whyrun_supported?
    true
end

action :create do
    converge_by("Create #{@new_resource}") do

        Chef::Log.info("Update settings in #{@new_resource.site}...")


        settings_file = ::File.join(new_resource.drupal_root, 'sites', new_resource.site, 'settings.php')

        ::File.chmod(0666, settings_file) if ::File.exist?(settings_file)

        template settings_file do
            source          new_resource.template
            owner           new_resource.user
            group           new_resource.group
            mode            '0644'
            cookbook        new_resource.cookbook
            variables(
                :dbdriver => new_resource.dbdriver,
                :dbname => new_resource.dbname,
                :dbuser => new_resource.dbuser,
                :dbpass => new_resource.dbpass,
                :dbhost => new_resource.dbhost,
                :dbport => new_resource.dbport,
                :dbprefix => new_resource.dbprefix,
                :hash_salt => new_resource.hash_salt,
                :cookie_domain => new_resource.cookie_domain,
                :readonly_variables => new_resource.readonly_variables,
                :fast_404 => new_resource.fast_404
            )
        end

        Chef::Log.info("Settings updated")
    end
end
