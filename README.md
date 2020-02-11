# README

Source for https://medium.com/p/10d8c36c9dfa

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
