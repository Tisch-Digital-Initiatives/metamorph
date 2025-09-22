<?xml version="1.0" encoding="UTF-8"?>

<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2014-03-27
UPDATED ON: 2014-04-10

This stylesheet creates a template which is called in another stylsheet, and parses delimiters in subjects and names respectively for ingest into MIRA according to the data dictionary.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
    version="3.0">
    
    <!-- this portion of the XSLT creates a named template for subjects which identifies delimiters from the MARC and allows for their replacement-->
    <xsl:template name="subfieldSelect">
        <xsl:param name="codes">abcdefghijklmnopqrstuvwxyz</xsl:param>
        <xsl:param name="delimiter">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:variable name="str">
            <xsl:for-each select="marc:subfield">
                <xsl:if test="contains($codes, @code)">
                    <xsl:value-of select="text()"/>
                    <xsl:value-of select="$delimiter"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="replace(substring($str,1,string-length($str)-string-length($delimiter)), '\.$', '')"/>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for personal names which identifies delimiters from the MARC, drops the relator delimiter from output and normalizes terminal punctuation-->
    <xsl:template name="nameSelect">
        <xsl:param name="codes">abcdeqt</xsl:param>
        <xsl:param name="delimiter">
            <xsl:text> </xsl:text>
        </xsl:param>
        <xsl:variable name="str">
            <xsl:for-each select="marc:subfield">
                <xsl:if test="contains($codes, @code)">
                    <xsl:value-of select="text()"/>
                    <xsl:value-of select="$delimiter"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="replace(substring($str,1,string-length($str)-string-length($delimiter)),'\.$','')"/>
    </xsl:template>
    
</xsl:stylesheet>
