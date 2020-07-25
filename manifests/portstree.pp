# This resource creates a ports tree. You can have multiple ports trees for different
# building purposes. Automatic periodic updating of packages is managed with the cron_enable
# parameter

define poudriere::portstree (
  $ensure           = 'present',
  $portstree        = $name,
  $branch           = undef,
  $fetch_method     = 'svn',
  $cron_enable      = false,
  $cron_always_mail = false,
  $cron_interval    = { minute => 0, hour => 22, monthday => '*', month => '*', week => '*' },
) {
  include poudriere

  $cron_present = $ensure ? {
    'absent' => 'absent',
    default => $cron_enable ? {
      true => 'present',
      default => 'absent',
    },
  }

  # Manage portstree
  if $ensure != 'absent' {
    if $branch != undef {
      $branch_option = "-B ${branch}"
    }
    else {
      $branch_option = ''
    }
    exec { "poudriere-portstree-${portstree}":
      command => "/usr/local/bin/poudriere ports -c -p ${portstree} -m ${fetch_method} ${branch_option}",
      creates => "${poudriere::poudriere_base}/ports/${portstree}",
      timeout => 3600,
      require => File['/usr/local/etc/poudriere.conf'],
    }
  } else {
    exec { "poudriere-portstree-${portstree}":
      command => "/usr/local/bin/poudriere ports -d -p ${portstree}",
      onlyif  => "/usr/local/bin/poudriere ports -l | /usr/bin/grep -w '^${portstree}'",
    }
  }
  if $cron_always_mail {
    $cron_command="poudriere ports -u -p ${portstree}"
  } else {
    $cron_command="OUTPUT=\$(poudriere ports -u -p ${portstree}) || echo \${OUTPUT}"
  }
  # Update ports tree periodically
  cron { "poudriere-portstree-${portstree}":
    ensure   => $cron_present,
    command  => $cron_command,
    user     => 'root',
    minute   => $cron_interval['minute'],
    hour     => $cron_interval['hour'],
    monthday => $cron_interval['monthday'],
    month    => $cron_interval['month'],
    weekday  => $cron_interval['weekday'],
    require  => Exec["poudriere-portstree-${portstree}"],
  }
}
