# This resource creates a ports tree. You can have multiple ports trees for different
# building purposes. Automatic periodic updating of packages is managed with the cron_enable
# parameter

define poudriere::portstree (
  $ensure        = 'present',
  $portstree     = $name,
  $fetch_method  = 'svn',
  $cron_enable   = false,
  $cron_interval = {minute => 0, hour => 22, monthday => '*', month => '*', week => '*'},
) {

  include ::poudriere

  $cron_present = $ensure ? {
    'absent' => 'absent',
    default => $cron_enable ? {
      true => 'present',
      default => 'absent',
    },
  }

  # Manage portstree
  if $ensure != 'absent' {
    exec { "poudriere-portstree-${portstree}":
      command => "/usr/local/bin/poudriere ports -c -p ${portstree} -m ${fetch_method}",
      require => File['/usr/local/etc/poudriere.conf'],
      creates => "${poudriere::poudriere_base}/ports/${portstree}",
      timeout => 3600,
    }
  } else {
    exec { "poudriere-portstree-${portstree}":
      command => "/usr/local/bin/poudriere ports -d -p ${portstree}",
      onlyif  => "/usr/local/bin/poudriere ports -l | grep -w '^${portstree}'",
    }
  }

  # Update ports tree periodically
  cron { "poudriere-portstree-${portstree}":
    ensure   => $cron_present,
    command  => "PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin poudriere ports -u -p ${portstree}",
    user     => 'root',
    minute   => $cron_interval['minute'],
    hour     => $cron_interval['hour'],
    monthday => $cron_interval['monthday'],
    month    => $cron_interval['month'],
    weekday  => $cron_interval['weekday'],
    require  => Exec["poudriere-portstree-${portstree}"],
  }
}
