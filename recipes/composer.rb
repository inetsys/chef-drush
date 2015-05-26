#
# Author:: Mark Sonnabaum <mark.sonnabaum@acquia.com>
# Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
# Cookbook Name:: drush
# Recipe:: pear
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

include_recipe 'composer::install'

execute "install-drush-composer" do
  cwd         ::Dir.home(node['drush']['user'])
  command     "#{node['composer']['bin']} global require drush/drush:#{node['drush']['version']} --no-interaction --no-ansi"
  environment 'COMPOSER_HOME' => ::Dir.home(node['drush']['user']), 'HOME' => ::Dir.home(node['drush']['user']), 'USER' => node['drush']['user']
  user        node['drush']['user']
  only_if     "stat #{node['composer']['bin']}"
  action      :run
end

ruby_block 'ensure composer bin dir is in PATH' do
  block do
    fe = Chef::Util::FileEdit.new("#{::Dir.home(node['drush']['user'])}/.bashrc")
    fe.insert_line_if_no_match(/^PATH="$PATH:$HOME\/vendor\/bin"$/, 'PATH="$PATH:$HOME/vendor/bin"')
    fe.write_file
  end
  action :run
end