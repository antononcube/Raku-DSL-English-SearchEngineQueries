=begin comment
#==============================================================================
#
#   Search engine queries R-tidyverse actions in Raku (Perl 6)
#   Copyright (C) 2020  Anton Antonov
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
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku (Perl6) see https://raku.org/ .
#
#==============================================================================
=end comment

use v6;
use DSL::English::SearchEngineQueries::Grammar;
use DSL::English::SearchEngineQueries::Actions::R::Predicate;

unit module DSL::English::SearchEngineQueries::Actions::R::tidyverse;

class DSL::English::SearchEngineQueries::Actions::R::tidyverse
        is DSL::English::SearchEngineQueries::Actions::R::Predicate {

	method TOP($/) { make $/.values[0].made; }

	# General
	method dataset-name($/) { make $/.Str; }
	method variable-name($/) { make $/.Str; }
	method list-separator($/) { make ','; }
	method variable-names-list($/) { make $<variable-name>>>.made.join(', '); }
	method quoted-variable-names-list($/) { make $<quoted-variable-name>>>.made.join(', '); }
	method mixed-quoted-variable-names-list($/) { make $<mixed-quoted-variable-name>>>.made.join(', '); }
	method integer-value($/) { make $/.Str; }
	method number-value($/) { make $/.Str; }
	method wl-expr($/) { make $/.Str.substr(1,*-1); }
	method quoted-variable-name($/) { make $/.values[0].made; }
	method mixed-quoted-variable-name($/) { make $/.values[0].made; }
	method single-quoted-variable-name($/) { make '"' ~ $<variable-name>.made ~ '"'; }
	method double-quoted-variable-name($/) { make '"' ~ $<variable-name>.made ~ '"'; }
	
	# Trivial
	method trivial-parameter($/) { make $/.values[0].made; }
	method trivial-parameter-none($/) { make 'NA'; }
	method trivial-parameter-empty($/) { make 'c()'; }
	method trivial-parameter-automatic($/) { make 'NULL'; }
	method trivial-parameter-false($/) { make 'FALSE'; }
	method trivial-parameter-true($/) { make 'TRUE'; }

	# Data load command
    method data-load-command($/)  { make $/.values[0].made; }
    method data-location-spec($/) { make $<dataset-name>.made; }
	method load-data-table($/)    { make 'data(' ~ $<data-location-spec>.made ~ ')'; }
    method use-data-table($/)     { make $<variable-name>.made; }
    method use-recommender($/)    { make $<variable-name>.made ~ ' %>% SMRMonTakeData()'; }

	# Filter command
	method filter-command($/) { make 'dplyr::filter(' ~ $<filter-spec>.made ~ ')'; }
	method filter-spec($/) { make $<predicates-list>.made; }

	# Search command
	method search-query-command($/) { make $/.values[0].made; }

	method query-element-spec-list($/) {
		my @pairs = $<query-element-spec>>>.made;

		my %groups =  @pairs.classify: *.[0], as => *.[1];

		my $should = do if %groups<SHOULD> { ~ %groups<SHOULD>.join(' | ') } else { '' };
		my $must = do if %groups<MUST> { 'c( ' ~ %groups<MUST>.join(' & ') ~ ' )' } else { '' };
		my $mustNot = do if %groups<MUSTNOT> { '!( ' ~ %groups<MUSTNOT>.join(' & ') ~ ' )' } else { '' };

		make 'dplyr::filter(  ' ~ $should ~ ' ' ~ $must ~ ' ' ~ $mustNot ~ ' )';
	}

	method query-element-spec($/) { make $/.values[0].made; }
	method query-element($/) {
		if $<query-simple-element> {
			make $/.values[0].made;
		} else {
			make '"' ~ $/.values[0].made.subst(:g, '"', '') ~ '"';
		}
	}

    method query-simple-element($/) { make $/.values[0].made; }
	method query-term($/) { make '"' ~ $/.Str ~ '"'; }
	method query-phrase($/) { make $/.Str; }

	method query-should-element($/)   { make [ 'SHOULD',  $<query-element>.made ]; }
	method query-must-element($/)     { make [ 'MUST',    $<query-element>.made ]; }
	method query-must-not-element($/) { make [ 'MUSTNOT', $<query-element>.made ]; }

	method query-keyword-value-element($/) { make [ $<query-keyword>.made, $<query-simple-element>.made ]; }
	method query-keyword($/) { make $/.Str.uc; }

	method query-field-value-element($/) { make $<query-field>.made ~ ":" ~ $<query-simple-element>.made; }
	method query-field($/) {make $/.values[0].made; }
}