require 'spec_helper'

describe 'poudriere::env' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:title) { 'foo' }

      let(:facts) { facts }

      let(:pre_condition) { 'poudriere::portstree { "default": }' }

      let(:params) do
        {
          'version': '10.0-RELEASE',
        }
      end
      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_exec('poudriere-jail-foo').with(command: '/usr/local/bin/poudriere jail -c -j foo -v 10.0-RELEASE  -p default') }

      context 'with all parameters set' do
        let(:pre_condition) { 'poudriere::portstree { "wip": }' }

        let(:params) do
          {
            'version': '13.0-RELEASE',
            'ensure': 'present',
            'makeopts': makeopts,
            'makefile': makefile,
            'arch': 'amd64',
            'jail': 'test',
            'paralleljobs': 42,
            'pkgs': [
              'sysutils/puppet6',
              'sysutils/puppet7',
            ],
            'pkg_makeopts': pkg_makeopts,
            'pkg_optsdir': '/usr/local/etc/poudriere.d/optdir',
            'portstree': 'wip',
            'cron_enable': true,
            'cron_always_mail': true,
            'cron_interval': {
              'minute': 42,
              'hour': 7,
              'monthday': '*',
              'month': '*',
              'weekday': '*',
            },
          }
        end

        let(:makefile) { :undef }
        let(:makeopts) do
          [
            'OPTIONS_SET+=PULSEAUDIO',
            'OPTIONS_UNSET+=EXAMPLES DOCS',
          ]
        end
        let(:pkg_makeopts) do
          {
            'sysutils/puppet6': [
              'OPTIONS_SET+=RFACTER',
              'OPTIONS_UNSET+=CFACTER',
            ],
          }
        end

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_file('/usr/local/etc/poudriere.d/test-make.conf').with(content: <<~CONF, source: nil) }
          # makeopts
          OPTIONS_SET+=PULSEAUDIO
          OPTIONS_UNSET+=EXAMPLES DOCS

          # pkg_makeopts for sysutils/puppet6
          .if ${.CURDIR}=="/usr/ports/sysutils/puppet6"
          OPTIONS_SET+=RFACTER
          OPTIONS_UNSET+=CFACTER
          .endif


          CONF

        context 'with a makefile' do
          let(:makefile) { 'puppet:///moduldes/profile/poudriere/default-make.conf' }
          let(:makeopts) { [] }
          let(:pkg_makeopts) { {} }

          it { is_expected.to compile.with_all_deps }
          it { is_expected.to contain_file('/usr/local/etc/poudriere.d/test-make.conf').with(content: nil, source: 'puppet:///moduldes/profile/poudriere/default-make.conf') }
        end


        context 'with a makefile, makeopts and pkg_makeopts' do
          let(:makefile) { 'puppet:///moduldes/profile/poudriere/default-make.conf' }

          it { is_expected.to compile.and_raise_error(/\$makefile cannot be combined with \$makeopts and \$pkg_makeopts/) }
        end
      end

      context 'with a custom architecture' do
        context 'when targeting armv7' do
          let(:params) do
            {
              'arch': 'arm.armv7',
              'version': '10.0-RELEASE',
            }
          end

          it { is_expected.to contain_exec('poudriere-jail-foo').with(command: '/usr/local/bin/poudriere jail -c -j foo -v 10.0-RELEASE -a arm.armv7 -p default') }
          it { is_expected.to contain_class('poudriere::xbuild') }
        end

        context 'when targeting i386' do
          let(:params) do
            {
              'arch': 'i386',
              'version': '10.0-RELEASE',
            }
          end

          it { is_expected.not_to contain_class('poudriere::xbuild') }
        end
      end
    end
  end
end
