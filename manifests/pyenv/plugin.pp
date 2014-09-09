# Public: Install a pyenv plugin.
#
# Usage:
#
#     python::pyenv::plugin { 'update':
#       ensure => present,
#       source => 'yyuu/pyenv-update'
#     }

define python::pyenv::plugin(
  $ensure,
  $source
) {

  validate_string($ensure, $source)

  include python::pyenv

  repository { "${python::pyenv::prefix}/plugins/${name}":
    ensure  => $ensure,
    force   => true,
    source  => $source,
    user    => $python::user,
    require => Repository[$python::pyenv::prefix]
  }

}
