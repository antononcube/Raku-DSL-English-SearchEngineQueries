use v6;

use DSL::Shared::Roles::English::CommonParts;
use DSL::Shared::Utilities::FuzzyMatching;

# Search engine specific phrases
role DSL::English::SearchEngineQueries::Grammar::SearchPhrases
        does DSL::Shared::Roles::English::CommonParts {
    # Tokens
    token filter-verb { 'filter' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'filter') }> }
    token filetype { 'filetype' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'filetype') }> }
    token select-verb { 'select' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'select') }> }

    rule filter { <filter-verb> | <select-verb> }
}

