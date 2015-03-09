# Krackle

CLI for querying and flattening YAML data.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'krackle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install krackle

## Usage

You have a YAML file and want to pull a key or many out:

```yaml
first_name: Brad
last_name: Gessler
location:
  state: CA
  city: San Francisco
  tax_brackets:
    - high
    - really high
    - my eyes are bleeding high
projects:
  - name: Firehose.io
    url: https://github.com/firehose/gem
    contributors:
      - Brad Gessler
      - Zach Zolton
  - name: Krackle
    url: https://github.com/bradgessler/krackle
    contributors:
      - Brad Gessler
      - Ronald McDonald
      - first_name: Billy
        last_name: Goat
  - name: Nada
```

What do you do? Krackle it!

```sh
$ curl https://raw.githubusercontent.com/bradgessler/krackle/master/spec/fixtures/profile.yml > profile.yml
$ cat profile.yml | krackle first_name
Brad
$ cat profile.yml | krackle location.state
CA
$ cat profile.yml | krackle location.tax_brackets[1]
really high
$ cat profile.yml | krackle projects[].contributors[0]
Brad Gessler
Brad Gessler
$ cat profile.yml | krackle projects[0].contributors[]
Brad Gessler
Zach Zolton
$ cat profile.yml | krackle projects[0].contributors[0]
Brad Gessler
```

Now you can query deep into YAML without cracking open a Ruby session.

## Contributing

1. Fork it ( https://github.com/bradgessler/krackle/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
