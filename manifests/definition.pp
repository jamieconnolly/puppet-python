# Public: Install a custom python-build definition.
#
# Options:
#
#     source =>
#       The puppet:/// source to install from.
#       Defaults to "puppet:///modules/python/definitions/${name}".
#
# Usage:
#
#     python::definition { '2.7.8-github1': }

define python::definition(
  $source = undef
) {

  include python::pyenv

  $source_path = $source ? {
    undef   => "puppet:///modules/python/definitions/${name}",
    default => $source
  }

  file { "${python::pyenv::prefix}/plugins/python-build/share/python-build/${name}":
    source => $source_path
  }

}
