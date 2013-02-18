# Class: wordpress
#
# This module manages WordPress.
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
# The module works with sensible defaults:
#
# node default {
#   include wordpress
# }
class wordpress {
  class { 'wordpress::package': }
}