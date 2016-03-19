xquery version "3.0";

module namespace api="http://exist-db.org/apps/lexindia/api";


import module namespace config="http://exist-db.org/apps/lexindia/config" at "config.xqm";


declare namespace fao = "http://www.fao.org/ns/akn30";
declare namespace an = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/CSD13";



declare function api:lex-list-latest() {
    (: get only original acts :)
    let $acts := $config:app-docs/an:akomaNtoso[
                    an:act[@name eq 'act']
                    ]
    let $docs := $acts[
                    .//an:FRBRWork/an:FRBRdate/@date eq .//an:FRBRExpression/an:FRBRdate/@date
                ][not(.//an:FRBRExpression/an:FRBRVersionNumber)]
    (: for each act get versions, get latest :)   
    let $docs-in-order:= 
        for $doc in $docs
            let $w-uri := $doc//an:FRBRWork/an:FRBRuri/@value
            return
                <api:doc> {
                for $edoc in $acts[.//an:FRBRWork/an:FRBRuri/@value eq $w-uri]
                    order by $edoc//an:FRBRExpression/an:FRBRdate/@date descending
                    return $edoc
                }</api:doc>
        
        return <api:docs count="{count($docs-in-order)}">
                 {
                    $docs-in-order
                 }
                </api:docs>
};