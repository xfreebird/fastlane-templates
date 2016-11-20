#!/bin/sh -e

# ensure we have the correct encoding
export LC_ALL=en_US.UTF-8


# check if bundler is installed
if ! [ -x "$(command -v bundle)" ]; then
  gem install bundler --no-rdoc --no-ri  
fi

# cache gem packages
gem_cache="$HOME/.bundler/gems/cache"
bundle package --all --path "$gem_cache"

install_mode=""
# if is CI use deployment mode
if [ -n "$BUILD_ID" ]; then
	install_mode="--deployment"
fi

bundle install $install_mode  --retry=3 --path "$gem_cache"
bundle exec fastlane "$@"

