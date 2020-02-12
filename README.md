# README

Source for [dev.to article](https://dev.to/glenbray/extracting-addresses-from-millions-of-pages-with-automl-and-ruby-3djd)


## Setup

- `bundle install`
- `rails db:setup`
- `cp .env.example .env`
- manually update `.env` with relevant configuration

## Testing

`bundle exec rspec`

## Usage

```ruby
sites = Site.all
ExtractAddresses.process(sites)

addresses = Address.nlp
SearchAddress.process(addresses)

```
