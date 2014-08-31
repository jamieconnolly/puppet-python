# Public: Install a Python version via pyenv.
#
# Usage:
#
#     python::version { '2.7.8': }

define python::version(
  $ensure  = present,
  $version = $name
) {

}
