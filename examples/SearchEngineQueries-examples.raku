use DSL::English::SearchEngineQueries;
use DSL::English::SearchEngineQueries::Grammar;

my $COMMAND = DSL::English::SearchEngineQueries::Grammar.new;

say "=" x 10;

my $commands =
        ('peach OR cherry +blossom -"cherry tree" AND fruit nrecs:20 recommender:Foods',
         '"Tag:cli" "Tag:parser" +"Author:drforr" nrecs:20 recommender:ZefEcosystem script:invoke-smr.R',
         'DSL TARGET R-SMRMon; peach OR cherry +blossom -"cherry tree" AND fruit',
         'site:wolfram.com peach',
         'type:pdf site:wolfram.com peach OR cherry +blossom -"cherry tree" AND fruit',
         " 'peach' 'cherry'",
         'DSL TARGET R-SMRMon; filetype:movie +actor:"Uma Turman" -title:"Pulp Fiction" genre:action "release year":2000 samurai sword yakuza',
         'use recommender system smrMovies; +actor:"Uma Turman" -title:"Pulp Fiction" sword');


my @commands2 = $commands[1];

#my @targets = ('Elasticsearch', 'R-tidyverse', 'R-SMRMon', 'WL-SMRMon', 'WL-System' );
#my @targets = <R-tidyverse Raku-Ecosystem>;
my @targets = <CLI::invoke-smr>;

for @commands2 -> $c {
    say "\n", '=' x 20;
    say $c.trim;
    for @targets -> $t {
        say '-' x 20;
        say $t.trim;
        say '-' x 20;
        #        say $COMMAND.parse($c);
        #        say '-' x 20;
        say ToSearchEngineQueryCode($c, $t);
    }
}
