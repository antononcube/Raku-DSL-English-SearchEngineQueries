=begin comment
#==============================================================================
#
#   Search engine queries Raku-Ecosystem actions in Raku (Perl 6)
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

use DSL::Shared::Actions::English::Raku::PipelineCommand;
use DSL::Shared::Actions::Raku::PredicateSpecification;

class DSL::English::SearchEngineQueries::Actions::Raku::Ecosystem
        is DSL::Shared::Actions::English::Raku::PipelineCommand
        is DSL::Shared::Actions::Raku::PredicateSpecification {

	method TOP($/) { make $/.values[0].made; }

	# DSL::Shared::Actions::R::CommonStructures overwrites
	method variable-names-list($/) { make $<variable-name>>>.made.join(', '); }
	method quoted-variable-names-list($/) { make $<quoted-variable-name>>>.made.join(', '); }
	method mixed-quoted-variable-names-list($/) { make $<mixed-quoted-variable-name>>>.made.join(', '); }

	# Data load command
    method data-load-command($/)  { make $/.values[0].made; }
    method data-location-spec($/) { make $<dataset-name>.made; }
	method load-data-table($/)    { make 'example-dataset(' ~ $<data-location-spec>.made ~ ')'; }
    method use-data-table($/)     { make $<variable-name>.made; }
    method use-recommender($/)    { make $<variable-name>.made ~ '.takeData'; }

	# Filter command
	method filter-command($/) { make '.grep(' ~ $<filter-spec>.made ~ ')'; }
	method filter-spec($/) { make $<predicates-list>.made; }

	# Search command
	method search-query-command($/) { make $/.values[0].made; }

	method query-element-spec-list($/) {
		my @pairs = $<query-element-spec>>>.made;

		my %groups =  @pairs.classify: *.[0], as => *.[1];

		my $should = do if %groups<SHOULD> { ~ %groups<SHOULD>.join(' || ') } else { '' };
		my $must = do if %groups<MUST> { '( ' ~ %groups<MUST>.join(' && ') ~ ' )' } else { '' };
		my $mustNot = do if %groups<MUSTNOT> { '!( ' ~ %groups<MUSTNOT>.join(' & ') ~ ' )' } else { '' };
		my $filetype = do if %groups<FILETYPE> { '( ' ~ %groups<FILETYPE>.join(' | ') ~ ' )' } else { '' };
		my $site = do if %groups<SITE> { '( ' ~ %groups<SITE>.join(' | ') ~ ' )' } else { '' };

		my $junctMust = do if $must && $should.chars > 0 { ' && ' } else { '' };
		my $junctMustNot = do if $mustNot && $should.chars + $must.chars > 0 { ' && ' } else { '' };
		my $junctFiletype = do if $filetype && ($should, $must, $mustNot)>>.chars.sum > 0 { ' && ' } else { '' };
		my $junctSite = do if $site && ($should, $must, $mustNot, $filetype)>>.chars.sum > 0 { ' && ' } else { '' };

		$should = $should ?? '(' ~ $should ~ ')' !! '';

		make '.grep({ ' ~ $should ~ $junctMust ~ $must ~ $junctMustNot ~ $mustNot ~ $junctFiletype ~ $filetype ~ $junctSite ~ $site ~ ' })';
	}

	method query-element-spec($/) { make $/.values[0].made; }
	method query-element($/) {
		if $<query-simple-element> {
			make '$_<term> eq ' ~ $/.values[0].made;
		} else {
			make $/.values[0].made;
		}
	}

    method query-simple-element($/) { make $/.values[0].made; }
	method query-term($/) { make '\'' ~ $/.Str ~ '\''; }
	method query-phrase($/) { make $/.Str; }

	method query-should-element($/)   { make [ 'SHOULD',  $<query-element>.made ]; }
	method query-must-element($/)     { make [ 'MUST',    $<query-element>.made ]; }
	method query-must-not-element($/) { make [ 'MUSTNOT', $<query-element>.made ]; }

	method query-keyword-value-element($/) { make [ $<query-keyword>.made, '$_<' ~ $<query-keyword>.made.lc ~ '> eq ' ~ $<query-simple-element>.made ]; }
	method query-keyword($/) { make $/.values[0].made; }
	method query-field-value-element($/) { make $<query-field>.made ~ " = " ~ $<query-simple-element>.made; }
	method query-field($/) { make $/.values[0].made; }

	method filetype-noun($/) { make 'FILETYPE'; }
	method type-noun:sym<English> ($/) { make 'FILETYPE'; }
	method site-noun($/) { make 'SITE'; }
	method link-noun($/) { make 'SITE'; }
}
