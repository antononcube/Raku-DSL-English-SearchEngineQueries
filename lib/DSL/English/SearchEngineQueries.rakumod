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

use DSL::Shared::Utilities::MetaSpecsProcessing;

use DSL::English::SearchEngineQueries::Grammar;

use DSL::English::SearchEngineQueries::Actions::Elasticsearch::Standard;
use DSL::English::SearchEngineQueries::Actions::R::tidyverse;
use DSL::English::SearchEngineQueries::Actions::R::SMRMon;
use DSL::English::SearchEngineQueries::Actions::WL::SMRMon;


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
    "Elasticsearch"          => DSL::English::SearchEngineQueries::Actions::Elasticsearch::Standard,
    "Elasticsearch-Standard" => DSL::English::SearchEngineQueries::Actions::Elasticsearch::Standard,
    "R-tidyverse"            => DSL::English::SearchEngineQueries::Actions::R::tidyverse,
    "R-SMRMon"               => DSL::English::SearchEngineQueries::Actions::R::SMRMon,
    "SMRMon-R"               => DSL::English::SearchEngineQueries::Actions::R::SMRMon,
    "WL-SMRMon"              => DSL::English::SearchEngineQueries::Actions::WL::SMRMon,
    "SMRMon-WL"              => DSL::English::SearchEngineQueries::Actions::WL::SMRMon;

my %targetToSeparator{Str} =
    "Elasticsearch"          => " \n",
    "Elasticsearch-Standard" => " \n",
    "R-tidyverse"            => " %>%\n",
    "R-SMRMon"               => " %>%\n",
    "SMRMon-R"               => " %>%\n",
    "WL-SMRMon"              => " ==>\n",
    "SMRMon-WL"              => " ==>\n";

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

    my $specTarget = get-dsl-spec( $command, 'target');

    $specTarget = $specTarget ?? $specTarget<DSLTARGET> !! $target;

    die 'Unknown target.' unless %targetToAction{$specTarget}:exists;

    my @commandLines = $command.trim.split(/ ';' \s* /);

    @commandLines = grep { $_.Str.chars > 0 }, @commandLines;

    my @cmdLines = map { ToSearchEngineQueryCode($_, $specTarget) }, @commandLines;

    @cmdLines = grep { $_.^name eq 'Str' }, @cmdLines;

    return @cmdLines.join( %targetToSeparator{$specTarget} ).trim;
}
