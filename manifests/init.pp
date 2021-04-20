# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].
#
# @param zpool The pool where poudriere will create all the filesystems
# @param zrootfs The root of the poudriere zfs filesystem
# @param freebsd_host The host where to download sets for the jails setup
# @param resolv_conf A file on your hosts system that will be copied has /etc/resolv.conf for the jail
# @param ccache_enable Enable ccache
# @param ccache_dir Path to the ccache cache directory
# @param poudriere_base The directory where poudriere will store jails and ports
# @param poudriere_data The directory where the jail will store the packages and logs
# @param use_portlint Use portlint to check ports sanity
# @param mfssize Size of WRKDIRPREFIX when using mdmfs
# @param tmpfs Use tmpfs(5)
# @param distfiles_cache Directory used for the distfiles
# @param csup_host Mirror to use for the ports tree or source tree when using CVS
# @param svn_host Mirror to use for the ports tree or source tree when using SVN
# @param check_changed_options Enable automatic OPTION change detection
# @param check_changed_deps Enable automatic dependency change detection
# @param pkg_repo_signing_key Path to the RSA key to sign the PKG repo with
# @param parallel_jobs Override the number of builders
# @param save_wrkdir Save the WRKDIR to ${POUDRIERE_DATA}/wrkdirs on failure
# @param wrkdir_archive_format Format for the workdir packing
# @param nolinux Disable Linux support
# @param no_package_building Do not set PACKAGE_BUILDING
# @param no_restricted Cleanout the restricted packages
# @param allow_make_jobs Do not bound the number of processes to the number of cores
# @param url_base URL where your POUDRIERE_DATA/logs are hosted
# @param max_execution_time Set the max time (in seconds) that a command may run for a build before it is killed for taking too long
# @param nohang_time Set the time (in seconds) before a command is considered to be in a runaway state for having no output on stdout
# @param http_proxy HTTP proxy
# @param ftp_proxy FTP proxy
# @param build_as_non_root Build and stage as a regular user
# @param environments Build environments to manage
# @param portstrees Port trees to manage
# @param xbuild_package Package to install for cross-building packages
class poudriere (
  String                       $zpool                 = 'tank',
  Stdlib::Absolutepath         $zrootfs               = '/poudriere',
  String                       $freebsd_host          = 'http://ftp6.us.freebsd.org/',
  Stdlib::Absolutepath         $resolv_conf           = '/etc/resolv.conf',
  Boolean                      $ccache_enable         = false,
  Stdlib::Absolutepath         $ccache_dir            = '/var/cache/ccache',
  Stdlib::Absolutepath         $poudriere_base        = '/usr/local/poudriere',
  String                       $poudriere_data        = '${BASEFS}/data',
  Enum['yes', 'no']            $use_portlint          = 'no',
  Optional[String]             $mfssize               = undef,
  Enum['yes', 'no']            $tmpfs                 = 'yes',
  Stdlib::Absolutepath         $distfiles_cache       = '/usr/ports/distfiles',
  Optional[String]             $csup_host             = undef,
  Optional[String]             $svn_host              = undef,
  Enum['yes', 'no', 'verbose'] $check_changed_options = 'verbose',
  Enum['yes', 'no']            $check_changed_deps    = 'yes',
  String                       $pkg_repo_signing_key  = '',
  Integer[1]                   $parallel_jobs         = $facts['processors']['count'],
  String                       $save_wrkdir           = '',
  String                       $wrkdir_archive_format = '',
  String                       $nolinux               = '',
  String                       $no_package_building   = '',
  String                       $no_restricted         = '',
  String                       $allow_make_jobs       = '',
  String                       $url_base              = '',
  String                       $max_execution_time    = '',
  String                       $nohang_time           = '',
  String                       $http_proxy            = '',
  String                       $ftp_proxy             = '',
  String                       $build_as_non_root     = '',
  Hash                         $environments          = {},
  Hash                         $portstrees            = {},
  String[1]                    $xbuild_package        = 'qemu-user-static',
) {
  Exec {
    path => '/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin',
  }

  # Install poudriere and dialog4ports
  # make -C /usr/ports/ports-mgmt/poudriere install clean
  package { ['poudriere', 'dialog4ports']:
    ensure => installed,
  }

  file { '/usr/local/etc/poudriere.conf':
    content => template('poudriere/poudriere.conf.erb'),
    require => Package['poudriere'],
  }

  file { '/usr/local/etc/poudriere.d':
    ensure  => directory,
  }

  file { $distfiles_cache:
    ensure => directory,
  }

  if $ccache_enable {
    file { $ccache_dir:
      ensure => directory,
    }
  }

  cron { 'poudriere-update-ports':
    ensure   => 'absent',
  }

  # Create environments
  create_resources('poudriere::env', $environments)

  # Create portstrees
  create_resources('poudriere::portstree', $portstrees)
}
