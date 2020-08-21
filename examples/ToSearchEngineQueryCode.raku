#!/usr/bin/env perl6
use DSL::English::SearchEngineQueries;

sub MAIN( Str $commands, Str $target = 'Elasticsearch' ) {
    put ToSearchEngineQueryCode( $commands, $target );
}

