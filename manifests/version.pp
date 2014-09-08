# Public: Install a Python version via python-build.
#
# Usage:
#
#     python::version { '2.7.8': }

define python::version(
  $ensure = present,
  $env = {},
  $version = $name
) {

  validate_re($ensure, '^(present|absent)$')
  validate_string($version)

  require python

  $alias_hash = hiera_hash('python::version::alias', {})

  if has_key($alias_hash, $version) {
    $to = $alias_hash[$version]

    python::alias { $version:
      ensure => $ensure,
      to     => $to
    }
  } else {

    case $version {
      /jython/: { require java }
      default: { }
    }

    if $::osfamily == 'Darwin' {
      require xquartz

      include homebrew::config
      include boxen::config

      ensure_resource('package', 'readline')
      Package['readline'] -> Python <| |>
    }

    $default_env = {
      'CC' => '/usr/bin/cc',
    }

    $hierdata = hiera_hash('python::version::env', {})

    if has_key($hierdata, $::operatingsystem) {
      $os_env = $hierdata[$::operatingsystem]
    } else {
      $os_env = {}
    }

    if has_key($hierdata, $version) {
      $version_env = $hierdata[$version]
    } else {
      $version_env = {}
    }

    $_env = merge(merge(merge($default_env, $os_env), $version_env), $env)

    python { $version:
      ensure      => $ensure,
      environment => $_env,
      provider    => pyenv,
      pyenv_root  => $python::pyenv::prefix,
      user        => $python::user
    }

  }

}
