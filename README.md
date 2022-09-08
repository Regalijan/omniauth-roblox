# OmniAuth Roblox
OmniAuth strategy for Roblox

## Installation
Add to your `Gemfile`
```
gem 'omniauth-roblox'
```
Run `bundle install`

## Setup
⚠️ Roblox's OAuth API is currently private access only ⚠️

- Go to https://create.roblox.com/credentials
- Fill out the fields and select your scopes

## Usage
An example of adding this middleware to your Rails app in `config/initializers/omniauth.rb`
```rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :roblox, ENV['RBX_CLIENT_ID'], ENV['RBX_CLIENT_SECRET']
end
```

## Configuration Options
- `scope`: No scopes are currently set by default, Roblox requires the `openid` scope at the minimum.
- `image_type`: The type of image that should be returned by roblox, defaults to `headshot`. Allowed values: `[empty string]` (full body), `bust`, and `headshot`.
- `jwt_leeway`: Amount of leeway in seconds passed to the JWT library, only works with version 2.1 or earlier.
- `skip_image`: If this is set to `true`, no image url will be returned.
