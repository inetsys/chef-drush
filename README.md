# Description

Installs the Drush CLI tool for Drupal, via Composer.

# Requirements

* Composer cookbook (http://community.opscode.com/cookbooks/composer)

# Platforms

The following platforms are supported by this cookbook, meaning that the
recipes run on these platforms without error.

* Debian
* Ubuntu
* CentOS

# Recipes

## default

Installs drush using the desired `install_method` recipe, and
also includes minor recipes to meet dependencies.

## composer

Installs drush via Composer.

# Attributes

## default

* `node['drush']['version']` - Drush version of format x.y.z (eg. 5.0.0).
* `node['drush']['install_dir']` - Where to install Drush.
* `node['drush']['user']` - User to run composer commands.

# LWRPs

The drush cookbook contains the following lightweight resources:

* [`drush_cmd`](https://github.com/benclark/chef-drush/wiki/drush-Lightweight-Resources#drush_cmd)
* [`drush_variable`](https://github.com/benclark/chef-drush/wiki/drush-Lightweight-Resources#drush_variable)
* [`drush_php_eval`](https://github.com/benclark/chef-drush/wiki/drush-Lightweight-Resources#drush_php_eval)
* [`drush_make`](https://github.com/benclark/chef-drush/wiki/drush-Lightweight-Resources#drush_make)
* [`drush_site_install`](https://github.com/benclark/chef-drush/wiki/drush-Lightweight-Resources#drush_site_install)

# Usage

Simply include the `drush` or `drush::composer` recipe wherever you would
like drush installed. You may alter the `version` and `user`
attributes appropriately.
