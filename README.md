# A Sinatra Logger ![Build Status][1]

### History

I wrote this wrapper around log4r in 2014 for a small Sinatra project at
[Lookout][4]. As the project ended, the code was pulled out
and open sourced by [ismith][3] and included in [lookout-rack-utils][2].

### Changes

It is mostly unchanged here, though configuration is done through the logging
constructor, not through configatron. Graphite logging was also thrown out,
though that could be re-added if desired. And of course there was a namespace
change.

### Purpose

This was written for usage in Sinatra -- as logging isn't provide outside of
request context. But it could be used in any Ruby project.

[1]: https://api.travis-ci.org/svrana/sinatra-log.svg?branch=master
[2]: https://github.com/lookout/lookout-rack-utils.git
[3]: https://github.com/ismith
[4]: https://lookout.com
