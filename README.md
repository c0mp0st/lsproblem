# Packer

Solution to problem posed by LS

## Installation

To run the tests:

    $ rake test

To build and install the gem (for command line):

    $ bundle install
    $ rake build
    $ gem install pkg/packer-0.0.1.gem

## Usage

Command line options:

    $ packer --help
    Packer usage:
       --uri, -u <s>:   Specify Git URI
       --sha, -s <s>:   SHA1 to check out
      --name, -n <s>:   Project name (used to name tarball)
      --dest, -d <s>:   Destination directory (default: current directory)
       --version, -v:   Print version and exit
          --help, -h:   Show this message

To run the server:

    $ thin start -p 4567 -e production

or use the supplied Procfile with foreman:

    $ foreman start

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
