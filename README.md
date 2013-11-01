# wlog [![Code Climate](https://codeclimate.com/github/psyomn/wlog.png)](https://codeclimate.com/github/psyomn/wlog)

wlog (worklog) is a small utility to track tasks in command line. I use this
for things I work on and need to submit a list of stuff done on a particular 
day.

On the long term, I wish to provide some kind of ability to interface with
redmine, and synchronize tasks. This way we'd be able to have a git-like 
utitlity for issue tracking - that is log your work on your computer, and push
it to the server whenever you're done (or want to update others on your
progress). 

## Source Location

You can find the sources on github: 

[http://github.com/psyomn/wlog](http://github.com/psyomn/wlog)


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

If for some reason you need to check out where the application stores the 
databases, you can do the following: 

    wlog --where

That will print the absolute path to that directory. 

At the moment there are two main uis in this application. One of the UI is to
demonstrate the issues that are currently to be worked on. Then you choose an
issue, and log your work on that particular issue only. 

So when you start the application this is what you see: 

    [wlog]

Enter the command `show` to list the issues

    [wlog] show
    started work 2
      [6] Fix colors for wlog and make it pretty
      [4] Weird bug crash when pressing ctrl+d
    new 1
      [3] Need to check out templating system

Now we want to focus on a particular issue. We type in `focus`

    [wlog] focus
    Focus on issue: 
    1
    [issue #1] 

And now we can show all the logged work with `show`: 

    [issue #1] show
    2013-10-13 - Sunday [2]
      [4] I did some work on this issue [15:34:08] 
      [5] Some trivial work there too [15:35:32] 
    [issue #1] 

To exit the scope of an issue, you can use the `forget` command:

    [issue #1] forget
    [wlog] 

If you forgot what you are doing, you can do

    [issue #1] desc
    + Issue #6
      - Reported : 2013-10-26 15:01:45 -0400
      - Due      : 1969-12-31 19:00:00 -0500
      - Entries  : 0
      - Status   : started work
      - Time     : 3h 

      - Whatever description you wrote for issue 1

You can also attach files to issues

    [wlog] attach
    Attach to which issue? : 1
    Absolute file location : /tmp/derp.txt
    Alias name for file (optional) :
    Attached file.

And then you can output them to a location: 

    [wlog] show
    finished [1]
    [2] This is yet another issue
    started work [1]
    [1] This is my issue
    [wlog] showattach
    Which issue : 1
    [1] - derp.txt (alias: )
    [2] - derp.txt (alias: )
    [wlog] outattach
    Which attachment to output? : 1
    Output where (abs dir) : /tmp/

You can run these commands in this 'sub-shell': 
are `show`, `search`, `replace`, `delete`, and `concat`.

`show` lists the latest work log entries.

`search` searches the database for a pattern that you specify.

`replace` searches and replaces a pattern that you specify.

`delete` removes an entry from the database.

`concat` appends a string to the specified log entry.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### For newcommers

Look at the github issues, for things marked as 'Up for Grabs'. Feel free to 
message me to ask anything. I'll be more than happy to answer.

