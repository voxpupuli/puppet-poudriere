# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].
class poudriere (
  Optional[String[1]]          $zpool                 = undef,
  Stdlib::Absolutepath         $zrootfs               = '/poudriere',
  String[1]                    $freebsd_host          = 'http://ftp6.us.freebsd.org/',
  Stdlib::Absolutepath         $resolv_conf           = '/etc/resolv.conf',
  Boolean                      $ccache_enable         = false,
  Stdlib::Absolutepath         $ccache_dir            = '/var/cache/ccache',
  Stdlib::Absolutepath         $poudriere_base        = '/usr/local/poudriere',
  String[1]                    $poudriere_data        = '${BASEFS}/data',
  Enum['yes', 'no']            $use_portlint          = 'no',
  Optional[String[1]]          $mfssize               = undef,
  Enum['yes', 'no']            $tmpfs                 = 'yes',
  Stdlib::Absolutepath         $distfiles_cache       = '/usr/ports/distfiles',
  Optional[String[1]]          $csup_host             = undef,
  Optional[String[1]]          $svn_host              = undef,
  Enum['yes', 'no', 'verbose'] $check_changed_options = 'verbose',
  Enum['yes', 'no']            $check_changed_deps    = 'yes',
  Optional[String[1]]          $pkg_repo_signing_key  = undef,
  Integer[1]                   $parallel_jobs         = $facts['processors']['count'],
  Optional[String[1]]          $save_wrkdir           = undef,
  Optional[String[1]]          $wrkdir_archive_format = undef,
  Optional[String[1]]          $nolinux               = undef,
  Optional[String[1]]          $no_package_building   = undef,
  Optional[String[1]]          $no_restricted         = undef,
  Optional[String[1]]          $allow_make_jobs       = undef,
  Optional[String[1]]          $url_base              = undef,
  Optional[String[1]]          $max_execution_time    = undef,
  Optional[String[1]]          $nohang_time           = undef,
  Optional[String[1]]          $http_proxy            = undef,
  Optional[String[1]]          $ftp_proxy             = undef,
  Optional[String[1]]          $build_as_non_root     = undef,
  Hash                         $environments          = {},
  Hash                         $portstrees            = {},
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
