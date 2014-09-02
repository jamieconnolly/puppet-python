# Public: Install a pyenv-driven Python stack.
#
# Usage:
#
#     include python

class python(
  $ensure = undef,
  $installdir = undef,
  $user = undef
) {

  validate_re($ensure, '^(present|absent)$')
  validate_string($installdir, $user)

  if $::osfamily == 'Darwin' {
    include boxen::config
  }

  repository { $installdir:
    ensure => $ensure,
    force  => true,
    source => 'yyuu/pyenv',
    user   => $user
  }

  file { "${installdir}/versions":
    ensure  => symlink,
    force   => true,
    backup  => false,
    target  => '/opt/python',
    require => Repository[$installdir]
  }

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

}
