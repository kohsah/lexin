xquery version "3.0";

module namespace app="http://exist-db.org/apps/lexindia/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/lexindia/config" at "config.xqm";
import module namespace api="http://exist-db.org/apps/lexindia/api" at "api.xqm";

declare namespace fao = "http://www.fao.org/ns/akn30";
declare namespace an = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/CSD13";
declare namespace xh="http://www.w3.org/1999/xhtml" ;
import module namespace functx = "http://www.functx.com";
(:~
 : This is a sample templating function. It will be called by the templating module if
 : it encounters an HTML element with an attribute: data-template="app:test" or class="app:test" (deprecated). 
 : The function has to take 2 default parameters. Additional parameters are automatically mapped to
 : any matching request or function parameter.
 : 
 : @param $node the HTML node with the attribute which triggered this call
 : @param $model a map containing arbitrary data - used to pass information between template calls
 :)
declare function app:test($node as node(), $model as map(*)) {
    <p>Dummy template output generated by function app:test at {current-dateTime()}. The templating
        function was triggered by the data-template attribute <code>data-template="app:test"</code>.</p>
};

declare function local:date-string($doc-date as xs:string)  {
    fn:day-from-date($doc-date) || " " || functx:month-name-en($doc-date) || " " || fn:year-from-date($doc-date) 
};

declare function app:lex-list($node as node(), $model as map(*)) {
    (: get only original acts :)
    let $docs := api:lex-list-latest()
    let $view-act-uri-prefix := "view-lex.html?uri="
    let $an-docs := for $doc in $docs/api:doc
                let $an-doc :=  $doc/an:akomaNtoso
                let $first-act := $an-doc[1]
                let $other-versions := subsequence($an-doc, 2)
                let $cur-url := $view-act-uri-prefix || $first-act//an:FRBRExpression/an:FRBRthis/@value
             return
             <xh:div class="law"> 
                    <xh:p>
                    <xh:a href="{$cur-url}" style="font-weight:bold"> {
                    $first-act//an:docTitle[@refersTo = '#shortTitle']/text()
                    } </xh:a><xh:br />
                    {
                    $first-act//an:docTitle[@refersTo = '#longTitle']/text()
                    } 
                    <xh:br />
                    <xh:span class="current-version" style="color:blue;"> As amended on {
                         let $doc-date := $first-act//an:FRBRExpression/an:FRBRdate/@date
                        return <xh:a 
                        href="{$cur-url}"
                         style="font-weight:bold;">{local:date-string($doc-date)}</xh:a>
                    }</xh:span> 
                      {
                        let $others-label := 
                            if (count($other-versions) gt 0) then 
                                "&#160;&#160;Prior Versions: "
                            else ""
                        return $others-label
                      }
                     {let $others :=
                         for $ver in $other-versions
                             let $ver-date := $ver//an:FRBRExpression/an:FRBRdate/@date
                             let $ver-uri := $ver//an:FRBRExpression/an:FRBRthis/@value
                            return
                            <xh:span class="other-versions" style="color:blue;"> 
                                 As on <xh:a href="{concat($view-act-uri-prefix, $ver-uri)}" style="font-weight:bold;">{local:date-string($ver-date)} </xh:a>
                             </xh:span>
                        return $others
                        }
                    </xh:p>

                </xh:div>
               
      return $an-docs
};