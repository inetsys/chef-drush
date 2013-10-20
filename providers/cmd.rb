#
# Cookbook Name:: drush
# Provider:: cmd
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

require 'chef/mixin/shell_out'
include Chef::Mixin::ShellOut

action :execute do
  # Build the shell options
  shell_options = {}
  shell_options[:timeout] = new_resource.shell_timeout if new_resource.shell_timeout
  shell_options[:user] = new_resource.shell_user if new_resource.shell_user
  shell_options[:group] = new_resource.shell_group if new_resource.shell_group
  shell_options[:cwd] = new_resource.drupal_root if new_resource.drupal_root && ::File.directory?(new_resource.drupal_root)
  shell_options[:environment] = { 'HOME' => ::File.expand_path("~#{new_resource.shell_user}") } if new_resource.shell_user

  # Build the drush options
  drush_options = [ "--uri=#{new_resource.drupal_uri}" ]
  drush_options << "--yes" if new_resource.assume_yes
  drush_options << "--no" if new_resource.assume_no
  drush_options << "--backend" if new_resource.backend

  # Build the drush command
  drush_command = [ DrushHelper.drush_which ]
  drush_command << drush_options.join(' ')
  drush_command << new_resource.command
  drush_command << new_resource.options
  drush_command << new_resource.arguments

  # Execute the drush command
  cmd = drush_command.join(' ')
  Chef::Log.debug("Execute #{cmd}")
  shell_out!(cmd, shell_options)

  new_resource.block.call(p.stdout) if new_resource.block
  new_resource.updated_by_last_action(true)
end
