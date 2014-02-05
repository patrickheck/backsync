Backsync Shell Backup Tools
===========================

Contents
--------
* rsyncbackup.sh - shell script, that runs backups to a remote server using rsync
* mysqlbackup.sh - shell script, that runs mysql db backups to the local server
* config/backup.conf.sample - sample config files for general settings
* config/rsyncdirs.conf.sample - sample file, that contains the dirs that should be backed up using rsync
* config/rsyncrules.conf.sample - sample file, that contains the patterns and dirs to be ignored when running

Installation
------------

Copy the sample files: 

* cp config/backup.conf.sample config/backup.conf
* cp config/rsyncdirs.conf.sample config/rsyncdirs.conf
* cp config/rsyncrules.conf.sample config/rsyncrules.conf

Edit the newly created files to your needs.

Run backups by executing the two shell scripts.


Author
------

Patrick Heck (patrick@patrickheck.de)

Licence
-------

The MIT License (MIT)

Copyright (c) 2013 Patrick Heck (patrick@patrickheck.de)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
