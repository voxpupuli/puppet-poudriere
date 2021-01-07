# @summary Install cross-building dependencies
class poudriere::xbuild {
  include poudriere

  package { $poudriere::xbuild_package:
    ensure => installed,
  }

  service { 'qemu_user_static':
    ensure => 'running',
    enable => true,
    status => '/usr/sbin/binmiscctl lookup arm',
  }
}
