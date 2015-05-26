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

    def self.homedir_user(username)
        return @homedir unless @homedir.nil?
        @homedir = '/nonexistent'
        begin
            @homedir = Dir.home(username)
        rescue ArgumentError
            @homedir = "/home/#{username}"
        end
        @homedir
    end

    def self.drupal_present?(user, path)
        p = shell_out!("#{drush_which} -r #{path} status",
                :user => user,
                :environment => {
                    'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                    'HOME' => DrushHelper.homedir_user(user),
                    'USER' => user,
                    'LC_ALL' => 'es_ES.UTF-8',
                    'LANGUAGE' => 'es_ES.UTF-8',
                    'LANG' => 'es_ES.UTF-8'
                })
        p.stdout =~ /^\s+Drupal version\s+\:\s+\d+\.\d+/i
    end

    def self.drupal_installed?(user, path, uri = 'http://default')
        begin
            p = shell_out!("#{drush_which} -l #{uri} -r #{path} status",
                    :user => user,
                    :environment => {
                        'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                        'HOME' => DrushHelper.homedir_user(user),
                        'USER' => user,
                        'LC_ALL' => 'es_ES.UTF-8',
                        'LANGUAGE' => 'es_ES.UTF-8',
                        'LANG' => 'es_ES.UTF-8'
                    })
            Chef::Log.debug("drupal_installed?: drush status STDOUT: #{p.stdout}")
            p.stdout =~ /^\s+Drupal bootstrap \s+\:\s+Successful/i
        rescue => e
            Chef::Log.debug("drupal_installed?: #{e.message}")
            # Check whether the system table is present. The assumption here is that
            # there is no database prefix.
            begin
                p2 = shell_out!("#{drush_which} -l #{uri} -r #{path} sql-cli",
                    :input => 'SELECT * FROM system LIMIT 0,1',
                    :user => user,
                    :environment => {
                        'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                        'HOME' => DrushHelper.homedir_user(user),
                        'USER' => user,
                        'LC_ALL' => 'es_ES.UTF-8',
                        'LANGUAGE' => 'es_ES.UTF-8',
                        'LANG' => 'es_ES.UTF-8'
                    })
                Chef::Log.debug("drupal_installed?: drush sql-cli STDOUT: #{p2.stdout}")
                Chef::Log.debug("drupal_installed?: drush sql-cli STDERR: #{p2.stderr}")
                if (p2.stderr =~ /Table.+\.system.+doesn't exist/i)
                    # Safe to assume Drupal is not installed if it explicitly says the
                    # system table is missing.
                    Chef::Log.debug("drupal_installed?: system table doesn't exist; Drupal not installed")
                    return false
                end
            rescue => e2
                Chef::Log.debug("drupal_installed?: #{e2.message}")
            end
            raise "drupal_installed?: could not reliably determine whether Drupal is installed or not"
        end
    end

    def self.drush_vget_json(user, path, name, uri = 'http://default', exact_match = true)
        exact_option = "--exact" if exact_match
        cmd = "#{drush_which} -l #{uri} -r #{path} vget #{name} #{exact_option} --format=json"
        Chef::Log.debug("drush_vget: #{cmd}")
        begin
            p = shell_out!(cmd,
                :user => user,
                :environment => {
                    'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                    'HOME' => DrushHelper.homedir_user(user),
                    'USER' => user,
                    'LC_ALL' => 'es_ES.UTF-8',
                    'LANGUAGE' => 'es_ES.UTF-8',
                    'LANG' => 'es_ES.UTF-8'
                })
            JSON.parse(p.stdout, { :symbolize_names => false }) if p && p.stdout
        rescue => e
            Chef::Log.debug("drush_vget: #{e.message}")
        end
    end

    def self.drush_vget_match?(user, path, name, value, uri = 'http://default')
        vget = drush_vget_json(user, path, name, uri)
        # I know this looks crazy, but it's due to the escaped string that
        # `drush --format=json` returns.
        vget = JSON.generate(vget)
        # Convert the value to JSON for later string comparison.
        value = value.to_s if value.is_a?(Integer)
        value_json = JSON.generate({ name => value })

        Chef::Log.debug("drush_vget_match?: value = #{value_json.to_s}")
        Chef::Log.debug("drush_vget_match?:  vget = #{vget.to_s}")

        !vget.nil? && vget.to_s == value_json.to_s
    end

    def self.drush_which
        'drush'
    end

    def self.is_enabled?(user, path, uri, name)
        cmd = "#{drush_which} -l #{uri} -r #{path} pmi #{name}"
        p = shell_out!(cmd,
            :user => user,
            :environment => {
                'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                'HOME' => DrushHelper.homedir_user(user),
                'USER' => user,
                'LC_ALL' => 'es_ES.UTF-8',
                'LANGUAGE' => 'es_ES.UTF-8',
                'LANG' => 'es_ES.UTF-8'
            })

        p.stdout =~ /^\s*Status\s*:\s*enabled/i
    end

    def self.get_module_list(user, path, uri)
        module_list = {}

        cmd = "#{drush_which} -l #{uri} -r #{path} pml --pipe --status=\"enabled\""
        p = shell_out!(cmd,
            :user => user,
            :environment => {
                'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                'HOME' => DrushHelper.homedir_user(user),
                'USER' => user,
                'LC_ALL' => 'es_ES.UTF-8',
                'LANGUAGE' => 'es_ES.UTF-8',
                'LANG' => 'es_ES.UTF-8'
            })
        rows = p.stdout.split("\n")
        rows.each do |row|
            module_list[row] = true
        end

        cmd = "#{drush_which} -l #{uri} -r #{path} pml --pipe --status=\"disabled,not installed\""
        p = shell_out!(cmd,
            :user => user,
            :environment => {
                'PATH' => "/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:#{self.homedir_user(user)}/vendor/bin",
                'HOME' => DrushHelper.homedir_user(user),
                'USER' => user,
                'LC_ALL' => 'es_ES.UTF-8',
                'LANGUAGE' => 'es_ES.UTF-8',
                'LANG' => 'es_ES.UTF-8'
            })
        rows = p.stdout.split("\n")
        rows.each do |row|
            module_list[row] = false
        end

        module_list
    end
end
