# wlog [![Code Climate](https://codeclimate.com/github/psyomn/wlog.png)](https://codeclimate.com/github/psyomn/wlog) [![Build Status](https://travis-ci.org/psyomn/wlog.png?branch=v1.1.0)](https://travis-ci.org/psyomn/wlog) [![Inline docs](http://inch-ci.org/github/psyomn/wlog.svg?branch=master)](http://inch-ci.org/github/psyomn/wlog) [![Gem Version](https://badge.fury.io/rb/wlog.svg)](http://badge.fury.io/rb/wlog) [![Coverage Status](https://img.shields.io/coveralls/psyomn/wlog.svg)](https://coveralls.io/r/psyomn/wlog?branch=v1.2.0)

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

    File
      N/A

### Attachments

You can also attach files to issues while being within issue scope:

    [issue #1] attach
    Attach to which issue? : 1
    Absolute file location : /tmp/derp.txt
    Alias name for file (optional) :
    Attached file.
    
There's two commands you can use to list attachments within issue scope:
`attachls`, `desc`. `desc` will print all the issue information, and show
the attachments in the end.

You can output attachments to a location: 

    [issue #1] attachls 
    [1] - become-a-killer-cook.pdf
    [2] - very-boring-doc.pdf 
    [issue #1] attachout
    Which attachment to output? : 1
    Output where (abs dir) ? : /tmp/

*Warn*: This is a somewhat nice feature, though it might be axed in the future
if storing files is too problematic.

## Logging Time

It's possible to log time within issue scope with the following commands:

    [issue #1] lt 10m

To log 10 minutes 

    [issue #1] lt 1h20m

To log 1 hour 20 minutes

    [issue #1] lt 1d 1s

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
    
    

    [invoices] new
    From (dd-mm-yyyy) 01-09-2014
    To   (dd-mm-yyyy) 30-09-2014
    > I start writing this it is a 
    > very nice paragraph. I can break
    > lines and do whatever. And continue
    > writing and do whatever.
    > 
    > Two lines can separate a paragraph
    > And if you notice you can have many
    > paragraphs in the invoice.
    > 
    > And another. But if we hit return 3
    > times, then it will stop recording
    > our lines.
    > 
    > 
    [invoices] 

So now you should have your first invoice:

    [invoice] show
      [1] 01-10-2014 -> 30-10-2014 This is some text I'm currently writing and I'm no...

    [invoice] ls
      [1] 01-10-2014 -> 30-10-2014 This is some text I'm currently writing and I'm no...

And now you can generate your invoice with the following command:

    [invoice] generate 1

This will write the output in `~/Documents/wlog/`. Will create dirs if not
exist. The outputs are generated from templates which exist in
_$HOME/.config/wlog/templates_. You can write your own.

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

Templates are set per database. So if you want to use different templates (1 at
a time) per database, it's possible. You can take a look at an example template
that exploits all the currently available template variables
[here](https://gist.github.com/psyomn/790fd35f78d30d9d3604).

## Git Integration

There's some very loose (and probably crappy) integration with git repos. What
you do is point `wlog` to your project directory + .git/. So for example, if we
were tracking this repo with `wlog`, we would do the following:

    [wlog] git
    [git] ls
      repo: 
      auth: 
    [git] set
    Path to git repo (eg: project/.git/): /home/psyomn/programming/ruby/wlog/.git/
    git author: psyomn
    [git] ls
      repo: /home/psyomn/programming/ruby/wlog/.git/
      auth: psyomn

So now, when you're generating invoices, you can add your commits as well. If
you want to simply list a bunch of commits for a particular invoice, you can
invoke the `commits` command. The commits between the two dates of that invoice 
will be printed on screen.

    [invoices] ls
      [1] 01-10-2014 -> 30-10-2014 This is some text I'm currently writing and I'm no...
      [2] 01-09-2014 -> 30-09-2014 I start writing this it is a...
    [invoices] commits 2 

      git commits for psyomn

      5a46cf61dd6471f22731b7cbf1d21d1d0f79f7a2 wlog.gemspec: set version of AR to 4.1.6 ...
      8ca561e3412fde1828f983b79ee47a158d16bbf6 README.md: update usage instructions ...
      fcb5adbba04c22ef931147b8acbf641d9d26bb33 template/ui: niceify template selection ...
      e10bdee3cd8ae2f12ae55aef5cef249433459397 invoices/issues/entries: fix timezone issue ...
      8ef9a823da2d80bba510838dd591703baad2c9ac invoices: generating works. ...
      cf1627259cc7d278084f90559efa75d1fe4f60ba staticconfig: add template output dir ...
      22d760f881e613a30d3b722dd9b26f4f46c1cf4c domain/log_entry: add belongs_to issue ...
      79d1e3393587b02c328a454d5cfe301d3f80aee8 invoices: select date range for log entries ...

## Config

If you want to unset colors you can do so by going to the config menu

    [wlog] config
    [config]

and then typing in 

    [config] set ansi no

When you restart wlog, the colors will be set off. To set colors back on just
use `yes`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# Developers

Check issue tracker - thanks.
