<?xml version="1.0" encoding="UTF-8"?>
<!--    
CREATED BY: Steve McDonald, Tisch Library
CREATED ON: 2022-12-12
This stylesheet converts ACM metadata to qualified Dublin Core based on the mappings found in the MIRA data dictionary.-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    xmlns:terms="http://dl.tufts.edu/terms#" xmlns:model="info:fedora/fedora-system:def/model#"
    xmlns:dc="http://purl.org/dc/terms/" xmlns:dc11="http://purl.org/dc/elements/1.1/"
    xmlns:tufts="http://dl.tufts.edu/terms#" xmlns:bibframe="http://bibframe.org/vocab/"
    xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
    xmlns:premis="http://www.loc.gov/premis/rdf/v1#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
    xmlns:marcrelators="http://id.loc.gov/vocabulary/relators/"
    xmlns:scholarsphere="http://scholarsphere.psu.edu/ns#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
    <!--This changes the output to xml -->
    <xsl:output method="xml" indent="yes" use-character-maps="killSmartPunctuation" encoding="UTF-8"/>
    <xsl:character-map name="killSmartPunctuation">
        <xsl:output-character character="“" string="&quot;"/>
        <xsl:output-character character="”" string="&quot;"/>
        <xsl:output-character character="’" string="'"/>
        <xsl:output-character character="‘" string="'"/>
        <xsl:output-character character="&#x2013;" string="-"/>
		<xsl:output-character character="&#x2009;" string=" "/>
    </xsl:character-map>
    <!-- this starts the crosswalk-->
    <xsl:template match="/">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/">
            <ListRecords>
                <record>
                    <metadata>
                        <mira_import>
                            <xsl:call-template name="file"/>
                            <model:hasModel>Pdf</model:hasModel>
                            <tufts:memberOf>qz20ss48r</tufts:memberOf> 
                            <tufts:visibility>open</tufts:visibility>
                            <xsl:call-template name="title"/>
                            <xsl:call-template name="creator"/>
                            <xsl:call-template name="abstract"/>
                            <xsl:call-template name="keywords"/>
                            <xsl:call-template name="topic"/>
                            <dc11:description>ACM Open.</dc11:description>
                            <dc11:publisher>Tufts University Tisch Library</dc11:publisher>
                            <xsl:call-template name="doi"/>
                            <xsl:call-template name="citation"/>
                            <xsl:call-template name="rights"/>
                            <xsl:call-template name="date"/>
                            <dc:created>
                                <xsl:value-of select="current-dateTime()"/>
                            </dc:created>
                            <dc:type>Text</dc:type>
                            <dc:format>application/pdf</dc:format>
                            <tufts:steward>tisch</tufts:steward>
                            <tufts:qr_note>smcdon03</tufts:qr_note>
                            <tufts:internal_note>
                                <xsl:text>ACMBatchTransform: </xsl:text>
                                <xsl:value-of select="current-dateTime()"/>
                                <xsl:text>; Tisch manages metadata and binary.</xsl:text>
                            </tufts:internal_note>
                            <tufts:displays_in>dl</tufts:displays_in>
                        </mira_import>
                    </metadata>
                </record>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template name="file">
        <xsl:choose>
            <xsl:when test="//book-id">
                <tufts:filename type="representative">
                    <xsl:value-of select="//book-id[@book-id-type='acm-id']"/>
                    <xsl:text>.</xsl:text>
                    <xsl:value-of select="//book-part-id[@book-part-id-type='acm-id']"/>
                    <xsl:text>.pdf</xsl:text>
                </tufts:filename>
            </xsl:when>
            <xsl:when test="//article-id">
                <tufts:filename type="representative">
                    <xsl:value-of select="//article-id[@pub-id-type='acm-id']"/>
                    <xsl:text>.pdf</xsl:text>
                </tufts:filename>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="title">
        <xsl:choose>
            <xsl:when test="//book-part/book-part-meta//title">
                <dc:title>
                    <xsl:value-of select="//book-part/book-part-meta//title"/>
                </dc:title>
            </xsl:when>
            <xsl:when test="//article-meta//article-title">
                <dc:title>
                    <xsl:value-of select="//article-meta//article-title"/>
                </dc:title>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//contrib-group" name="creator">
        <xsl:choose>
            <xsl:when test="count(.//contrib[@contrib-type='author']) > 25">
			    <tufts:internal_note>Article has more than 25 authors, too many to list</tufts:internal_note>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select=".//contrib[@contrib-type='author']">
                    <dc11:creator>
                        <xsl:value-of select="normalize-space(.//name/surname)"/>
                        <xsl:text>, </xsl:text>
                        <xsl:value-of select="normalize-space(.//name/given-names)"/>
                    </dc11:creator>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>				
    </xsl:template>
    <xsl:template match="//abstract" name="abstract">
        <dc11:abstract>
            <xsl:value-of select=".//abstract/p[1]"/>
        </dc11:abstract>
    </xsl:template>
    <xsl:template match="//kwd-group" name="keywords">
        <dc11:description>
            <xsl:text>Keywords: </xsl:text>
            <xsl:for-each select=".//kwd[not(position() = last())]">
                <xsl:value-of select="replace(normalize-space(.), '~', '; ')"/>
                <xsl:text>, </xsl:text>
            </xsl:for-each>
            <xsl:if test=".//kwd[last()]">
                <xsl:value-of select="normalize-space(.//kwd[last()])"/>
            </xsl:if>
        </dc11:description>
    </xsl:template>
    <xsl:template match="//subj-group" name="topic">
        <xsl:for-each select=".//subj-group[@subj-group-type='ccs2012']/compound-subject/compound-subject-part[@content-type='text']">
		    <dc11:description>
                <xsl:text>Topic: </xsl:text>
                <xsl:value-of select="replace(normalize-space(.), '~', ' / ')"/>
		    </dc11:description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="doi">
        <xsl:choose>
            <xsl:when test="//book-part-id">
                <bibframe:doi>
                    <xsl:value-of select="//book-part-id[@book-part-id-type='doi']"/>
                </bibframe:doi>
            </xsl:when>
            <xsl:when test="//article-id">
                <bibframe:doi>
                    <xsl:value-of select="//article-id[@pub-id-type='doi']"/>
                </bibframe:doi>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="citation">
        <dc:bibliographicCitation>
            <xsl:choose>
                <xsl:when test="count(.//contrib) > 5">
                    <xsl:value-of select="//contrib[1]/name/given-names"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="//contrib[1]/name/surname"/>
                    <xsl:text>, et. al.</xsl:text>   
                </xsl:when>
				<xsl:when test="count(//contrib) = 1">
                    <xsl:value-of select="//contrib/name/given-names"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="//contrib/name/surname"/>                    				    
                    <xsl:if test="not(ends-with(//contrib/name/surname, '.'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
				</xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="//contrib[not(position() = last())]">
                        <xsl:value-of select="./name/given-names"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="./name/surname"/>
                        <xsl:text>, </xsl:text>                        
                    </xsl:for-each>
                    <xsl:if test="//contrib[last()]">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of select="//contrib[last()]/name/given-names"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="//contrib[last()]/name/surname"/>
                        <xsl:if test="not(ends-with(//contrib[last()]/name/surname, '.'))">
                            <xsl:text>.</xsl:text>
                        </xsl:if>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> "</xsl:text>
            <xsl:choose>
                <xsl:when test="//book-part/book-part-meta//title">
                    <xsl:value-of select="//book-part/book-part-meta//title"/>
                    <xsl:if test="not(ends-with(//book-part/book-part-meta//title, '.'))">
                        <xsl:if test="not(ends-with(//book-part/book-part-meta//title, '?'))">
                            <xsl:if test="not(ends-with(//book-part/book-part-meta//title, '!'))">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:when>
                <xsl:when test="//article-meta//article-title">
                    <xsl:value-of select="//article-meta//article-title"/>
                    <xsl:if test="not(ends-with(//article-meta//article-title, '.'))">
                        <xsl:if test="not(ends-with(//article-meta//article-title, '?'))">
                            <xsl:if test="not(ends-with(//article-meta//article-title, '!'))">
                                <xsl:text>.</xsl:text>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
            <xsl:text>" </xsl:text>
            <xsl:choose>
                <xsl:when test="//book-title">
                    <xsl:value-of select="//book-title"/>
                </xsl:when>
                <xsl:when test="//journal-title">
                    <xsl:value-of select="//journal-title"/>
                </xsl:when>
            </xsl:choose>
            <xsl:text>, </xsl:text>
            <xsl:if test="//publisher/publisher-name">
                <xsl:value-of select="//publisher/publisher-name[1]"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="//publisher/publisher-loc">
               <xsl:value-of select="//publisher/publisher-loc"/>
                <xsl:text>, </xsl:text>
             </xsl:if>
            <xsl:if test="//article-meta/volume">
                <xsl:value-of select="//article-meta/volume"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="//article-meta/issue">
                <xsl:value-of select="//article-meta/issue"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="//pub-date/year"/>
        </dc:bibliographicCitation>
    </xsl:template>
    <xsl:template match="//permissions" name="rights">
        <dc11:rights>
            <xsl:value-of select=".//license-p"/>
        </dc11:rights>
        <xsl:choose>
            <xsl:when test="//license[@license-type='acmcopyright']">
                <edm:rights>http://rightsstatements.org/vocab/InC/1.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[@license-type='acmlicensed']">
                <edm:rights>http://rightsstatements.org/vocab/InC/1.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[@license-type='rightsretained']">
                <edm:rights>http://rightsstatements.org/vocab/InC/1.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc by']">
                <edm:rights>http://creativecommons.org/licenses/by/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc by sa']">
                <edm:rights>http://creativecommons.org/licenses/by-sa/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc bysa']">
                <edm:rights>http://creativecommons.org/licenses/by-sa/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc by nd']">
                <edm:rights>http://creativecommons.org/licenses/by-nd/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc bynd']">
                <edm:rights>http://creativecommons.org/licenses/by-nd/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc by nc']">
                <edm:rights>http://creativecommons.org/licenses/by-nc/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc bync']">
                <edm:rights>http://creativecommons.org/licenses/by-nc/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc by nc sa']">
                <edm:rights>http://creativecommons.org/licenses/by-nc-sa/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc byncsa']">
                <edm:rights>http://creativecommons.org/licenses/by-nc-sa/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc by nc nd']">
                <edm:rights>http://creativecommons.org/licenses/by-nc-nd/4.0/</edm:rights>
            </xsl:when>
            <xsl:when test="//license[replace(@license-type, '-', ' ')='cc byncnd']">
                <edm:rights>http://creativecommons.org/licenses/by-nc-nd/4.0/</edm:rights>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//pub-date" name="date">
        <dc11:date>
            <xsl:value-of select=".//pub-date/year"/>
        </dc11:date>
    </xsl:template>
</xsl:stylesheet>
