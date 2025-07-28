<?xml version="1.0" encoding="UTF-8"?>
<!-- Vi.*y\) finds Vicenza (Italy) -->
    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:terms="http://dl.tufts.edu/terms#"
        xmlns:model="info:fedora/fedora-system:def/model#" xmlns:dc="http://purl.org/dc/terms/"
        xmlns:dc11="http://purl.org/dc/elements/1.1/" xmlns:tufts="http://dl.tufts.edu/terms#"
        xmlns:bibframe="http://bibframe.org/vocab/"
        xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
        xmlns:premis="http://www.loc.gov/premis/rdf/v1#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
        xmlns:marcrelators="http://id.loc.gov/vocabulary/relators/"
        xmlns:scholarsphere="http://scholarsphere.psu.edu/ns#"
        xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
        xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
        >
        <!-- Output as a text file -->
        <xsl:output method="text" encoding="UTF-16"/>
        <!-- Create variables, output subjects, sort alphabeticaly, remove duplicates -->
        <xsl:variable name="creatorname">
            <xsl:for-each select="//dc11:creator">
                <xsl:sort select="self::dc11:creator"/>
                <xsl:for-each select="self::dc11:creator[not(.=following::dc11:creator)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="contribname">
            <xsl:for-each select="//dc11:contributor"> 
                <xsl:sort select="self::dc11:contributor"/>
                <xsl:for-each select="self::dc11:contributor[not(.=following::dc11:contributor)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>  
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="persname">
            <xsl:for-each select="//mads:PersonalName">
                <xsl:sort select="self::mads:PersonalName"/>
                <xsl:for-each select="self::mads:PersonalName[not(.=following::mads:PersonalName)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="corpname">
            <xsl:for-each select="//mads:CorporateName">
                <xsl:sort select="self::mads:CorporateName"/>
                <xsl:for-each select="self::mads:CorporateName[not(.=following::mads:CorporateName)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="deptname">
            <xsl:for-each select="//tufts:creator_department">
                <xsl:sort select="self::tufts:creator_department"/>
                <xsl:for-each select="self::tufts:creator_department[not(.=following::tufts:creator_department)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="geogname">
            <xsl:for-each select="//dc:spatial">
                <xsl:sort select="self::dc:spatial"/>
                <xsl:for-each select="self::dc:spatial[not(.=following::dc:spatial)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="subject">
            <xsl:for-each select="//dc11:subject">
                <xsl:sort select="self::dc11:subject"/>
                <xsl:for-each select="self::dc11:subject[not(.=following::dc11:subject)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="genre">
            <xsl:for-each select="//mads:GenreForm">
                <xsl:sort select="self::mads:GenreForm"/>
                <xsl:for-each select="self::mads:GenreForm[not(.=following::mads:GenreForm)]">
                    <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                </xsl:for-each>
            </xsl:for-each>
        </xsl:variable>
        
        <xsl:variable name="date">
            <xsl:choose>
                <xsl:when test="//terms:displays_in[contains(text(),'trove')]">
                    <xsl:for-each select=".//terms:displays_in[contains(text(),'trove')]">
                        <xsl:value-of select="replace(preceding-sibling::dc:title,'\.','')"/> has a date of: <xsl:value-of select="preceding-sibling::dc11:date"/> This should match the description field with the following date information, <xsl:value-of select="replace(preceding-sibling::dc11:description[contains(text(),'Date')],'(\w$|\W+$)','$1 &#xD;&#xD;')"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//dc11:date">
                        <xsl:sort select="self::dc11:date"/>
                        <xsl:value-of select="replace(.,'(\w$|\W$)','$1&#xD;')"/>
                    </xsl:for-each>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        
        <xsl:template match="/">             
Terms recently used
            
Names:
            Creators
            
<xsl:value-of select="$creatorname"/>
            
            Contributors

<xsl:value-of select="$contribname"/>
            
Dates:
            
<xsl:value-of select="$date"/>
                      
Subjects:

            Corporate Terms 
            
<xsl:value-of select="$corpname"/>
            
            Department Names 
            
            <xsl:value-of select="$deptname"/>

            Geographic Terms 

<xsl:value-of select="$geogname"/> 
            
            Personal names as subject
            
<xsl:value-of select="$persname"/>
            
            LCSH 

<xsl:value-of select="$subject"/>
            
            Genre Terms 
            
<xsl:value-of select="$genre"/>
        </xsl:template>
    </xsl:stylesheet>
    
