
role DSL::English::SearchEngineQueries::Grammar::SearchQueryCommand {
    # Search query command
    rule search-query-command { <query-element-spec-list> }

    rule query-element-spec-list { <query-element-spec>+ % <.ws> }
    token query-element-spec { <query-keyword-value-element> | <query-must-element> | <query-must-not-element> | <query-should-element> }

    token query-element { <query-simple-element> | <query-field-value-element> }

    token query-simple-element { <query-term> | <query-phrase> }
    token query-term { <variable-name> }
    token query-phrase { '"' <-["]>+ '"' | '\'' <-[']>+ '\'' }

    token query-should-element { ['OR' \h+]? <query-element> }
    token query-must-element { '+' <query-element> | 'AND' \h+ <query-element> }
    token query-must-not-element { '-' <query-element> | 'NOT' \h+ <query-element> }

    token query-keyword-value-separator { ':' }
    token query-keyword-value-element { <query-keyword> <.query-keyword-value-separator> <query-simple-element> }
    token query-keyword { <filetype-noun> | <link-noun> | <site-noun> }

    token query-field-value-separator { ':' }
    token query-field-value-element { <query-field> <.query-field-value-separator> <query-simple-element> }
    token query-field { <query-simple-element> }
}

