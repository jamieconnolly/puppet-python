# Public: Make sure a certain Python version is installed and configured
# to be used in a certain directory.
#
# Usage:
#
#     python::local { '/path/to/a/thing': version => '2.7.8' }

define python::local(
  $ensure = present,
  $version = undef
) {

  validate_re($ensure, '^(present|absent)$')

  if $version != 'system' {
    ensure_resource('python::version', $version)
    $require = Python::Version[$version]
  } else {
    $require = undef
  }

  validate_absolute_path($name)

  file { "${name}/.python-version":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true,
    require => $require
  }

}
