# wlog [![Code Climate](https://codeclimate.com/github/psyomn/wlog.png)](https://codeclimate.com/github/psyomn/wlog) [![Build Status](https://travis-ci.org/psyomn/wlog.png?branch=v1.1.0)](https://travis-ci.org/psyomn/wlog)

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

Install it with:

    $ gem install wlog

Run with:

    $ wlog

## Usage

On command line write

    wlog

When you specify nothing, the default database is used. If you want to store 
tasks in different databases (lets say you have project1, project2), then execute
the following line: 

    wlog project2

The databases are located here: 

    $HOME/.config/wlog/data/

The next section will talk about this a little more.

When you're in the command line interface, you can always run

    help

in order to list the possible commands you can use.

### More Commands

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

    [wlog] ls
    started work 2
      [6] Fix colors for wlog and make it pretty
      [4] Weird bug crash when pressing ctrl+d
    new 1
      [3] Need to check out templating system

Now we want to focus on a particular issue. We type in `focus`

    [wlog] focus 1
    [issue #1] 

And now we can show all the logged work with `ls` or `show`: 

    [issue #1] ls
    2013-10-13 - Sunday [2]
      [4] I did some work on this issue [15:34:08] 
      [5] Some trivial work there too [15:35:32] 
    [issue #1] 

To exit the scope of an issue, you can use the `forget` command:

    [issue #1] forget
    [wlog] 

While in the scope of an issue, you can display its full description by invoking
the command `desc`.

    [issue #4] desc
    
    Issue #4
      Reported : Sat Jul 12 00:46:27 2014
      Due      : Fri Oct 24 05:00:00 2014
      Entries  : 0
      Status   : started work
      Time     : 3w 4d 1h 
    
    Summary 
      This is some impressive work right here
    
    Description 
      But this is an ever longer desc 

You can also attach files to issues (you have to be outside the scope of an
issue for this - this feature is experimental at the momment so don't rely too
much on it):

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

## Inside issues

You can run these commands in this 'sub-shell' of the issues: 
are `show`, `search`, `replace`, `delete`, and `concat`.

`show` lists the latest work log entries.

`search` searches the database for a pattern that you specify.

`replace` searches and replaces a pattern that you specify.

`delete` removes an entry from the database.

`concat` appends a string to the specified log entry.

All of these will modify the entries of those issues.

## Logging Time

It's possible to log time now with the following commands:

    lt 10m

To log 10 minutes 

    lt 1h20m

To log 1 hour 20 minutes

    lt 1d 1s

To log one day, one second. (A day is 8 hours). The total time is stored on the
issue.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

### For newcommers

Look at the github issues, for things marked as 'Up for Grabs'. Feel free to 
message me to ask anything. I'll be more than happy to answer.

