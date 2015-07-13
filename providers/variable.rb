#
# Cookbook Name:: drush
# Provider:: variable
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

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :set do
	if !@current_resource.exists
		Chef::Log.info("#{@new_resource}: Drupal could not be bootstrapped - nothing to do.")
	elsif DrushHelper.drush_vget_match?(@new_resource.shell_user, @new_resource.drupal_root, @new_resource.name, @new_resource.value, @new_resource.drupal_uri)
		Chef::Log.info("#{@new_resource}: Drupal variable matches value - nothing to do.")
	else
		converge_by("Create #{@new_resource}") do
			Chef::Log.info("Running #{@new_resource} at #{@new_resource.drupal_root}")

			# Set drush options
			options = [ "--exact", "--uri=#{new_resource.drupal_uri}", "--yes" ]

			# Format the value as JSON if it's a Hash or Array
			value = @new_resource.value
			if value.is_a?(Hash) || value.is_a?(Array)
				options << "--format=json"
			# Format the value as String if it's not already
			elsif !value.is_a?(String)
				value = value.to_s
			end

			# Build the shell options
			shell_options = {}
			shell_options[:input] = JSON.generate(value).to_s if value.is_a?(Hash) || value.is_a?(Array)
			shell_options[:timeout] = new_resource.shell_timeout
			shell_options[:user] = new_resource.shell_user if new_resource.shell_user
			shell_options[:group] = new_resource.shell_group if new_resource.shell_group
			shell_options[:cwd] = new_resource.drupal_root if new_resource.drupal_root && ::File.directory?(new_resource.drupal_root)
			shell_options[:environment] = {}
			shell_options[:environment]['HOME'] = ::File.expand_path("~#{new_resource.shell_user}") if new_resource.shell_user
			shell_options[:environment]['PATH'] = "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{::Dir.home(new_resource.shell_user)}/vendor/bin"

			# Build the drush command
			drush_command = [ DrushHelper.drush_which ]
			drush_command << options.join(' ')
			drush_command << 'vset'
			drush_command << '"' + new_resource.name + '"'
			if value.is_a?(Hash) || value.is_a?(Array)
				drush_command << '-'
			else
				drush_command << '"' + value + '"'
			end

			# Execute the drush command
			cmd = drush_command.join(' ')
			Chef::Log.debug("drush_cmd: Execute #{cmd}")
			p = shell_out!(cmd, shell_options)

			new_resource.updated_by_last_action(true)
		end
	end
end

def load_current_resource
	@current_resource = Chef::Resource::DrushVariable.new(@new_resource.name)
	@current_resource.drupal_root(@new_resource.drupal_root)
	@current_resource.drupal_uri(@new_resource.drupal_uri)
	if DrushHelper.drupal_installed?(@new_resource.shell_user, @current_resource.drupal_root, @current_resource.drupal_uri)
		Chef::Log.debug("Drush bootstrapped Drupal at #{@current_resource.drupal_root}")
		@current_resource.exists = true
	else
		Chef::Log.debug("Drush could not bootstrap Drupal at #{@current_resource.drupal_root}")
	end
	@current_resource
end
