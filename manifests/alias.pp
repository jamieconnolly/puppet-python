# Public: Alias a (usually shorter) python version to another
#
# Usage:
#
#     python::alias { '2.7': to => '2.7.8' }

define python::alias(
  $ensure = present,
  $to = undef,
  $version = $name
) {

  require python

  if $to == undef {
    fail('to cannot be undefined')
  }

  if $ensure != 'absent' {
    ensure_resource('python::version', $to)
  }

  $file_ensure = $ensure ? {
    present => symlink,
    default => $ensure
  }

  file { "/opt/python/${version}":
    ensure  => $file_ensure,
    force   => true,
    target  => "/opt/python/${to}",
    require => Python::Version[$to]
  }

}
