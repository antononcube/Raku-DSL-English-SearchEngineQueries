# DSL::English::SearchEngineQueries

A Raku package for search engine queries specification and translation.


-------

## Installation 

From [Zef ecosystem](https://raku.land):

```
zef install DSL::English::SearchEngineQueries;
```

From GitHub:

```
zef install https://github.com/antononcube/Raku-DSL-English-SearchEngineQueries
```

-------

## Usage examples

Here we interpret a Google-style search query spec into different "target" search spec DSLs:

```perl6
use DSL::English::SearchEngineQueries;
my $cmd = 'peach OR cherry +blossom -"cherry tree" AND fruit nrecs:20 recommender:Foods';

.say for <CLI Elasticsearch R::tidyverse WL-System>.map({ $_ => ToSearchEngineQueryCode($cmd, $_) })
```
```
# CLI => --profile='peach;cherry' --must='blossom;fruit' --must-not='cherry tree' --nrecs=20 --smr=Foods
# Elasticsearch => { "bool" : { "should" : [ { "term" : { "tag" : "peach" } },  { "term" : { "tag" : "cherry" } } ], "must" : [ { "term" : { "tag" : "blossom" } },  { "term" : { "tag" : "fruit" } } ], "must_not" : [ { "term" : { "tag" : "cherry tree" } } ] } }
# R::tidyverse => dplyr::filter( (term == "peach" | term == "cherry") & ( term == "blossom" & term == "fruit" ) & !( term == "cherry tree" ) )
# WL-System => Select[(term = "peach" || term = "cherry") && ( term = "blossom" && term = "fruit" ) && !( term = "cherry tree" ) ]
```

------

## CLI 

The package provides a Command Line Interface (CLI) script. Here is the usage message:

```
> ToSearchEngineQueryCode --help                    
Translates natural language commands into search query DSL code.
Usage:
  ToSearchEngineQueryCode <command> [-r|--target=<Str>] [-l|--language=<Str>] [-f|--format=<Str>] [-c|--clipboard-command=<Str>] -- Translates search engine commands into query programming code.
  ToSearchEngineQueryCode <target> <command> [-l|--language=<Str>] [-f|--format=<Str>] [-c|--clipboard-command=<Str>] -- Both target and command as arguments.
  ToSearchEngineQueryCode [<words> ...] [-t|--target=<Str>] [-l|--language=<Str>] [-f|--format=<Str>] [-c|--clipboard-command=<Str>] -- Command given as a sequence of words.
  
    <command>                       A string with one or many commands (separated by ';').
    -r|--target=<Str>               Target (programming language with optional library spec.) [default: 'R::tidyverse']
    -l|--language=<Str>             The search commands style to translate from. [default: 'Google']
    -f|--format=<Str>               The format of the output, one of 'automatic', 'code', 'hash', or 'raku'. [default: 'automatic']
    -c|--clipboard-command=<Str>    Clipboard command to use. [default: 'Whatever']
    <target>                        Programming language.
    [<words> ...]                   Words of a data query.
    -t|--target=<Str>               Target (programming language with optional library spec.) [default: 'R::tidyverse']
Details:
    If --clipboard-command is the empty string then no copying to the clipboard is done.
    If --clipboard-command is 'Whatever' then:
        1. It is attempted to use the environment variable CLIPBOARD_COPY_COMMAND.
            If CLIPBOARD_COPY_COMMAND is defined and it is the empty string then no copying to the clipboard is done.
        2. If the variable CLIPBOARD_COPY_COMMAND is not defined then:
            - 'pbcopy' is used on macOS
            - 'clip.exe' on Windows
            - 'xclip -sel clip' on Linux.
```

Here is an example execution from the command line:

```shell
ToSearchEngineQueryCode -t=Elasticsearch +book on graphs 
```
```
# { "bool" : { "should" : [ { "term" : { "tag" : "on" } },  { "term" : { "tag" : "graphs" } } ], "must" : [ { "term" : { "tag" : "book" } } ], "must_not" : [] } }
```

**Remark:** The result is automatically placed in the clipboard. 
