#
# Cookbook Name:: drush
# Library:: helper
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

module DrushHelper
  extend Chef::Mixin::ShellOut

  def self.drupal_present?(path)
    p = shell_out!("#{drush_which} -r #{path} status")
    p.stdout =~ /^\s+Drupal version\s+\:\s+\d+\.\d+/i
  end

  def self.drupal_installed?(path, uri = 'http://default')
    p = shell_out!("#{drush_which} -l #{uri} -r #{path} status")
    p.stdout =~ /^\s+Drupal bootstrap \s+\:\s+Successful/i
  end

  def self.drush_which
    'drush'
  end
end
