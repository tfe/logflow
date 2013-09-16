[logflow](http://github.com/tfe/logflow/)
=========================================

A quick and dirty script for importing CSV flight logbooks into [Coradine's LogTen
Pro](http://coradine.com). Now the OS X version [supports direct CSV
import](http://help.coradine.com/kb/logten-pro-mac/how-to-import-your-data), but I only wanted the
iOS version which has no CSV import capability. It does, however, support the [LogTen Pro
API](http://help.coradine.com/kb/customizing-logten/logten-pro-api-for-directly-importing-data)
which allows importing data via OS URL scheme handlers (e.g. `logten://method/{json_payload}`).

This script spins up a tiny web server on your computer that serves a page with a single link in the
above format containing all the data in a given CSV. You can just visit it from your iOS device with
LogTen installed, click the link, and LogTen will ask if you want to import the data.

![logflow data preview](http://files.toddeichel.com/logflow/logflow-1.png)
![LogTen import screen](http://files.toddeichel.com/logflow/logflow-2.png)

Usage
-----

### Customize for your logbook CSV

This probably isn't going to work out of the box for you without some modification or building your
own schema file outright. The current (and only) schema is made to import a CSV I had previously
built for importing into Zululog (sample data at the top of `schema/zululog.rb`). I don't think the
format is standardized though, so I may not have the same columns as you.

To customize this to work for you, look in the `schema` folder and copy the existing `zululog.rb`.
Then, you can use the docs for the [conformist gem](https://github.com/tatey/conformist) to build
your own schema file that works for your CSV. It's all column index based. With conformist you can
do cool things like combine multiple columns and create virtual columns. Reference the [LogTen Pro API docs](http://s3.amazonaws.com/entp-tender-production/assets/f9e264a74a0b287577bf3035c4f400204336d84d/LogTen_Pro_API.pdf)
to see what to name the columns. If you create your own schema class, don't forget to change the
schema definition in `logbook.rb`. You can check your work at any time by starting up the server
(see below) and looking at the output JSON in your web browser.

### Installation

You need a working Ruby installation and Bundler (`gem install bundler`). After that:

    # clone the repo
    git clone git@github.com:tfe/logflow.git
    cd logflow

    # install dependencies; feel free to include dev/test if you want to work on it or run the test suite
    bundle install --without development test

    # put your logbook in data/logbook.csv or otherwise pass the path a LOGBOOK_CSV environment var

    # start up the server; the `-o` flag is so that this server will be accessible from the network
    ruby logflow.rb -o 0.0.0.0

Then just use a web browser on your iOS device to browse to your computer's IP address on port 4567
(default port for Sinatra). You'll be able to see the flight data to be imported, and you can tap
the link at the top to import to LogTen.


Todo
----

* Accept the CSV as a file upload rather than reading from a fixed file system path.
* Support more logbook formats for import out of the box.
* Be usable by non-programmer types. :-)

Contact
-------

Problems, comments, and pull requests all welcome. [Find me on GitHub.](http://github.com/tfe/)


Copyright
---------

Copyright © 2013 [Todd Eichel](http://toddeichel.com/).
