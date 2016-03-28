<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xh="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:an="http://docs.oasis-open.org/legaldocml/ns/akn/3.0/CSD13" exclude-result-prefixes="xs xd" version="2.0">
    <xsl:param name="idpref" select="''"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p>
                <xd:b>Created on:</xd:b> Mar 19, 2016</xd:p>
            <xd:p>
                <xd:b>Author:</xd:b> ashok</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
    <xsl:output exclude-result-prefixes="an"/>
    
    <xsl:variable name="date-format-display" select="' [MNn] [D] [Y0001]'"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="an:akomaNtoso |an:preamble | an:body">
        <xh:div class="an-{local-name()}" id="{concat($idpref, local-name(.))}"> 
            <xsl:apply-templates/>
        </xh:div>
    </xsl:template>
    
    <xsl:template match="an:preface">
        <xh:div class="an-preface" id="{concat($idpref, 'preface')}">
            <xsl:apply-templates/>
            
          <!--
            
        <xsl:call-template name="timeline-gen"/>
               -->
        </xh:div>
    </xsl:template>
    
    <xsl:template match="an:meta"/>
    
    <xsl:variable name="work-date" select="//an:FRBRWork/an:FRBRdate/@date"/>
    <xsl:variable name="expr-date" select="//an:FRBRExpression/an:FRBRdate/@date"/>
    
    <xsl:template match="an:docTitle">
        <xsl:variable name="refto" select="replace(@refersTo, '#', '')"/>
        <xh:span class="an-docTitle-refersTo-{$refto}">
            <xsl:apply-templates/>
        </xh:span>
    </xsl:template>
    
    <xsl:template match="an:num">
    </xsl:template>
    
      <xsl:template match="an:docNumber">
          <xh:span class="an-{local-name()}">
            <xsl:apply-templates/>
        </xh:span>
      </xsl:template>
    <xsl:template match="an:docDate">
        <xh:span class="an-{local-name()}">
            <xsl:apply-templates/>
        </xh:span>
        <xsl:if test="($work-date ne $expr-date)">
                <xh:br/>
                <xh:span class="an-amend-date">&#160;This version is applicable from <xsl:value-of select="format-date($expr-date, $date-format-display)"/> to Present</xh:span>
        </xsl:if>
        <xsl:if test="//an:efficacyMod[@type = 'entryIntoEfficacy']">
            <xh:br/>
            <xh:span class="efficacy">Certain parts of this law are applicable in different time periods:</xh:span>
            <xh:ul style="display:table; margin:0 auto;">
             <xsl:for-each select="//an:efficacyMod[@type = 'entryIntoEfficacy']">
                <xsl:variable name="eff-id" select="@eId"/>
                <xsl:variable name="dest" select="replace(an:destination/@href, '#','')"/>
                <xsl:variable name="period" select="replace(./@period, '#', '')"/>
                <xsl:variable name="time-inter-start" select="replace(//an:timeInterval[@eId = $period]/@start, '#', '')"/>
                <xsl:variable name="event-ref" select="//an:eventRef[@eId = $time-inter-start]"/>
                <xsl:variable name="dest-elem" select="//an:*[@eId = $dest]"/>
                <xsl:variable name="parent-dest-elem" select="$dest-elem/parent::*"/>
                <xh:li>
                
                    <xh:a href="#{$idpref}{$dest-elem/@eId}">
                    <xsl:if test="local-name($parent-dest-elem) ne 'body'">
                         <xsl:value-of select="upper-case(local-name($parent-dest-elem))"/>&#160; 
                         <xsl:value-of select="$parent-dest-elem/an:num"/>&#160; 
                    </xsl:if>
                    <xsl:value-of select="upper-case(local-name($dest-elem))"/>&#160;
                    <xsl:value-of select="$dest-elem/an:num"/>
                    </xh:a>
                    applicable from <xh:span class="fa-arrow-right fa"/>
                    <xsl:value-of select="format-date($event-ref/@date, $date-format-display)"/>
                    
                </xh:li>
            </xsl:for-each>
           </xh:ul>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="an:chapter">
        <xh:section class="an-{local-name()}">
            <xsl:if test="@eId">
                <xsl:attribute name="id">
                    <xsl:value-of select="concat($idpref, @eId)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xh:section>
    </xsl:template>
    
    
    <xsl:template name="timeline-gen">
       <xsl:if test="count(//an:eventRef) gt 0">
           <xh:div id="slider1">
		      <xh:a class="buttons prev" href="#">&lt;</xh:a>
		          <xh:div class="viewport">
		          	<xh:ul class="overview">
		          	     <xsl:for-each select="//an:eventRef">
                            <xsl:sort select="@date" order="ascending" data-type="text"/>
		          	          <xh:li>
		          	              <xsl:variable name="event_eId" select="concat('#', @eId)"/>
		          	              <xsl:variable name="timeInterval" select="//an:timeInterval[@start eq $event_eId]"/>
		          	              <xsl:if test="$timeInterval">
		          	                  <xsl:variable name="timeInterval_eId" select="$timeInterval/@eId"/>
		          	                  <xsl:variable name="event_type" select="//an:*[@period eq concat('#', $timeInterval_eId)]"/>
		          	                  <xsl:if test="$event_type">
		          	                      <xsl:value-of select="local-name($event_type)"/>
		          	                  </xsl:if>
		          	              </xsl:if>
		          	              <xsl:value-of select="                                              format-date(./@date, $date-format-display)                                              "/>
		          	          </xh:li>
		          	     </xsl:for-each>
			        </xh:ul>
		          </xh:div>
               <a class="buttons next" href="#">&gt;</a>
           </xh:div>
          </xsl:if>
    </xsl:template>

    <xsl:template name="efficacy-match">
        <xsl:param name="eff-id" select="''"/>
        <xsl:variable name="dest" select="concat('#', $eff-id)"/>
        <xsl:variable name="eff-dest" select="//an:efficacyMod/an:destination[@href = $dest ]"/>
        
        <xsl:if test="$eff-dest">
            
        </xsl:if>
    
    </xsl:template>

    
    <xsl:template match="an:section">

        <xh:section class="an-{local-name()}">
            <xsl:variable name="auto-class" select="concat('an-',local-name())"/>
            <xsl:if test="@eId">
                <xsl:attribute name="id">
                    <xsl:value-of select="concat($idpref, @eId)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:attribute name="class">
               <xsl:value-of select="concat($auto-class, ' ', @class)"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xh:section>
    </xsl:template>
    
    <xsl:template match="an:subsection | an:paragraph">
        <xh:section class="an-{local-name()}">
            <xsl:if test="@eId">
                <xsl:attribute name="id">
                    <xsl:value-of select="concat($idpref, @eId)"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </xh:section>
        
    </xsl:template>
    
    <xsl:template name="heading-with-num">
            <xsl:if test="preceding-sibling::an:num">
                 <xh:a href="{concat('#', $idpref, parent::*/@eId)}" class="item-link">
                    <xsl:value-of select="preceding-sibling::an:num"/>
                 </xh:a>
                <xsl:value-of select="'&#160;'"/>
            </xsl:if>
            <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="an:content">
       <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="an:heading[parent::an:section]">
        <xh:h2>
            <xsl:call-template name="heading-with-num"/>
        </xh:h2>
    </xsl:template>
    
    <xsl:template match="an:heading[parent::an:subsection]">
        <xh:h3>
            <xsl:call-template name="heading-with-num"/>
        </xh:h3>
    </xsl:template>
    
    <xsl:template match="an:heading[parent::an:chapter]">
        <xh:h1>
            <xsl:call-template name="heading-with-num"/>
        </xh:h1>
    </xsl:template>
    
    <xsl:template match="an:heading[parent::an:paragraph]">
        <xh:h4>
            <xsl:apply-templates/>
        </xh:h4>
    </xsl:template>
    
    <xsl:template name="common-attrs">
          <xsl:if test="@class">
                <xsl:attribute name="class">
                    <xsl:value-of select="@class"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@style">
                <xsl:attribute name="style">
                    <xsl:value-of select="@style"/>
                </xsl:attribute>
            </xsl:if>
    </xsl:template>
    
    <xsl:template match="an:b | an:u | an:i | an:sub | an:sup | an:abbr | an:span">
        <xsl:element name="xh:{local-name()}">
            <xsl:call-template name="common-attrs"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="an:p[parent::an:intro/parent::an:subsection]">
        <xh:p class="an-intro">
            <xsl:call-template name="common-attrs"/>
            <xsl:if test="parent::an:intro/preceding-sibling::an:num">
                <xh:span class="an-num">
                     <xh:a href="{concat('#', $idpref, parent::*/parent::*/@eId)}" class="item-link">
                    <xsl:value-of select="parent::an:intro/preceding-sibling::an:num"/>
                     </xh:a>
                    &#160;
                </xh:span>
            </xsl:if>
            <xsl:apply-templates/>
                  </xh:p>
    </xsl:template>
    
    <xsl:template match="an:p[not(parent::an:intro/parent::an:subsection) and not(parent::an:content)]">
        <xsl:variable name="parent-name" select="local-name(./parent::node())"/>
        <xh:p class="an-{$parent-name}-p">
            <xsl:call-template name="common-attrs"/>
            <xsl:apply-templates/>
        </xh:p>
    </xsl:template>
    
    <xsl:template match="an:p[parent::an:content and not(parent::an:content/parent::an:section)]">
        <xsl:variable name="prec-count" select="count(preceding-sibling::an:p)"/>
        <xsl:variable name="prec-num" select="parent::an:content/preceding-sibling::an:num"/>
        <xh:p class="an-content">
            <xsl:call-template name="common-attrs"/>
            <xsl:if test="$prec-count eq 0">
                <!-- first p -->
                <xsl:if test="$prec-num">
                    <xh:span class="an-num">
                         <xh:a href="{concat('#', $idpref, parent::*/parent::*/@eId)}" class="item-link">
                            <xsl:value-of select="$prec-num"/>
                         </xh:a>
                    </xh:span>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates/>
            
        </xh:p>
    </xsl:template>
     
    <xsl:template match="an:eol">
        <xh:br/>
    </xsl:template>
    
    
    
</xsl:stylesheet>