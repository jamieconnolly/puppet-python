# Private: Manage Python versions with pyenv.
#
# Usage:
#
#     include python::pyenv

class python::pyenv(
  $ensure = $python::pyenv::ensure,
  $prefix = $python::pyenv::prefix,
  $source = $python::pyenv::source,
  $user = $python::pyenv::user
) {

  validate_string($ensure, $prefix, $user)

  require python

  repository { $prefix:
    ensure => $ensure,
    force  => true,
    source => $source,
    user   => $user
  }

  file { "${prefix}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/python',
    require => Repository[$prefix]
  }

  $plugins_hash = hiera_hash('python::pyenv::plugins', {})
  create_resources('python::pyenv::plugin', $plugins_hash)

  Repository[$prefix] -> Python::Pyenv::Plugin <| |>

}
