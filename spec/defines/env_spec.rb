require 'spec_helper'

describe 'poudriere::env' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:title) { 'foo' }

      let(:facts) { facts }

      let(:pre_condition) { 'poudriere::portstree { "default": }' }

      it { is_expected.to compile.with_all_deps }
    end
  end
end
