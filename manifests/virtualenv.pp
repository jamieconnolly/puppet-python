# Public: Create a lightweight "virtual environment".
#
# Usage:
#
#     python::virtualenv { 'venv':
#       dir => '/path/to/a/thing',
#       python => '2.7.8'
#     }

define python::virtualenv(
  $ensure = present,
  $dir = undef,
  $env = {},
  $file = '.python-version',
  $python = undef,
  $user = $python::user
) {

  validate_absolute_path($dir)
  validate_hash($env)
  validate_re($ensure, '^(present|absent)$')
  validate_string($file, $user)

  include python::pyenv

  if $ensure == 'present' {
    validate_string($python)
    ensure_resource('python::version', $python)
  }

  $default_env = {
    'PYENV_ROOT' => $python::pyenv::prefix
  }

  $_env = merge($default_env, $env)

  virtualenv { $name:
    ensure      => $ensure,
    environment => $_env,
    provider    => pyenv,
    python      => $python,
    user        => $user,
  }

  file { "${dir}/${file}":
    ensure  => $ensure,
    content => "${name}\n",
    replace => true,
    require => Virtualenv[$name]
  }

}