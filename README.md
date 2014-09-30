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

# Main Interface

    [wlog]

Enter the command `new` to create a new issue: 

    [wlog] new

Follow the on screen queries in order to create the issue.
Enter the command `show` or `ls` to list the issues:

    [wlog] ls
    started work 2
      [6] Fix colors for wlog and make it pretty
      [4] Weird bug crash when pressing ctrl+d
    new 1
      [3] Need to check out templating system

Now we want to focus on a particular issue. We type in `focus`:

    [wlog] focus 1
    [issue #1] 

And now we can show all the logged work with `ls` or `show`: 

    [issue #1] ls
    2013-10-13 - Sunday [2]
      [4] I did some work on this issue [15:34:08] 
      [5] Some trivial work there too [15:35:32] 
    [issue #1] 

And commands you execute apply to the scope of only that issue. You can type in
`help` for more info.

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

## Logging Time

It's possible to log time within issue scope with the following commands:

    lt 10m

To log 10 minutes 

    lt 1h20m

To log 1 hour 20 minutes

    lt 1d 1s

To log one day, one second. (A day is 8 hours). The total time is stored on the
issue.

## Inside issues

You can run these commands in this 'sub-shell' of the issues: 
are `search`, `replace`, `delete`, and `concat`.

    search 
        searches the database for a pattern that you specify.

    replace 
        searches and replaces a pattern that you specify.

    delete 
        removes an entry from the database.

    concat 
        appends a string to the specified log entry.

## Escape Scope 

To exit the scope of an issue, you can use the `forget` command:

    [issue #1] forget
    [wlog] 

*NOTE*: Attachments don't currently work in v1.1.5 - they might be back in the
future.

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

# Generating Invoices

You can generate invoices. You need to create an invoice first. To do that,
enter the command `invoices` in the `wlog` shell:

    [wlog] invoices
    [invoices]

You can create a new invoice with the `new` command. Enter the two dates which
correspond the date range you want to bill. For example, let's enter the whole
month of September:

    [invoice] new
    From (dd-mm-yyyy) 01-09-2014
    To   (dd-mm-yyyy) 30-09-2014
    I did many things this month
    It is very very true
    And I can write all of this in multiline
    
    And I can break into another paragraph.
    
    And another.
    
    But you need to press enter a few more times until you
    break you of the input for the invoice.
    
    
    
    
    
    
    [invoice] 

So now you should have your first invoice:

    [invoice] show
      [1] 01-09-2014 -> 30-09-2014 I

And now you can generate your invoice with the following command:

    [invoice] generate 1

This will write the output in `~/Documents/wlog/`. Will create dirs if not
exist.

## Templates

To generate invoices templates are used. Templates are _erb_ templates. They are
stored in `~/.config/wlog/templates/`. You can write your own as well. If you
write your own, you need to tell wlog to use them. Do so with the following
commands:

    [templates] show
       [  1] /home/psyomn/.config/wlog/templates/default.erb
     * [  2] /home/psyomn/.config/wlog/templates/mine.erb.html
    [templates] set 1
    [templates] show
     * [  1] /home/psyomn/.config/wlog/templates/default.erb
       [  2] /home/psyomn/.config/wlog/templates/mine.erb.html

Also, worth to note that you should verify any template you get off the
internet to use as your own.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Developers

Check issue tracker - thanks.
