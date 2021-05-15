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
