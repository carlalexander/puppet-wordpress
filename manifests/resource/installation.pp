# Define: wordpress::resource::installation
#
# This defines a wordpress installation
#
# Parameters:
#   [*target*]     - Target directory
#   [*owner*]      - Owner. Default: root
#   [*dbhost*]     - Database host. Default: localhost
#   [*dbname*]     - Database name. Default: wordpress
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
  $owner        = 'root',
  $dbhost       = 'localhost',
  $dbname       = 'wordpress',
  $dbuser       = undef,
  $dbpassword   = undef,
  $dbprefix     = 'wp_'
) {
  File {
    owner   => $owner,
    group   => $owner,
    mode    => '0644',
  }

  if ($target == undef) {
    fail('You must specify a target location for your wordpress installation')
  }
  if (($dbuser == undef) or ($dbpassword == undef)) {
    fail('You must define a database user and password')
  }

  file { $target:
    ensure  => directory,
    recurse => true
  }

  exec { "wp-core-download-${name}":
    command => '/usr/bin/curl -f http://wordpress.org/latest.tar.gz | tar xz',
    cwd     => $target,
    creates => "${target}/wp-config-sample.php",
    notify  => Exec["wp-core-install-${name}"],
    require => File[$target]
  }

  exec { "wp-core-install-${name}":
    command     => '/bin/cp -r wordpress/* . && /bin/rm -rf wordpress',
    cwd         => $target,
    refreshonly => true,
  }

  exec { "wp-core-config-${name}":
    command => "/usr/bin/wp core config --dbname=${dbname} --dbuser=${dbuser} --dbpass=${dbpassword} --dbhost=${dbhost} --dbprefix=${dbprefix}",
    cwd     => $target,
    creates => "${target}/wp-config.php",
    notify  => File[$target],
    require => Exec["wp-core-install-${name}"]
  }

  file { "${target}/wp-config.php":
    mode    => '0600',
    require => Exec["wp-core-config-${name}"]
  }
}