use lib './lib';
use lib '.';
use DSL::English::SearchEngineQueries;

say "=" x 10;

my $commands = 'filetype:pdf site:wolfram.com peach OR cherry +blossom -"cherry tree" AND fruit';
my $commands2 = " 'peach' 'cherry'";

say "\n", '=' x 30;
say '-' x 3, 'Parsing:';
say '=' x 30;

#say DSL::English::SearchEngineQueries::Grammar.subparse( $commands );

say ToSearchEngineQueryCode($commands, 'Elasticsearch');
