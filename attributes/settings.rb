default['drush']['settings']['dbdriver'] = 'mysql'
default['drush']['settings']['dbname'] = ''
default['drush']['settings']['dbuser'] = ''
default['drush']['settings']['dbpass'] = ''
default['drush']['settings']['dbhost'] = ''
default['drush']['settings']['dbprefix'] = ''

default['drush']['settings']['hash_salt'] = ''

default['drush']['settings']['cookie_domain'] = ''

default['drush']['settings']['readonly_variables']['omit_vary_cookie'] = false
default['drush']['settings']['readonly_variables']['css_gzip_compression'] = true
default['drush']['settings']['readonly_variables']['js_gzip_compression'] = true
default['drush']['settings']['readonly_variables']['block_cache_bypass_node_grants'] = false
default['drush']['settings']['readonly_variables']['404_fast_paths_exclude'] = '/\/(?:styles)\//'
default['drush']['settings']['readonly_variables']['404_fast_paths'] = '/\.(?:txt|png|gif|jpe?g|css|js|ico|swf|flv|cgi|bat|pl|dll|exe|asp)$/i'
default['drush']['settings']['readonly_variables']['404_fast_html'] = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML+RDFa 1.0//EN" "http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"><html xmlns="http://www.w3.org/1999/xhtml"><head><title>404 Not Found</title></head><body><h1>Not Found</h1><p>The requested URL "@path" was not found on this server.</p></body></html>'

default['drush']['settings']['fast_404'] = false
