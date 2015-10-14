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
    $_require = Python::Version[$version]
  } else {
    $_require = undef
  }

  validate_absolute_path($name)

  $local_file = hiera('python::local::file', '.python-version')

  file { "${name}/${local_file}":
    ensure  => $ensure,
    content => "${version}\n",
    replace => true,
    require => $_require
  }

}
