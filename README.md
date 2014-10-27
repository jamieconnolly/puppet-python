# Python Puppet Module for Boxen

[![Build Status](https://travis-ci.org/boxen/puppet-python.png?branch=master)](https://travis-ci.org/boxen/puppet-python)

## Usage

```puppet
# Set the global default python (auto-installs it if it can)
class { 'python::global':
  version => '2.7.8'
}

# ensure a certain python version is used in a dir
python::local { '/path/to/some/project':
  version => '2.7.8'
}

# install a python version
python::version { '2.7.8': }

# Installing pyenv plugin
python::pyenv::plugin { 'update':
  ensure => present,
  source => 'yyuu/pyenv-update'
}
```

## Hiera configuration

The following variables may be automatically overridden with Hiera:

``` yaml
---
"python::user": "deploy"

"python::pyenv::ensure": "v20140825"

# Pyenv plugins to install by default
"python::pyenv::plugins":
  "pyenv-virtualenv":
    "ensure": "present"
    "source": "yyuu/pyenv-virtualenv"

# Environment variables for building specific versions
# You'll want to enable hiera's "deeper" merge strategy
# See http://docs.puppetlabs.com/hiera/1/configuring.html#mergebehavior
"python::version::env":
  "2.7.8":
    "CFLAGS": "-I/opt/X11/include"

# Version aliases, commonly used to bless a specific version
# Use the "deeper" merge strategy, as with python::version::env
"python::version::alias":
  "2.7": "2.7.8"
```

## Required Puppet Modules

* `boxen`, >= 3.1
* `homebrew`, >= 1.1
* `module-data`
* `repository`, >= 2.2
* `stdlib`, >= 4.0

## Optional Puppet Modules

* `java`, >= 1.2 (jython only)
* `xquartz`, >= 1.1 (OS X only)
