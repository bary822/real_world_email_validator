# frozen_string_literal: true

require 'active_model/validator'

# Email address validator based on RFC 5322, plus own flavors that real world needs
# ref: https://tools.ietf.org/html/rfc5322#section-3.4.1
class RealWorldEmailValidator < ActiveModel::EachValidator
  module StringExt
    refine String do
      def start_and_end_with?(chars)
        self.start_with?(chars) && self.end_with?(chars)
      end

      def start_or_end_with?(chars)
        self.start_with?(chars) || self.end_with?(chars)
      end
    end
  end

  using RealWorldEmailValidator::StringExt

  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add attribute, :invalid
      return
    end

    username, domain = value.split('@')

    unless domain.present? && username_valid?(username) && domain_valid?(domain)
      record.errors.add attribute, :invalid
    end
  end

  private

  # Local-part A.K.A username format definition based on RFC 5322.
  # Any of following characters are allowed basically:
  # - Uppercase and lowercase alphabetical letters
  # - Digits 0 to 9
  # - Printable characters other than letters and digits !#$%&'*+-/=?^_`{|}~
  # - .(dot)
  # However, a .(dot) MUST be surrounded by other allowed characters unless whole username is quoted.
  # e.g.
  # John.Doe@example.com => OK
  # John..Doe@example.com => NG
  # "John..Doe"@example.com => OK
  #
  # And we add following validations as own flavor:
  # - Whitespace is not allowed
  # - Backslash is not allowed
  # - Comment, allowed characters surrounded by '(' and ')' is not allowed
  def username_valid?(username)
    regex = %r{\A"?([a-zA-Z]|[0-9]|[!#$%&'*+-/=?^_`{|}~]|[.])+"?\z}
    result = username.match?(regex)

    return result if username.start_and_end_with?('"')
    return false if username.start_or_end_with?('.') || username.include?('..')
    result
  end

  # Domain format definition based on RFC 5322.
  # It must match the requirements for a hostname, which you can imagine of DNS.
  # It is limited to a length of 63 characters.
  # Any of following characters are allowed:
  # - Uppercase and lowercase alphabetical letters
  # - Digits 0 to 9, however, top-level domain MUST NOT all-numeric
  # - Hyphen(-), however, it MUST not be the first or last character of the each domain
  # And we add following validation as own flavor:
  # - Comment, allowed characters surrounded by '(' and ')' is not allowed
  # - It MUST contain domains other than top-level
  def domain_valid?(domain_str)
    return false if domain_str.length > 63

    domains = domain_str.split('.')
    top_level = domains[-1]
    subdomains = domains - [top_level]

    top_level_domain_valid?(top_level) && subdomains_valid?(subdomains)
  end

  def top_level_domain_valid?(top_level_domain)
    return false if top_level_domain.start_or_end_with?('-')
    return false if top_level_domain.match?(/\A([0-9])+\z/)

    top_level_domain.match?(/\A([a-zA-Z]|[0-9]|[-])+\z/)
  end

  def subdomains_valid?(subdomains)
    return false if subdomains.empty?

    subdomains.all? do |subdomain|
      !subdomain.start_or_end_with?('-') && subdomain.match?(/\A([a-zA-Z]|[0-9]|[-])+\z/)
    end
  end
end
