# WordPress Module

Puppet module designed to manage and deploy WordPress installations. All WP operations are done using [wp-cli](http://wp-cli.org/).

## Requirements

Currently only tested on Ubuntu Quantal.

## Usage

To install and bootstrap wordpress, simply add the class defintion:

    class { 'wordpress': }

To setup a new wordpress installation

    wordpress::resource::installation { 'test.blog':
      target   => '/var/www',
      user     => 'root',
      password => 'password'
    }