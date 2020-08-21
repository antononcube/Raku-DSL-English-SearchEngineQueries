use v6;

use DSL::Shared::Roles::English::CommonParts;
use DSL::Shared::Utilities::FuzzyMatching;

# Search engine specific phrases
role DSL::English::SearchEngineQueries::Grammar::SearchPhrases
        does DSL::Shared::Roles::English::CommonParts {
    # Tokens
    token filetype-noun { 'filetype' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'filetype') }> }
    token filter-verb { 'filter' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'filter') }> }
    token link-noun { 'link' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'link') }> }
    token recommender { 'recommender' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'recommender') }> }
    token select-verb { 'select' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'select') }> }
    token site-noun { 'site' | ([\w]+) <?{ is-fuzzy-match( $0.Str, 'site') }> }

    rule filter { <filter-verb> | <select-verb> }
    rule recommender-object { <recommender> [ <object> | <system> ]? | 'smr' }
}

