use lib './lib';
use lib '.';
use DSL::English::SearchEngineQueries;

say "=" x 10;

my $commands1 = 'peach OR cherry +blossom -"cherry tree" AND fruit';
my $commands2 = 'filetype:pdf site:wolfram.com peach OR cherry +blossom -"cherry tree" AND fruit';
my $commands3 = " 'peach' 'cherry'";
my $commands4 = 'filetype:movie +actor:"Uma Turman" -title:"Pulp Fiction" genre:action "release year":2000 samurai sword yakuza';
my $commands5 = 'use recommender system smrMovies; +actor:"Uma Turman" -title:"Pulp Fiction" sword';

#say "\n", '=' x 30;
#say '-' x 3, 'Parsing:';
#say '=' x 30;

#say DSL::English::SearchEngineQueries::Grammar.subparse( $commands5 );

say "\n", '=' x 30;
say '-' x 3, 'R-tidyverse:';
say '';

say ToSearchEngineQueryCode($commands4, 'R-tidyverse');

say "\n", '=' x 30;
say '-' x 3, 'R-SMRMon:';
say '';

say ToSearchEngineQueryCode($commands4, 'R-SMRMon');

say "\n", '=' x 30;
say '-' x 3, 'WL-SMRMon:';
say '';

say ToSearchEngineQueryCode($commands4, 'WL-SMRMon');
