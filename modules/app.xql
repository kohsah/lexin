xquery version "3.0";

module namespace app="http://exist-db.org/apps/lexindia/templates";

import module namespace templates="http://exist-db.org/xquery/templates" ;
import module namespace config="http://exist-db.org/apps/lexindia/config" at "config.xqm";
import module namespace api="http://exist-db.org/apps/lexindia/api" at "api.xqm";

declare namespace fao = "http://www.fao.org/ns/akn30";
declare namespace an = "http://docs.oasis-open.org/legaldocml/ns/akn/3.0/CSD13";
declare namespace xh="http://www.w3.org/1999/xhtml" ;
import module namespace functx = "http://www.functx.com";
import module namespace transform="http://exist-db.org/xquery/transform";

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
                let $first-act-date := $first-act//an:FRBRExpression/an:FRBRdate/@date
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
                    <xh:span class="current-version" style="color:blue;"> Current version applicable from {
                          <xh:a 
                        href="{$cur-url}"
                         style="font-weight:bold;">{local:date-string($first-act-date)} to Today</xh:a>
                    }</xh:span> 
                      <!-- {
                        let $others-label := 
                            if (count($other-versions) gt 0) then 
                                "&#160;&#160;Prior Versions: "
                            else ""
                        return $others-label
                      } -->
                     {
                      let $others :=
                        <xh:span class="other-versions" style="color:red;"><xh:br /> Older Versions: {
                          for $ver at $ctr in $other-versions
                             let $ver-date := $ver//an:FRBRExpression/an:FRBRdate/@date
                             let $ver-uri := $ver//an:FRBRExpression/an:FRBRthis/@value
                             let $prev-date :=
                                if ($ctr eq 1) then
                                    $first-act-date
                                else
                                    $other-versions[$ctr - 1]//an:FRBRExpression/an:FRBRdate/@date
                            return
                             <xh:a href="{concat($view-act-uri-prefix, $ver-uri)}" 
                                >
                                Valid from 
                                {   local:date-string($ver-date)} to 
                                {
                                    local:date-string(fn:string(functx:previous-day($prev-date)))
                                }
                             </xh:a>
                         }</xh:span>
                         return $others
                        }
                    </xh:p>

                </xh:div>
               
      return $an-docs
};

declare function app:lex-html($node as node(), $model as map(*), $uri as xs:string) {
    let $an-doc := api:lex-by-uri($uri)
    return transform:transform(
            $an-doc,
            config:xslt("act.xsl"),
            <parameters>
                <param name="idpref" value="" />
            </parameters>
            )

};


declare function app:lex-toc($node as node(), $model as map(*), $uri as xs:string) { 
    let $an-doc := api:lex-by-uri($uri)
    return transform:transform(
            $an-doc,
            config:xslt("toc.xsl"),
            <parameters>
                <param name="idpref" value="" />
            </parameters>
    )

};

declare function app:lex-meta($node as node(), $model as map(*), $uri as xs:string) {
  ()
};


declare
function app:conditional-js($node as node(), $model as map(*)) as element(xh:script)* {
    let $request-file := tokenize(request:get-uri(), '/')[last()]
    let $timeline-file := "view-lex.html"
    return 
    if ($request-file eq $timeline-file) then
        (
        <script type="text/javascript" src="assets/js/jquery.ntm.js" />,
        <script type="text/javascript" src="assets/js/jquery.tinycarousel.js" />,
        <script type="text/javascript" src="assets/js/custom-toc.js" />
        )
        else 
        ()
};
