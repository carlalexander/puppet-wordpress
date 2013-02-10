# Define: wordpress::resource::installation
#
# This defines a wordpress installation
#
# Parameters:
#   [*target*]     - Target directory
#   [*dbhost*]     - Database host
#   [*dbname*]     - Database name
#   [*dbuser*]     - Database user
#   [*dbpassword*] - Database password
#   [*dbprefix*]   - Database table prefix
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#  wordpress::resource::installation { 'test.blog':
#    target   => '/var/www',
#    user     => 'root',
#    password => 'password'
#  }
define wordpress::resource::installation (
  $target       = undef,
  $dbhost       = 'localhost',
  $dbname       = 'wordpress',
  $dbuser       = undef,
  $dbpassword   = undef,
  $dbprefix     = 'wp_'
) {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if ($target == undef) {
    fail('You must specify a target location for your wordpress installation')
  }
  if (($dbuser == undef) or ($dbpassword == undef)) {
    fail('You must define a database user and password')
  }

  file { $target:
    ensure => directory
  }

  exec { 'wp-core-download':
    command => '/usr/bin/curl -f http://wordpress.org/latest.tar.gz | tar xz',
    cwd     => $target,
    creates => "${target}/wp-config-sample.php",
    notify  => Exec['wp-core-install'],
    require => File[$target]
  }

  exec { 'wp-core-install':
    command     => '/bin/cp -r wordpress/* . && /bin/rm -rf wordpress',
    cwd         => $target,
    refreshonly => true,
  }

  exec { 'wp-core-config':
    command => "/usr/bin/wp core config --dbname=${dbname} --dbuser=${dbuser} --dbpass=${dbpassword} --dbhost=${dbhost} --dbprefix=${dbprefix}",
    cwd     => $target,
    creates => "${target}/wp-config.php",
    require => Exec['wp-core-download']
  }
}