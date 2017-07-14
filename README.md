
This repository contains content on [uniqush.org](http://uniqush.org). We use [webgen](https://webgen.gettalong.org/) to generate the web site.

Generating templates
--------------------

This requires version 0.5.9 of webgen, and ruby 1.8 (because of a dependency on rcov). To generate these templates locally, use rvm to temporarily use ruby 1.8:

```bash
rvm use 1.8.7
bundle install
webgen
# Alternately, run the command `bundle exec rake auto_webgen` to regenerate the site in the background as changes are made.
```

A dockerized version is available at `./main.sh`, to avoid the need to fiddle with specifics of the host operating system.
