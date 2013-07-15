# wlog

wlog (worklog) is a small utility to track tasks in command line. I use this
for things I work on and need to submit a list of stuff done on a particular 
day.

Disclaimer: Some of the things in this software assume an ANSI terminal. So you
might get weird characters if you're not on an ANSI terminal. 

## Installation

Add this line to your application's Gemfile:

    gem 'wlog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wlog

## Usage

On command line write

    wlog

When you specify nothing, the default database is used. If you want to store 
tasks in different databases (lets say you have project1, project2), then execute
the following line: 

    wlog project2

The databases are located here: 

    $HOME/.config/wlog/data/

And you should be in a command line interface. In the interface you can type in

    help

To see a list of actions that you can do. 

Usually you'll just need to write:

    new

And enter the work description that you wish. You can add tags like this too
in order to tag units of work:

    new

    Enter work description:
      I did something very productive today. #bugfix #completed #feature

The tags can be pretty much anything you want, and for now are not very 
important. In the future however they might be used for something more useful.

### More Commands

These are the commands that you can also use in order to exploit the full
potential of this application.

You can list the available databases by running the following command:

  wlog --list

Now, there are a few other commands that were not listed. These commands
are `show`, `search`, `replace`, `delete`, and `concat`.

`show`
  
    lists the latest work log entries.

`search`

    searches the database for a pattern that you specify.

`replace`

    searches and replaces a pattern that you specify.

`delete`

    removes an entry from the database.

`concat`

    appends a string to the specified log entry.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
