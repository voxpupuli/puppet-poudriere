# This define creates a build environment for a given release and archetecture
# of FreeBSD.  Passing in custom options gives you the bility to turn on and
# off certain features of your ports.  Anything that can build put in
# make.conf, you can put here as well.

# NOTE: This does not actually build the packages.  For that, you will want to
# read the documentation.

define poudriere::env (
  $makeopts     = ["WITH_PKGNG=yes"],
  $version      = '9.1-RELEASE',
  $arch         = "amd64",
  $jail         = '91amd64',
  $pkgs         = [],
  $pkg_makeopts = []
) {

  # Make sure we are prepared to run
  include poudriere

  # Create the environment
  exec { "create ${jail} jail":
    command => "/usr/local/bin/poudriere jail -c -j ${jail} -v ${version} -a ${arch}",
    require => Exec["create default ports tree"],
    creates => "${poudriere::poudriere_base}/jails/${jail}/",
    timeout => '3600',
  }

  # Lay down the configuration
  file { "/usr/local/etc/poudriere.d/${jail}-make.conf":
    content => template('poudriere/make.conf.erb'),
    require => File["/usr/local/etc/poudriere.d"],
  }

  if $pkgs != [] {
    file { "/usr/local/etc/poudriere.${jail}.list":
      content => inline_template("<%= (@pkgs.join('\n'))+\"\n\" %>"),
      require => File["/usr/local/etc/poudriere.d"],
    }
  }
}
