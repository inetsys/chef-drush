#
# Cookbook Name:: drush
# Provider:: site_install
#
# Author:: Ben Clark <ben@benclark.com>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Support whyrun
def whyrun_supported?
  true
end

action :install do
  if @current_resource.exists && !@new_resource.force
    Chef::Log.info("#{@new_resource}: Drupal site already exists - nothing to do.")
  else
    converge_by("Create #{@new_resource}") do
      Chef::Log.info("Running #{@new_resource} for #{@new_resource.drupal_uri} in #{@new_resource.drupal_root}")

      # Execute the drush site-install command.
      drush_cmd "site-install" do
        arguments new_resource.profile
        options "--site-name=\"#{new_resource.site_name}\""

        drupal_root new_resource.drupal_root
        drupal_uri new_resource.drupal_uri

        shell_user new_resource.shell_user
        shell_group new_resource.shell_group
        shell_timeout new_resource.shell_timeout
      end
    end
  end
end

def load_current_resource
  @current_resource = Chef::Resource::DrushSiteInstall.new(@new_resource.name)
  @current_resource.drupal_root(@new_resource.drupal_root)
  @current_resource.drupal_uri(@new_resource.drupal_uri)
  if DrushHelper.drupal_installed?(@current_resource.drupal_root, @current_resource.drupal_uri)
    Chef::Log.debug("Drush successfully bootstrapped Drupal at #{@current_resource.drupal_root}")
    @current_resource.exists = true
  else
    Chef::Log.debug("Drush could not bootstrap Drupal at #{@current_resource.drupal_root}")
  end
  @current_resource
end
