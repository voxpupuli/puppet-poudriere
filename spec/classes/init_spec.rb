# frozen_string_literal: true

require 'spec_helper'

describe 'poudriere' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(concat_basedir: '/dne') }

      it { is_expected.to compile }
      it { is_expected.to contain_class('poudriere') }
      it { is_expected.to contain_package('poudriere') }
      it { is_expected.to contain_package('dialog4ports') }
      it { is_expected.to contain_file('/usr/ports/distfiles') }
      it { is_expected.to contain_file('/usr/local/etc/poudriere.d') }
      it { is_expected.to contain_file('/usr/local/etc/poudriere.conf') }

      context 'with all configuration parameters set' do
        let(:params) do
          {
            'zpool'                          => 'tank',
            'zrootfs'                        => '/pdata',
            'freebsd_host'                   => 'https://download.FreeBSD.org',
            'resolv_conf'                    => '/jails/resolv.conf',
            'poudriere_base'                 => '/opt/poudriere',
            'poudriere_data'                 => '/data',
            'use_portlint'                   => 'yes',
            'tmpfs'                          => %w[
              data
              wrkdir
            ],
            'tmpfs_limit'                    => 8,
            'tmpfs_blacklist'                => ['gcc*', 'rust', 'llvm*'],
            'tmpfs_blacklist_tmpdir'         => '${BASEFS}/data/cache/tmp',
            'max_memory'                     => 8,
            'max_memory_per_package'         => {
              'rust' => 20,
            },
            'max_files'                      => 1024,
            'distfiles_cache'                => '/var/cache/distfiles',
            'git_baseurl'                    => 'https://github.com/freebsd/freebsd-src.git',
            'git_portsurl'                   => 'https://github.com/freebsd/freebsd-ports.git',
            'svn_host'                       => 'svnmirror.lan',
            'check_changed_options'          => 'verbose',
            'check_changed_deps'             => 'no',
            'bad_pkgname_deps_are_fatal'     => 'yes',
            'pkg_repo_signing_key'           => '/etc/ssl/keys/repo.key',
            'signing_command'                => 'ssh signing-server sign.sh',
            'pkg_repo_from_host'             => 'yes',
            'ccache_enable'                  => true,
            'ccache_dir'                     => '/var/cache/ccache',
            'ccache_static_prefix'           => '/usr/local',
            'restrict_networking'            => 'no',
            'allow_networking_packages'      => 'npm-foo npm-bar',
            'disallow_networking'            => 'yes',
            'parallel_jobs'                  => 42,
            'prepare_parallel_jobs'          => 7,
            'save_wrkdir'                    => 'yes',
            'wrkdir_archive_format'          => 'txz',
            'nolinux'                        => 'yes',
            'no_force_package'               => 'yes',
            'no_package_building'            => 'yes',
            'http_proxy'                     => 'http://10.0.0.1',
            'ftp_proxy'                      => 'ftp://10.0.0.2',
            'no_restricted'                  => 'yes',
            'allow_make_jobs'                => 'yes',
            'allow_make_jobs_packages'       => 'pkg ccache py*',
            'timestamp_logs'                 => 'no',
            'max_execution_time'             => 86_400,
            'nohang_time'                    => 7200,
            'atomic_package_repository'      => 'yes',
            'commit_packages_on_failure'     => 'yes',
            'keep_old_packages'              => 'yes',
            'keep_old_packages_count'        => 5,
            'porttesting_fatal'              => 'yes',
            'builder_hostname'               => 'pkg.FreeBSD.org',
            'preserve_timestamp'             => 'yes',
            'build_as_non_root'              => 'yes',
            'portbuild_user'                 => 'nobody',
            'portbuild_group'                => 'nobody',
            'portbuild_uid'                  => 65_534,
            'portbuild_gid'                  => 65_534,
            'priority_boost'                 => 'pypy openoffice',
            'buildname_format'               => '%FT%TZ',
            'duration_format'                => '%H:%M:%S',
            'use_colors'                     => 'yes',
            'trim_orphaned_build_deps'       => 'yes',
            'delete_unknown_files'           => 'yes',
            'delete_unqueued_packages'       => 'always',
            'url_base'                       => 'http://example.com/poudriere/',
            'local_mtree_excludes'           => '/usr/obj /var/tmp/ccache',
            'html_type'                      => 'hosted',
            'html_track_remaining'           => 'yes',
            'determine_build_failure_reason' => 'yes',
            'makeworldargs'                  => 'WITHOUT_LLVM_ASSERTIONS=yes WITH_MALLOC_PRODUCTION=yes -DMALLOC_PRODUCTION',
            'package_fetch_branch'           => 'latest',
            'package_fetch_url'              => 'pkg+http://pkg.FreeBSD.org/\\${ABI}',
            'package_fetch_blacklist'        => [],
            'package_fetch_whitelist'        => ['gcc*', 'rust', 'llvm*'],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^ZPOOL=tank$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^ZROOTFS=/pdata$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^FREEBSD_HOST=https://download\.FreeBSD\.org$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^RESOLV_CONF=/jails/resolv\.conf$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^BASEFS=/opt/poudriere$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^POUDRIERE_DATA=/data$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^USE_PORTLINT=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^USE_TMPFS="data wrkdir"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^TMPFS_LIMIT=8$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^TMPFS_BLACKLIST="gcc\* rust llvm\*"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r(^TMPFS_BLACKLIST_TMPDIR=\${BASEFS}/data/cache/tmp$)) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^MAX_MEMORY=8$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^MAX_MEMORY_rust=20$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^MAX_FILES=1024$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^DISTFILES_CACHE=/var/cache/distfiles$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^GIT_BASEURL=https://github\.com/freebsd/freebsd-src\.git$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^GIT_PORTSURL=https://github\.com/freebsd/freebsd-ports\.git$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^SVN_HOST=svnmirror\.lan$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^CHECK_CHANGED_OPTIONS=verbose$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^CHECK_CHANGED_DEPS=no$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^BAD_PKGNAME_DEPS_ARE_FATAL=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PKG_REPO_SIGNING_KEY=/etc/ssl/keys/repo\.key$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^SIGNING_COMMAND="ssh signing-server sign\.sh"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PKG_REPO_FROM_HOST=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^CCACHE_DIR=/var/cache/ccache$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^CCACHE_STATIC_PREFIX=/usr/local$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^RESTRICT_NETWORKING=no$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^ALLOW_NETWORKING_PACKAGES="npm-foo npm-bar"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^DISALLOW_NETWORKING=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PARALLEL_JOBS=42$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PREPARE_PARALLEL_JOBS=7$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^SAVE_WRKDIR=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^WRKDIR_ARCHIVE_FORMAT=txz$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^NOLINUX=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^NO_FORCE_PACKAGE=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^NO_PACKAGE_BUILDING=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^export HTTP_PROXY=http://10\.0\.0\.1$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^export FTP_PROXY=ftp://10\.0\.0\.2$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^NO_RESTRICTED=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^ALLOW_MAKE_JOBS=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^ALLOW_MAKE_JOBS_PACKAGES="pkg ccache py\*"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^TIMESTAMP_LOGS=no$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^MAX_EXECUTION_TIME=86400$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^NOHANG_TIME=7200$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^ATOMIC_PACKAGE_REPOSITORY=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^COMMIT_PACKAGES_ON_FAILURE=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^KEEP_OLD_PACKAGES=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^KEEP_OLD_PACKAGES_COUNT=5$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PORTTESTING_FATAL=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^BUILDER_HOSTNAME=pkg\.FreeBSD\.org$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PRESERVE_TIMESTAMP=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^BUILD_AS_NON_ROOT=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PORTBUILD_USER=nobody$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PORTBUILD_GROUP=nobody$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PORTBUILD_UID=65534$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PORTBUILD_GID=65534$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PRIORITY_BOOST=pypy openoffice$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^BUILDNAME_FORMAT=%FT%TZ$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^DURATION_FORMAT=%H:%M:%S$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^USE_COLORS=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^TRIM_ORPHANED_BUILD_DEPS=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^DELETE_UNKNOWN_FILES=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^DELETE_UNQUEUED_PACKAGES=always$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^LOCAL_MTREE_EXCLUDES="/usr/obj /var/tmp/ccache"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^URL_BASE=http://example\.com/poudriere/$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^HTML_TYPE=hosted$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^HTML_TRACK_REMAINING=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^DETERMINE_BUILD_FAILURE_REASON=yes$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^MAKEWORLDARGS="WITHOUT_LLVM_ASSERTIONS=yes WITH_MALLOC_PRODUCTION=yes -DMALLOC_PRODUCTION"$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PACKAGE_FETCH_BRANCH=latest$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PACKAGE_FETCH_URL=pkg\+http://pkg.FreeBSD.org/\\\${ABI}$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PACKAGE_FETCH_BLACKLIST=""$}) }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.conf').with(content: %r{^PACKAGE_FETCH_WHITELIST="gcc\* rust llvm\*"$}) }
      end
    end
  end
end
