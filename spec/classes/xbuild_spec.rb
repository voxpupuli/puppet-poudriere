# frozen_string_literal: true

require 'spec_helper'

describe 'poudriere::xbuild' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile }
      it { is_expected.to contain_package('qemu-user-static') }
      it { is_expected.to contain_service('qemu_user_static') }
    end
  end
end
