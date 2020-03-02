# awsmeta [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) <a href="https://codeclimate.com/github/haydenmcfarland/awsmeta/maintainability"><img src="https://api.codeclimate.com/v1/badges/adfb8333557241e81a02/maintainability" /></a>

AWS metadata reader for EC2 instances

# How to use

Add `awsmeta` to your gem file:

```ruby
gem 'awsmeta', git: 'https://github.com/haydenmcfarland/awsmeta'
```

Run `bundle install`

# Example usage

```ruby
Awsmeta.credentials

{
  :code=>"Success",
  :last_updated=>"2020-03-02T03:04:00Z",
  :type=>"AWS-HMAC",
  :access_key_id=>"***",
  :secret_access_key=>"***",
  :token=>"***",
  :expiration=>"2020-03-02T09:39:04Z"
}
```

```ruby
Awsmeta.document

{
  :account_id=>"***",
  :architecture=>"x86_64",
  :availability_zone=>"us-west-2a",
  :billing_products=>nil,
  :devpay_product_codes=>nil,
  :marketplace_product_codes=>nil,
  :image_id=>"ami-***",
  :instance_id=>"i-***",
  :instance_type=>"t2.micro",
  :kernel_id=>nil,
  :pending_time=>"2020-03-02T02:58:35Z",
  :private_ip=>"*.*.*.*",
  :ramdisk_id=>nil,
  :region=>"us-west-2",
  :version=>"2017-09-30"
}
```

```ruby
Awsmeta.instance_id
"i-***"
```

```ruby
Awsmeta.role
"ec2role"
```

If a role is not defined, the `credential` and `role` calls will raise
an `A`wsmeta::Errors::ResourceNotFound` error.

```ruby
Awsmeta.role
Awsmeta::Errors::ResourceNotFound (Not Found)
```
