#!/usr/bin/env perl6

use DSL::English::SearchEngineQueries;

#| Translates search engine commands into query programming code.
multi sub MAIN(Str $command,                   #= A string with one or many commands (separated by ';').
               Str :$target = 'Elasticsearch', #= Target (programming language with optional library spec.)
               Str :$language = 'Google',      #= The search commands style to translate from.
               Str :$format = 'automatic'      #= The format of the output, one of 'automatic', 'code', 'hash', or 'raku'.
               ) {

    my Str $formatSpec = $format.lc (elem) <auto automatic whatever> ?? 'code' !! $format.lc;

    say ToSearchEngineQueryCode($command, $target, :$language, format => $formatSpec);
}

multi sub MAIN(Str $target,                    #= Programming language.
               Str $command,                   #= A string with one or many commands (separated by ';').
               Str :$language = 'Google',      #= The search commands style to translate from.
               Str :$format = 'automatic',     #= The format of the output, one of 'automatic', 'code', 'hash', or 'raku'.
               ) {
    MAIN($command, :$target, :$language, :$format);
}
