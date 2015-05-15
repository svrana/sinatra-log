# Sinatra::Log ![Build Status][1]

A simple logger written for usage in Sinatra apps.

## Installation

Add this line to your application's Gemfile:

    gem 'sinatra-log'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install sinatra-log

## Purpose

This was written for usage in Sinatra -- as logging isn't provide outside of
request context. But it could be used in any Ruby project.

## History

I wrote this wrapper around log4r in 2014 for a small Sinatra project at
[Lookout][4]. As the project ended, the code was pulled out
and open sourced by [ismith][3] and included in [lookout-rack-utils][2].

## Changes

The changes here remove the Lookout specific bits of the logging - the use of
specific configatron values that may not match your project or style.
Graphite logging was also thrown out, though that could be re-added if
desired. And of course there was a namespace change.

[1]: https://api.travis-ci.org/svrana/sinatra-log.svg?branch=master
[2]: https://github.com/lookout/lookout-rack-utils.git
[3]: https://github.com/ismith
[4]: https://lookout.com
