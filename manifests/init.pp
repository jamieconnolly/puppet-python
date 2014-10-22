# Public: Install a pyenv-driven Python stack.
#
# Usage:
#
#     include python

class python(
  $prefix = $python::prefix,
  $user = $python::user
) {

  validate_string($prefix, $user)

  if $::osfamily == 'Darwin' {
    include boxen::config
  }

  include python::pyenv

  if $::osfamily == 'Darwin' {
    boxen::env_script { 'python':
      content  => template('python/env.sh.erb'),
      priority => 'higher'
    }
  }

  file { '/opt/python':
    ensure => directory,
    owner  => $user
  }

  Class['python::pyenv'] -> Python::Definition <| |> -> Python <| |>

}
