<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
  xmlns:terms="http://dl.tufts.edu/terms#"
  xmlns:model="info:fedora/fedora-system:def/model#"
  xmlns:dc="http://purl.org/dc/terms/"
  xmlns:dc11="http://purl.org/dc/elements/1.1/"
  xmlns:tufts="http://dl.tufts.edu/terms#"
  xmlns:bibframe="http://bibframe.org/vocab/"
  xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
  xmlns:premis="http://www.loc.gov/premis/rdf/v1#"
  xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
  xmlns:marcrelators="http://id.loc.gov/vocabulary/relators/"
  xmlns:scholarsphere="http://scholarsphere.psu.edu/ns#"
  xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
  
  <xsl:output method="xml" indent="yes" use-character-maps="killSmartPunctuation" encoding="UTF-8"/>
  <xsl:character-map name="killSmartPunctuation">
    <xsl:output-character character="“" string="&quot;"/>
    <xsl:output-character character="”" string="&quot;"/>
    <xsl:output-character character="’" string="'"/>
    <xsl:output-character character="‘" string="'"/>
    <xsl:output-character character="&#x2013;" string="-"/>
	<xsl:output-character character="&#x2009;" string=" "/>
  </xsl:character-map>
  
  <!-- identity transform: -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
 
  <xsl:template match="mads:GenreForm">
    <mads:GenreForm><xsl:value-of select="concat(upper-case(substring(.,1,1)),
      substring(., 2),
      ' '[not(last())]
      )"/></mads:GenreForm>
  </xsl:template>
  
  <xsl:template match="dc:publisher">
    <dc:publisher>Digital Collections and Archives, Tufts University.</dc:publisher> 
  </xsl:template>
  
  <xsl:template match="tufts:steward">
    <tufts:steward>dca</tufts:steward>
  </xsl:template>
  
  <xsl:template match="tufts:displays_in">
    <tufts:displays_in>dl</tufts:displays_in>
  </xsl:template>
  
  <!-- Specific to Great Courses
  <xsl:template match="local:visibility">
    <xsl:choose>
      <xsl:when test="preceding::dc:title[contains(text(),'Slides')]">
        <local:visibility>authenticated</local:visibility>
      </xsl:when>
      <xsl:otherwise>
        <local:visibility>open</local:visibility>
      </xsl:otherwise>
    </xsl:choose>  
  </xsl:template>
  -->
  
</xsl:stylesheet>
