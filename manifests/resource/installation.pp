# Define: wordpress::resource::installation
#
# This defines a wordpress installation
#
# Parameters:
#   [*target*]   - Target directory
#   [*host*]     - Database host
#   [*name*]     - Database name
#   [*user*]     - Database user
#   [*password*] - Database password
#   [*prefix*]   - Database table prefix
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
  $target   = undef,
  $host     = 'localhost',
  $name     = 'wordpress',
  $user     = undef,
  $password = undef
  $prefix   = 'wp_'
) {
  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  if ($target == undef) {
    fail('You must specify a target location for your wordpress installation')
  }
  if (($user == undef) or ($password == undef)) {
    fail('You must define a database user and password')
  }

  file { $target:
    ensure => directory
  }

  exec { 'wp-core-download':
    command => '/usr/bin/wp core download',
    cwd     => $target,
    creates => "${target}/wp-config-sample.php",
    Require => File[$target]
  }

  exec { 'wp-core-config':
    command => "/usr/bin/wp core config --dbname=${name} --dbuser=${user} --dbpass=${password} --dbhost=${host} --dbprefix=${prefix}"
    cwd     => $target,
    creates => "${target}/wp-config.php",
    require => Exec['wp-core-download']
  }
}