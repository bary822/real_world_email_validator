# frozen_string_literal: true

require 'active_model'
require_relative '../lib/real_world_email_validator'

class MyCompany
  include ::ActiveModel::Model

  attr_accessor :email

  validates :email, real_world_email: true
end

RSpec.describe RealWorldEmailValidator do
  context 'when username' do
    subject { MyCompany.new(email: "#{username}@example.com") }

    context 'consists of only alphabetical characters' do
      let(:username) { 'username' }

      it { is_expected.to be_valid }
    end

    context 'consists of only digits' do
      let(:username) { '123456' }

      it { is_expected.to be_valid }
    end

    context 'consists of only printable characters' do
      let(:username) { "!#$%&'*+-/=?^_`{|}~" }

      it { is_expected.to be_valid }
    end

    context 'consists of alphabets, digits and printable chars' do
      let(:username) { "a!1#b$%&x'$*+w/2~" }

      it { is_expected.to be_valid }
    end

    context 'contains a dot surrounded by other allowed chars' do
      let(:username) { "a.a" }

      it { is_expected.to be_valid }
    end

    context 'contains consective dots' do
      let(:username) { "a..a" }

      it { is_expected.to be_invalid }
    end

    context 'contains consective dots, however whole username is quated' do
      let(:username) { '"a..a"' }

      it { is_expected.to be_valid }
    end

    context 'starts with .(dot)' do
      let(:username) { '.abc' }

      it { is_expected.to be_invalid }
    end

    context 'ends with .(dot)' do
      let(:username) { 'abc.' }

      it { is_expected.to be_invalid }
    end

    context 'contains whitespace' do
      let(:username) { 'ab c' }

      it { is_expected.to be_invalid }
    end

    context 'contains backslash' do
      let(:username) { 'ab\c' }

      it { is_expected.to be_invalid }
    end

    context 'contains comment' do
      let(:username) { 'abc(this_is_a_comment)' }

      it { is_expected.to be_invalid }
    end
  end

  context 'when domain' do
    subject { MyCompany.new(email: "john.smith@#{domain}") }

    context 'consists of only alphabetical characters in lowercase' do
      let(:domain) { 'example.com' }

      it { is_expected.to be_valid }
    end

    context 'consists of only alphabetical characters in uppercase' do
      let(:domain) { 'EXAMPLE.COM' }

      it { is_expected.to be_valid }
    end

    context 'consists of alphabetical characters mixed lowercase and uppercase' do
      let(:domain) { 'ExAmPlE.CoM' }

      it { is_expected.to be_valid }
    end

    context 'contains a digit' do
      let(:domain) { 'example1.com' }

      it { is_expected.to be_valid }
    end

    context 'contains a hyphen' do
      let(:domain) { 'example.co-m' }

      it { is_expected.to be_valid }
    end

    context 'has only digits in its top-level domain' do
      let(:domain) { 'example.12345' }

      it { is_expected.to be_invalid }
    end

    context 'has only digits in its non-top-level domain' do
      let(:domain) { '123.45.com' }

      it { is_expected.to be_valid }
    end

    context 'starts with hyphen' do
      let(:domain) { '-example.com' }

      it { is_expected.to be_invalid }
    end

    context 'ends with hyphen' do
      let(:domain) { 'example.com-' }

      it { is_expected.to be_invalid }
    end

    context 'contains comment' do
      let(:domain) { 'example(this_is_a_comment).com' }

      it { is_expected.to be_invalid }
    end

    context 'consists of only top-level domain' do
      let(:domain) { 'com' }

      it { is_expected.to be_invalid }
    end
  end

  context 'when given string is empty' do
    subject { MyCompany.new(email: "") }

    it { is_expected.to be_invalid }
  end
end
