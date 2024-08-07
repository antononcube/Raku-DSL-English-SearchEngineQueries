=begin comment
#==============================================================================
#
#   Search engine queries grammar in Raku
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
#   For more details about Raku see https://raku.org/ .
#
#==============================================================================
=end comment

use v6.d;

use DSL::Shared::Roles::PredicateSpecification;
use DSL::Shared::Roles::ErrorHandling;

use DSL::English::SearchEngineQueries::Grammar::SearchPhrases;
use DSL::English::SearchEngineQueries::Grammar::SearchQueryCommand;
use DSL::English::SearchEngineQueries::Grammarish;

grammar DSL::English::SearchEngineQueries::Grammar
        does DSL::English::SearchEngineQueries::Grammarish
        does DSL::English::SearchEngineQueries::Grammar::SearchQueryCommand
        does DSL::English::SearchEngineQueries::Grammar::SearchPhrases
        does DSL::Shared::Roles::ErrorHandling
        does DSL::Shared::Roles::PredicateSpecification {

}
