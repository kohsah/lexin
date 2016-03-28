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
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="an:akomaNtoso">
        <xsl:variable name="body-var" select=".//an:body"/>
        <xh:div class="tree-menu lextree" id="tree-menu">
            <xh:h2>Table of Contents</xh:h2>
            <xh:ul>
                <xh:li>
                    <xh:a href="#{$idpref}preface">Preface</xh:a>
                </xh:li>
                <xh:li>
                    <xh:a href="#{$idpref}preamble">Preamble</xh:a>
                </xh:li>
               
                    <xsl:choose>
                        <xsl:when test="$body-var/child::an:section">
                            <xsl:call-template name="toc-sections"/>       
                        </xsl:when>
                        <xsl:when test="$body-var/child::an:chapter">
                            <xsl:call-template name="toc-chapters"/>
                        </xsl:when>
                    </xsl:choose>
                
            </xh:ul>
            
        </xh:div>
        
    </xsl:template>


    <xsl:template name="toc-section">
          <xh:li>
                <xh:a href="#{$idpref}{@eId}">
                    <xsl:value-of select="an:num"/>&#160;
                    <xsl:value-of select="an:heading"/>
                </xh:a>
               <xsl:if test="./an:paragraph">
                   <xh:ul>
                    <xsl:for-each select="./an:paragraph">
                        <xsl:call-template name="toc-paragraph"/>
                    </xsl:for-each>
                  </xh:ul>
                </xsl:if>
                <xsl:if test="./an:subsection">
                   <xh:ul>
                    <xsl:for-each select="./an:subsection">
                        <xsl:call-template name="toc-subsection"/>
                    </xsl:for-each>
                  </xh:ul>
                </xsl:if>
              
            </xh:li>

    </xsl:template>
    
    <xsl:template name="toc-sections">
        
        <xsl:for-each select="/an:akomaNtoso/an:act/an:body/an:section">
            <xh:li>
                <xh:a href="#{$idpref}{@eId}">
                    <xsl:value-of select="an:num"/>&#160;
                    <xsl:value-of select="an:heading"/>
                </xh:a>
                <xsl:if test="./an:paragraph">
                    <xsl:call-template name="toc-paragraphs"/>
               </xsl:if>
                <xsl:if test="./an:subsection">
                    <xsl:call-template name="toc-subsections"/>
               </xsl:if>
                 
            </xh:li>
        </xsl:for-each>
        
    </xsl:template>
    
    <xsl:template name="toc-paragraphs">
        <xh:ul>
         <xsl:for-each select="./an:paragraph">
            <xsl:call-template name="toc-paragraph"/>
        </xsl:for-each>
        </xh:ul>
    </xsl:template>
    
     <xsl:template name="toc-subsections">
        <xh:ul>
         <xsl:for-each select="./an:subsection">
            <xsl:call-template name="toc-subsection"/>
        </xsl:for-each>
        </xh:ul>
    </xsl:template>
    
    <xsl:template name="toc-paragraph">
        <xh:li>
          <xh:a href="#{$idpref}{@eId}">
            <xsl:value-of select="an:num"/>&#160;
            <xsl:value-of select="substring(child::an:content/an:p, 1, 40)"/>
          </xh:a>
        </xh:li>
    </xsl:template>
    
      <xsl:template name="toc-subsection">
        <xh:li>
          <xh:a href="#{$idpref}{@eId}">
            <xsl:value-of select="an:num"/>&#160;
            <xsl:choose>
                <xsl:when test="child::an:content">
                     <xsl:value-of select="concat(substring(                          replace(                             normalize-space(string-join(child::an:content/an:p, ' ')),                             '^\s+|\s+$', ''                          ),                          1, 40),'..')"/>
                </xsl:when>
                <xsl:when test="child::an:intro">
                    <xsl:value-of select="                         concat(                             substring(                               replace(                                  normalize-space(string-join(child::an:intro, ' ')),                                   '^\s+|\s+$', ''                               ),                             1, 40),                             '..'                         )                         "/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('otherwise ', substring(., 1, 20))"/>
                </xsl:otherwise>
            </xsl:choose>
          </xh:a>
        </xh:li>
    </xsl:template>
    
       <xsl:template name="toc-chapters">
       
        <xsl:for-each select="/an:akomaNtoso/an:act/an:body/an:chapter">
            <xh:li>
                <xh:a href="#{$idpref}{@eId}">
                    <xsl:value-of select="an:num"/>&#160;
                    <xsl:value-of select="an:heading"/>
                </xh:a>
                <xsl:if test="an:section">
                   <xh:ul>
                    <xsl:for-each select="./an:section">
                        <xsl:call-template name="toc-section"/>            
                    </xsl:for-each>
                   </xh:ul>
                </xsl:if>
            </xh:li>
        </xsl:for-each>
        
    </xsl:template>
    
</xsl:stylesheet>