=begin pod

=head1 DSL::English::SearchEngineQueries

C<DSL::English::SearchEngineQueries> package has grammar and action classes for the parsing and
interpretation of natural language commands that specify data queries in the style of
Standard Query Language (SQL) or RStudio's library tidyverse.

=head1 Synopsis

    use DSL::English::SearchEngineQueries;
    my $rcode = to_dplyr("select height & mass; arrange by height descending");

=end pod

unit module DSL::English::SearchEngineQueries;

use DSL::English::SearchEngineQueries::Grammar;

use DSL::English::SearchEngineQueries::Actions::R::SMRMon;


#-----------------------------------------------------------

#my %targetToAction := {
#    "tidyverse"         => DSL::English::SearchEngineQueries::Actions::R::tidyverse,
#    "R-tidyverse"       => DSL::English::SearchEngineQueries::Actions::R::tidyverse,
#    "R"             => DSL::English::SearchEngineQueries::Actions::R::base,
#    "R-base"        => DSL::English::SearchEngineQueries::Actions::R::base,
#    "pandas"        => DSL::English::SearchEngineQueries::Actions::Python::pandas,
#    "Python-pandas" => DSL::English::SearchEngineQueries::Actions::Python::pandas,
#    "WL"            => DSL::English::SearchEngineQueries::Actions::WL::Dataset,
#    "WL-SQL"        => DSL::English::SearchEngineQueries::Actions::WL::SQL
#};

my %targetToAction =
    "SMRMon-R"         => DSL::English::SearchEngineQueries::Actions::R::SMRMon,
    "R-SMRMon"         => DSL::English::SearchEngineQueries::Actions::R::SMRMon;

my %targetToSeparator{Str} =
    "R-SMRMon"         => " %>%\n",
    "SMRMon-R"         => " %>%\n";

#-----------------------------------------------------------
sub has-semicolon (Str $word) {
    return defined index $word, ';';
}

#-----------------------------------------------------------
proto ToSearchEngineQueryCode(Str $command, Str $target = "R-SMRMon" ) is export {*}

multi ToSearchEngineQueryCode ( Str $command where not has-semicolon($command), Str $target = "R-SMRMon" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my $match = DSL::English::SearchEngineQueries::Grammar.parse($command.trim, actions => %targetToAction{$target} );
    die 'Cannot parse the given command.' unless $match;
    return $match.made;
}

multi ToSearchEngineQueryCode ( Str $command where has-semicolon($command), Str $target = "R-SMRMon" ) {

    die 'Unknown target.' unless %targetToAction{$target}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @dqLines = map { ToSearchEngineQueryCode($_, $target) }, @commandLines;

    return @dqLines.join( %targetToSeparator{$target} ).trim;
}
