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

use DSL::Shared::Utilities::CommandProcessing;

use DSL::English::SearchEngineQueries::Grammar;

use DSL::English::SearchEngineQueries::Actions::Elasticsearch::Standard;
use DSL::English::SearchEngineQueries::Actions::R::tidyverse;
use DSL::English::SearchEngineQueries::Actions::R::SMRMon;
use DSL::English::SearchEngineQueries::Actions::Raku::Ecosystem;
use DSL::English::SearchEngineQueries::Actions::WL::SMRMon;
use DSL::English::SearchEngineQueries::Actions::WL::System;


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
    "R-SMRMon"               => DSL::English::SearchEngineQueries::Actions::R::SMRMon,
    "R-tidyverse"            => DSL::English::SearchEngineQueries::Actions::R::tidyverse,
    "R::SMRMon"              => DSL::English::SearchEngineQueries::Actions::R::SMRMon,
    "Raku-Ecosystem"         => DSL::English::SearchEngineQueries::Actions::Raku::Ecosystem,
    "Raku::Ecosystem"        => DSL::English::SearchEngineQueries::Actions::Raku::Ecosystem,
    "SMRMon-R"               => DSL::English::SearchEngineQueries::Actions::R::SMRMon,
    "SMRMon-WL"              => DSL::English::SearchEngineQueries::Actions::WL::SMRMon,
    "WL-SMRMon"              => DSL::English::SearchEngineQueries::Actions::WL::SMRMon,
    "WL-System"              => DSL::English::SearchEngineQueries::Actions::WL::System,
    "WL::SMRMon"             => DSL::English::SearchEngineQueries::Actions::WL::SMRMon,
    "WL::System"             => DSL::English::SearchEngineQueries::Actions::WL::System;

my %targetToSeparator{Str} =
    "Elasticsearch"          => " \n",
    "Elasticsearch-Standard" => " \n",
    "R-SMRMon"               => " %>%\n",
    "R-tidyverse"            => " %>%\n",
    "SMRMon-R"               => " %>%\n",
    "Raku-Ecosystem"         => ";\\n",
    "Raku::Ecosystem"        => ";\\n",
    "SMRMon-WL"              => " \\[DoubleLongRightArrow]\n",
    "WL-SMRMon"              => " \\[DoubleLongRightArrow]\n",
    "WL::SMRMon"             => " \\[DoubleLongRightArrow]\n",
    "WL-System"              => ";\n",
    "WL::System"             => ";\n";

#-----------------------------------------------------------
proto ToSearchEngineQueryCode(Str $command, Str $target = "R-SMRMon" ) is export {*}

multi ToSearchEngineQueryCode ( Str $command, Str $target = 'R-SMRMon', *%args ) {

    DSL::Shared::Utilities::CommandProcessing::ToWorkflowCode( $command,
                                                               grammar => DSL::English::SearchEngineQueries::Grammar,
                                                               :%targetToAction,
                                                               :%targetToSeparator,
                                                               :$target,
                                                               |%args )

}