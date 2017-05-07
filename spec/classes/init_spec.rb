require 'spec_helper'

describe 'poudriere' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(concat_basedir: '/dne') }
      it { is_expected.to compile }
    end
  end
end
