# Poudriere is a tool that lets you build PkgNG packages from ports.  This is
# cool because it gives you the flexibility of custom port options with all the
# awesomeness of packages.  The below class prepares the build environment.
# For the configuration of the build environment, see Class[poudriere::env].
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
