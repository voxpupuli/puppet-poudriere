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
    end
  end
end
