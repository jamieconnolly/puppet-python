# Private: Manage Python versions with pyenv.
#
# Usage:
#
#     include python::pyenv

class python::pyenv(
  $ensure = $python::pyenv::ensure,
  $prefix = $python::pyenv::prefix,
  $user = $python::pyenv::user,
  $plugins = {}
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

  create_resources('python::pyenv::plugin', $plugins, {})

  Repository[$prefix] -> Python::Pyenv::Plugin <| |>

}