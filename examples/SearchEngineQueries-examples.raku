use lib './lib';
use lib '.';
use DSL::English::SearchEngineQueries;

say "=" x 10;

my $commands1 = 'DSL TARGET R-SMRMon; peach OR cherry +blossom -"cherry tree" AND fruit';
my $commands2 = 'filetype:pdf site:wolfram.com peach OR cherry +blossom -"cherry tree" AND fruit';
my $commands3 = " 'peach' 'cherry'";
my $commands4 = 'DSL TARGET R-SMRMon; filetype:movie +actor:"Uma Turman" -title:"Pulp Fiction" genre:action "release year":2000 samurai sword yakuza';
my $commands5 = 'use recommender system smrMovies; +actor:"Uma Turman" -title:"Pulp Fiction" sword';


my @commands = $commands2;

my @targets = ('Elasticsearch', 'R-tidyverse', 'R-SMRMon', 'WL-SMRMon' );

for @commands -> $c {
    say "\n", '=' x 20;
    say $c.trim;
    for @targets -> $t {
        say '-' x 20;
        say $t.trim;
        say '-' x 20;
        say ToSearchEngineQueryCode($c, $t);
    }
}
