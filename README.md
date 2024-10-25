# OmniAuth Roblox
OmniAuth strategy for Roblox

## Installation
Add to your `Gemfile`
```
gem 'omniauth-roblox'
```
Run `bundle install`

## Setup
Roblox's OAuth API is now public, although your account must be ID verified to utilize it.

- Verify your Roblox account in settings if needed
- Go to https://create.roblox.com/dashboard/credentials?activeTab=OAuthTab
- Fill out the fields and select your scopes
- Publish your app

## Usage
An example of adding this middleware to your Rails app in `config/initializers/omniauth.rb`
```rb
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :roblox, ENV['RBX_CLIENT_ID'], ENV['RBX_CLIENT_SECRET']
end
```

## Configuration Options
- `scope`: The `openid` and `profile` scopes are set by default.
