#
# Author:: David King <dking@xforty.com>
# Contributor:: Patrick Connolly <patrick@myplanetdigital.com>
# Cookbook Name:: drush
# Attributes:: default
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

# When installing via PEAR, this is the preferred state (stable, beta, devel)
# or a specific x.y.z pear version (eg. 4.5.0).
default['drush']['version'] = "7.*"

# URL of allreleases.xml for pear to install from preferred states
default['drush']['allreleases'] = "http://pear.drush.org/rest/r/drush/allreleases.xml"

default['drush']['user'] = 'drush'