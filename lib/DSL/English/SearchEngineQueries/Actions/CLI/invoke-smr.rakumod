=begin comment
#==============================================================================
#
#   Search engine queries invoke-smr actions in Raku (Perl 6)
#   Copyright (C) 2022  Anton Antonov
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Written by Anton Antonov,
#   ʇǝu˙oǝʇsod@ǝqnɔuouoʇuɐ,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku (Perl6) see https://raku.org/ .
#
#==============================================================================
=end comment

use v6.d;

use DSL::English::SearchEngineQueries::Actions::WL::SMRMon;

class DSL::English::SearchEngineQueries::Actions::CLI::invoke-smr
        is DSL::English::SearchEngineQueries::Actions::WL::SMRMon {

	# Search command
	method search-query-command($/) { make $/.values[0].made; }

	method query-element-spec-list($/) {
		my @pairs = $<query-element-spec>>>.made;

		my %groups =  @pairs.classify: *.[0], as => *.[1];

		my $should = do if %groups<SHOULD> { ' --profile=\'' ~ %groups<SHOULD>.join(';') ~ '\'' } else { '' };
		my $must = do if %groups<MUST> { ' --must=\'' ~ %groups<MUST>.join(';') ~ '\'' } else { '' };
		my $mustNot = do if %groups<MUSTNOT> { ' --must-not=\'' ~ %groups<MUSTNOT>.join(';') ~ '\'' } else { '' };
		my $nrecs = do if %groups<NRESULTS> { ' --nrecs=' ~ %groups<NRESULTS>[0] } else { '' };
		my $smr = do if %groups<RECOMMENDER> { ' --smr=' ~ %groups<RECOMMENDER>[0] } else { '' };

		make 'invoke-smr.py' ~ $should ~ $must ~ $mustNot ~ $nrecs ~ $smr;
	}

	method query-term($/) { make $/.Str; }
	method query-phrase($/) { make $/.Str.substr(1, *-1); }
}