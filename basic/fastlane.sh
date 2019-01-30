#!/bin/sh -e

# ensure we have the correct encoding
export LC_ALL=en_US.UTF-8


# Install necessary version of bundler
bundler_version=`ruby -e 'puts $<.read[/BUNDLED WITH\n   (\S+)$/, 1] || "<1.10"' Gemfile.lock`
gem install bundler --conservative --no-document -v $bundler_version

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

