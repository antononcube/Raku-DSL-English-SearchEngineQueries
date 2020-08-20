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
#   antononcube @ gmai l . c om,
#   Windermere, Florida, USA.
#
#==============================================================================
#
#   For more details about Raku see https://raku.org/ .
#
#==============================================================================
=end comment

use v6;

use DSL::Shared::Roles::English::CommonParts;
use DSL::Shared::Roles::PredicateSpecification;
use DSL::Shared::Roles::ErrorHandling;

use DSL::English::SearchEngineQueries::Grammar::SearchPhrases;

grammar DSL::English::SearchEngineQueries::Grammar
        does DSL::Shared::Roles::ErrorHandling
        does DSL::English::SearchEngineQueries::Grammar::SearchPhrases
        does DSL::Shared::Roles::PredicateSpecification {
    # TOP
    rule TOP {
        <filter-command> |
        <search-query-command> }

    # Filter command
    rule filter-command { <filter> <.the-determiner>? <.documents>? [ <.for-which-phrase>? | <.by-preposition> ] <filter-spec> }
    rule filter-spec { <predicates-list> }

    # Search query command
    rule search-query-command { <query-element-list> }
    rule query-element-list { <query-element>+ % <.ws> }
    token query-element { <query-filetype-element> | <query-must-element> | <query-must-not-element> | <query-should-element> }
    token query-simple-element { <query-term> | <query-phrase> }
    token query-should-element { ['OR' \h+]? <query-simple-element> }
    token query-must-element { '+' <query-simple-element> | 'AND' \h+ <query-simple-element> }
    token query-must-not-element { '-' <query-simple-element> | 'NOT' \h+ <query-simple-element> }
    token keyword-separator { ':' }
    token query-filetype-element { <.filetype> <.keyword-separator> <query-simple-element> }
    token query-term { \w+ }
    token query-phrase { '"' <-["]>+ '"' | '\'' <-[']>+ '\'' }

}
