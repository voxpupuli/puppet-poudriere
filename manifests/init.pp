# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].
#
# @param zpool The pool where poudriere will create all the filesystems
# @param zrootfs The root of the poudriere zfs filesystem
# @param freebsd_host The host where to download sets for the jails setup
# @param resolv_conf A file on your hosts system that will be copied has /etc/resolv.conf for the jail
# @param poudriere_base The directory where poudriere will store jails and ports
# @param poudriere_data The directory where the jail will store the packages and logs
# @param use_portlint Use portlint to check ports sanity
# @param mfssize Size of WRKDIRPREFIX when using mdmfs
# @param tmpfs Use tmpfs(5)
# @param tmpfs_limit How much memory to limit tmpfs size to for each builder in GiB
# @param max_memory How much memory to limit jail processes to for each builder
# @param max_files How many file descriptors to limit each jail process to
# @param distfiles_cache Directory used for the distfiles
# @param svn_host Mirror to use for the ports tree or source tree when using SVN
# @param check_changed_options Enable automatic OPTION change detection
# @param check_changed_deps Enable automatic dependency change detection
# @param bad_pkgname_deps_are_fatal Consider bad dependency lines on the wrong PKGNAME as fatal
# @param pkg_repo_signing_key Path to the RSA key to sign the PKG repo with
# @param ccache_enable Enable ccache
# @param ccache_dir Path to the ccache cache directory
# @param ccache_static_prefix Static ccache support from host
# @param restrict_networking The jails normally only allow network access during the 'make fetch' phase.
# @param allow_make_jobs_packages Allow networking for a subset of packages when building
# @param parallel_jobs Override the number of builders
# @param prepare_parallel_jobs How many jobs should be used for preparing the build
# @param save_wrkdir Save the WRKDIR to ${POUDRIERE_DATA}/wrkdirs on failure
# @param wrkdir_archive_format Format for the workdir packing
# @param nolinux Disable Linux support
# @param no_force_package Do not set FORCE_PACKAGE
# @param no_package_building Do not set PACKAGE_BUILDING
# @param http_proxy HTTP proxy
# @param ftp_proxy FTP proxy
# @param no_restricted Cleanout the restricted packages
# @param allow_make_jobs Do not bound the number of processes to the number of cores
# @param allow_make_jobs_packages List of packages that will always be allowed to use MAKE_JOBS regardless of ALLOW_MAKE_JOBS
# @param timestamp_logs Timestamp every line of build logs
# @param url_base URL where your POUDRIERE_DATA/logs are hosted
# @param max_execution_time Set the max time (in seconds) that a command may run for a build before it is killed for taking too long
# @param nohang_time Set the time (in seconds) before a command is considered to be in a runaway state for having no output on stdout
# @param atomic_package_repository Update the repository atomically
# @param commit_packages_on_failure When using ATOMIC_PACKAGE_REPOSITORY, commit the packages if some packages fail to build
# @param keep_old_packages Keep older package repositories
# @param keep_old_packages_count How many old package repositories to keep with KEEP_OLD_PACKAGES
# @param porttesting_fatal Make testing errors fatal
# @param builder_hostname Define the building jail hostname to be used when building the packages
# @param preserve_timestamp Define to get a predictable timestamp on the ports tree
# @param build_as_non_root Build and stage as a regular user
# @param portbuild_user Define to the username to build as when BUILD_AS_NON_ROOT is yes
# @param portbuild_uid Define to the uid to use for PORTBUILD_USER if the user does not already exist in the jail
# @param priority_boost Define pkgname globs to boost priority for
# @param buildname_format Define format for buildnames
# @param duration_format Define format for build duration times
# @param use_colors Use colors when in a TTY
# @param trim_orphaned_build_deps Only build what is requested
# @param local_mtree_excludes A list of directories to exclude from leftover and filesystem violation mtree checks
# @param html_type Set to hosted to use the /data directory instead of inline style HTML
# @param html_track_remaining Set to track remaining ports in the HTML interface
# @param environments Build environments to manage
# @param portstrees Port trees to manage
# @param xbuild_package Package to install for cross-building packages
class poudriere (
  Optional[String[1]]                $zpool                      = undef,
  Stdlib::Absolutepath               $zrootfs                    = '/poudriere',
  String[1]                          $freebsd_host               = 'http://ftp.freebsd.org/',
  Stdlib::Absolutepath               $resolv_conf                = '/etc/resolv.conf',
  Stdlib::Absolutepath               $poudriere_base             = '/usr/local/poudriere',
  String[1]                          $poudriere_data             = '${BASEFS}/data',
  Enum['yes', 'no']                  $use_portlint               = 'no',
  Optional[String[1]]                $mfssize                    = undef,
  Poudriere::Tmpfs                   $tmpfs                      = 'yes',
  Optional[Integer[1]]               $tmpfs_limit                = undef,
  Optional[Integer[1]]               $max_memory                 = undef,
  Optional[Integer[1]]               $max_files                  = undef,
  Stdlib::Absolutepath               $distfiles_cache            = '/usr/ports/distfiles',
  Optional[String[1]]                $svn_host                   = undef,
  Enum['yes', 'no', 'verbose']       $check_changed_options      = 'verbose',
  Enum['yes', 'no']                  $check_changed_deps         = 'yes',
  Optional[Enum['yes', 'no']]        $bad_pkgname_deps_are_fatal = undef,
  Optional[String[1]]                $pkg_repo_signing_key       = undef,
  Boolean                            $ccache_enable              = false,
  Stdlib::Absolutepath               $ccache_dir                 = '/var/cache/ccache',
  Optional[Stdlib::Absolutepath]     $ccache_static_prefix       = undef,
  Optional[Enum['yes', 'no']]        $restrict_networking        = undef,
  Optional[String[1]]                $allow_networking_packages  = undef,
  Integer[1]                         $parallel_jobs              = $facts['processors']['count'],
  Optional[Integer[1]]               $prepare_parallel_jobs      = undef,
  Optional[String[1]]                $save_wrkdir                = undef,
  Optional[String[1]]                $wrkdir_archive_format      = undef,
  Optional[String[1]]                $nolinux                    = undef,
  Optional[Enum['yes', 'no']]        $no_force_package           = undef,
  Optional[String[1]]                $no_package_building        = undef,
  Optional[String[1]]                $http_proxy                 = undef,
  Optional[String[1]]                $ftp_proxy                  = undef,
  Optional[String[1]]                $no_restricted              = undef,
  Optional[String[1]]                $allow_make_jobs            = undef,
  Optional[String[1]]                $allow_make_jobs_packages   = undef,
  Optional[Enum['yes', 'no']]        $timestamp_logs             = undef,
  Optional[String[1]]                $url_base                   = undef,
  Optional[Integer[1]]               $max_execution_time         = undef,
  Optional[Integer[1]]               $nohang_time                = undef,
  Optional[Enum['yes', 'no']]        $atomic_package_repository  = undef,
  Optional[Enum['yes', 'no']]        $commit_packages_on_failure = undef,
  Optional[Enum['yes', 'no']]        $keep_old_packages          = undef,
  Optional[Integer[1]]               $keep_old_packages_count    = undef,
  Optional[Enum['yes', 'no']]        $porttesting_fatal          = undef,
  Optional[String[1]]                $builder_hostname           = undef,
  Optional[Enum['yes', 'no']]        $preserve_timestamp         = undef,
  Optional[String[1]]                $build_as_non_root          = undef,
  Optional[String[1]]                $portbuild_user             = undef,
  Optional[Integer[1]]               $portbuild_uid              = undef,
  Optional[String[1]]                $priority_boost             = undef,
  Optional[String[1]]                $buildname_format           = undef,
  Optional[String[1]]                $duration_format            = undef,
  Optional[Enum['yes', 'no']]        $use_colors                 = undef,
  Optional[Enum['yes', 'no']]        $trim_orphaned_build_deps   = undef,
  Optional[String[1]]                $local_mtree_excludes       = undef,
  Optional[Enum['hosted', 'inline']] $html_type                  = undef,
  Optional[Enum['yes', 'no']]        $html_track_remaining       = undef,
  Hash                               $environments               = {},
  Hash                               $portstrees                 = {},
  String[1]                          $xbuild_package             = 'qemu-user-static',
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
