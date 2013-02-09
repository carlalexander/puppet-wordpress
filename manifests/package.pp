# Class: wordpres::package
#
# This module manages WP-CLI package installation.
#
# Parameters:
#
# There are no default parameters for this class.
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# This class file is not called directly
class wordpress::package {
  exec { 'wget-wpcli':
    command => '/usr/bin/wget https://github.com/wp-cli/packages/raw/gh-pages/deb/php-wpcli_0.8-1_all.deb',
    cwd     => '/tmp',
    creates => '/tmp/php-wpcli_0.8-1_all.deb',
  }

  package { 'php-wpcli':
    provider => dpkg,
    ensure   => installed,
    source   => '/tmp/php-wpcli_0.8-1_all.deb',
    require  => Exec['wget-wpcli']
  }
}