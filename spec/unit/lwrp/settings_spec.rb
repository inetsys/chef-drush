# test recipe drush_test::test_settings
# @see test/fixtures/cookbooks/drush_test/recipes/test_settings.php

require 'spec_helper'

describe 'drush_test::test_settings' do
    cached(:chef_run) do
        ChefSpec::SoloRunner.new(
            platform: 'centos',
            version: '6.6',
            log_level: :error,
            step_into: 'drush_settings'
        ).converge(described_recipe)
    end

    # Only for get 100% in ChefSpec Coverage
    it 'should obviously do what it does' do
        expect(chef_run).to create_drush_settings('default-mysql')
        expect(chef_run).to create_drush_settings('default-pgsql')
        expect(chef_run).to create_drush_settings('default-sqlite')
        expect(chef_run).to create_drush_settings('port-mysql')
        expect(chef_run).to create_drush_settings('prefix-string-mysql')
        expect(chef_run).to create_drush_settings('prefix-hash-mysql')
        expect(chef_run).to create_drush_settings('variables-mysql')
        expect(chef_run).to create_drush_settings('cookie-mysql')
        expect(chef_run).to create_drush_settings('404-mysql')
    end

    # Example 1
    it 'should create settings.php in site example_1' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_1/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_1/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => ''")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 2
    it 'should create settings.php in site example_2' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_2/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'pgsql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_2/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'pgsql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => ''")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 3
    it 'should create settings.php in site example_3' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_3/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'sqlite',
                dbname: '/path/to/example_3.sqlite',
                dbuser: '',
                dbpass: '',
                dbhost: '',
                dbport: 3306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_3/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'sqlite'")
            expect(content).to include("'database' => '/path/to/example_3.sqlite'")
            expect(content).not_to include("'username' => ")
            expect(content).not_to include("'password' => ")
            expect(content).not_to include("'host' => ")
            expect(content).not_to include("'port' => ")
            expect(content).not_to include("'prefix' => ")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 4
    it 'should create settings.php in site example_4' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_4/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 13306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_4/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 13306")
            expect(content).to include("'prefix' => ''")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 5
    it 'should create settings.php in site example_5' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_5/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: 'master_',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_5/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => 'master_'")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 6
    it 'should create settings.php in site example_6' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_6/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: {
                    'default' => 'master_',
                    'nodes' => 'content_'
                 },
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_6/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => array(")
                expect(content).to include("'default' => 'master_',")
                expect(content).to include("'nodes' => 'content_',")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 7
    it 'should create settings.php in site example_7' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_7/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {
                    'var_true' => true,
                    'var_false' => false,
                    'var_string' => 'test',
                    'var_array' =>  [
                        'row_1',
                        'row_2'
                    ],
                    'var_hash' => {
                        'key_1' => 'value_1',
                        'key_2' => 'value_2'
                    }
                },
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_7/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => ''")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).to include("$conf['var_true'] = true;")
            expect(content).to include("$conf['var_false'] = false;")
            expect(content).to include("$conf['var_string'] = 'test';")
            expect(content).to match(/\$conf\['var_array'\] = array\(\s*'row_1',\s*'row_2',\s*\);/m)
            expect(content).to match(/\$conf\['var_hash'\] = array\(\s*'key_1' => 'value_1',\s*'key_2' => 'value_2',\s*\);/m)

            expect(content).not_to include("$cookie_domain")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 8
    it 'should create settings.php in site example_8' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_8/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '.example.com',
                readonly_variables: {},
                fast_404: false
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_8/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => ''")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).to include("$cookie_domain = '.example.com';")

            expect(content).not_to include("$conf")
            expect(content).not_to include("drupal_fast_404();")
        }
    end

    # Example 9
    it 'should create settings.php in site example_9' do
        expect(chef_run).to create_template('/var/www/drupal/sites/example_9/settings.php').with(
            source: 'settings.php.erb',
            owner: 'test',
            group: 'test',
            mode: '0644',
            cookbook: 'drush',
            variables: {
                dbdriver: 'mysql',
                dbname: 'example_db',
                dbuser: 'example_user',
                dbpass: 'example_pass',
                dbhost: 'localhost',
                dbport: 3306,
                dbprefix: '',
                hash_salt: '1234567890qwertyuiop',
                cookie_domain: '',
                readonly_variables: {},
                fast_404: true
            }
        )

        expect(chef_run).to render_file('/var/www/drupal/sites/example_9/settings.php').with_content { |content|
            expect(content).to include("$databases['default']['default']")
            expect(content).to include("'driver' => 'mysql'")
            expect(content).to include("'database' => 'example_db'")
            expect(content).to include("'username' => 'example_user'")
            expect(content).to include("'password' => 'example_pass'")
            expect(content).to include("'host' => 'localhost'")
            expect(content).to include("'port' => 3306")
            expect(content).to include("'prefix' => ''")

            expect(content).to include("$drupal_hash_salt = '1234567890qwertyuiop';")

            expect(content).not_to include("$conf")
            expect(content).not_to include("$cookie_domain")

            expect(content).to include("drupal_fast_404();")
        }
    end
end