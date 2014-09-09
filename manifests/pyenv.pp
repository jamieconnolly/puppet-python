# Private: Manage Python versions with pyenv.
#
# Usage:
#
#     include python::pyenv

class python::pyenv(
  $ensure = undef,
  $prefix = undef,
  $user = undef
) {

  validate_string($ensure, $prefix, $user)

  require python

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => 'yyuu/pyenv',
    user   => $user
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/python',
    require => Repository[$prefix]
  }

}
