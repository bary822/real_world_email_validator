[![Build Status](https://travis-ci.com/bary822/real_world_email_validator.svg?branch=master)](https://travis-ci.com/bary822/real_world_email_validator)

# real_world_email_validator
Email address validator that real world needs, for ActiveModel 3+.

Validating email address is hard. Its format definition varies on all kinds of systems depending on its generation, thus, hard.
This validator does the job based on [RFC 5322](https://tools.ietf.org/html/rfc5322#section-3.4.1), but not exactly.
It does few additional validations to make sure the email address works well on almost all kinds of systems, regardless its generations.

Read more about this on [wikipedia](https://en.wikipedia.org/wiki/Non-Internet_email_address).

# Requirements
- Ruby 2.4+
- ActiveModel 3+

# Intall
`gem install real_world_email_validator`

or if you use bundler:

`bundle add real_world_email_validator`

# Usage
```ruby
class MyCompany
  include ::ActiveModel::Model

  attr_accessor :email

  validates :email, real_world_email: true
end

my_company = MyCompany.new

my_company.email = 'foo@example.com'
my_company.valid?
=> true

my_company.email = 'fo o@example.com'
my_company.valid?
=> false
```
