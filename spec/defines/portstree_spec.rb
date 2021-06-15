require 'spec_helper'

describe 'poudriere::portstree' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:title) { 'foo' }

      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      describe 'with local ports' do
        let(:params) do
          {
            fetch_method: 'null',
            mountpoint: '/home/romain/FreeBSD/ports',
          }
        end

        it { is_expected.to contain_exec('poudriere-portstree-foo').with(command: '/usr/local/bin/poudriere ports -c -p foo -m null  -M /home/romain/FreeBSD/ports') }
      end
    end
  end
end
