 xquery version "3.0";


declare namespace fao = "http://www.fao.org/ns/akn30";
declare namespace an = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/CSD13";
 
    let $acts := collection("/db/apps/lexindia/docs")
 
    let $docs := $acts/an:akomaNtoso[
                    an:act[@name eq 'act']
                    ][
                    .//an:FRBRWork/an:FRBRdate/@date eq .//an:FRBRExpression/an:FRBRdate/@date
                ][not(.//an:FRBRExpression/an:FRBRVersionNumber)]
    (: for each act get versions, get latest :)   
    let $docs-in-order:= 
        <docs> {
        for $doc in $docs
            let $w-uri := $doc//an:FRBRWork/an:FRBRuri/@value
            return
                <doc> {
                for $edoc in $acts/an:akomaNtoso[.//an:FRBRWork/an:FRBRuri/@value eq $w-uri]
                    order by $edoc//an:FRBRExpression/an:FRBRdate/@date descending
                    return $edoc
                }</doc>
        } </docs>
        return $docs-in-order