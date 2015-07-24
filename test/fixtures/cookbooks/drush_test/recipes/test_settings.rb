# rspec test lwrp drush_settings
# @see spec/unit/lwrp/settings_spec.rb

drush_settings 'default-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_1'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    hash_salt               '1234567890qwertyuiop'
    user                    'test'
    group                   'test'
end

drush_settings 'default-pgsql' do
    drupal_root             '/var/www/drupal'
    site                    'example_2'
    dbdriver                'pgsql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    hash_salt               '1234567890qwertyuiop'
    user                    'test'
    group                   'test'
end

drush_settings 'default-sqlite' do
    drupal_root             '/var/www/drupal'
    site                    'example_3'
    dbdriver                'sqlite'
    dbname                  '/path/to/example_3.sqlite'
    hash_salt               '1234567890qwertyuiop'
    user                    'test'
    group                   'test'
end

drush_settings 'port-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_4'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    dbport                  13306
    hash_salt               '1234567890qwertyuiop'
    user                    'test'
    group                   'test'
end

drush_settings 'prefix-string-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_5'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    dbprefix                'master_'
    hash_salt               '1234567890qwertyuiop'
    user                    'test'
    group                   'test'
end

drush_settings 'prefix-hash-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_6'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    dbprefix                'default' => 'master_', 'nodes' => 'content_'
    hash_salt               '1234567890qwertyuiop'
    user                    'test'
    group                   'test'
end

drush_settings 'variables-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_7'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    hash_salt               '1234567890qwertyuiop'
    readonly_variables      'var_true' => true, 'var_false' => false, 'var_string' => 'test', 'var_array' =>  ['row_1', 'row_2'], 'var_hash' => { 'key_1' => 'value_1', 'key_2' => 'value_2' }
    user                    'test'
    group                   'test'
end

drush_settings 'cookie-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_8'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    hash_salt               '1234567890qwertyuiop'
    cookie_domain           '.example.com'
    user                    'test'
    group                   'test'
end

drush_settings '404-mysql' do
    drupal_root             '/var/www/drupal'
    site                    'example_9'
    dbdriver                'mysql'
    dbname                  'example_db'
    dbuser                  'example_user'
    dbpass                  'example_pass'
    dbhost                  'localhost'
    hash_salt               '1234567890qwertyuiop'
    fast_404                true
    user                    'test'
    group                   'test'
end
