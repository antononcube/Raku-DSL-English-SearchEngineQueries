=begin comment
#==============================================================================
#
#   Search engine queries SMRMon-R actions in Raku (Perl 6)
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
use DSL::English::SearchEngineQueries::Grammar;
use DSL::Shared::Actions::English::R::PipelineCommand;
use DSL::Shared::Actions::R::PredicateSpecification;

class DSL::English::SearchEngineQueries::Actions::R::SMRMon
        is DSL::Shared::Actions::English::R::PipelineCommand
        is DSL::Shared::Actions::R::PredicateSpecification {

	method TOP($/) { make $/.values[0].made; }

	# DSL::Shared::Actions::R::CommonStructures overwrites
	method variable-names-list($/) { make $<variable-name>>>.made.join(', '); }
	method quoted-variable-names-list($/) { make $<quoted-variable-name>>>.made.join(', '); }
	method mixed-quoted-variable-names-list($/) { make $<mixed-quoted-variable-name>>>.made.join(', '); }

	# Data load command
    method data-load-command($/)  { make $/.values[0].made; }
    method data-location-spec($/) { make $<dataset-name>.made; }
	method load-data-table($/)    { make 'SMRMonSetData( data = ' ~ $<data-location-spec>.made ~ ')'; }
    method use-data-table($/)     { make 'SMRMonSetData( data = ' ~ $<variable-name>.made ~ ')'; }
    method use-recommender($/)    { make $<variable-name>.made; }

	# Filter command
	method filter-command($/) { make 'SMRMonFilterMatrix( ' ~ $<filter-spec>.made ~ ' )'; }
	method filter-spec($/) { make $<predicates-list>.made; }

	# Search command
	method search-query-command($/) { make $/.values[0].made; }

	method query-element-spec-list($/) {
		my @pairs = $<query-element-spec>>>.made;

		my %groups =  @pairs.classify: *.[0], as => *.[1];

		my $should = do if %groups<SHOULD> { 'c( ' ~ %groups<SHOULD>.join(', ') ~ ' )' } else { 'NULL' };
		my $must = do if %groups<MUST> { 'c( ' ~ %groups<MUST>.join(', ') ~ ' )' } else { 'NULL' };
		my $mustNot = do if %groups<MUSTNOT> { 'c( ' ~ %groups<MUSTNOT>.join(', ') ~ ' )' } else { 'NULL' };

		make 'SMRMonRetrieveByQueryElements( should = ' ~ $should ~ ', must = ' ~ $must ~ ', mustNot = ' ~ $mustNot ~ ' )';
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