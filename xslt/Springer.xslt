<?xml version="1.0" encoding="UTF-8"?>
<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2017-03-31
UPDATED ON: 2017-11-22
This stylesheet converts Springer metadata to qualified Dublin Core based on the mappings found in the MIRA data dictionary.-->
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
    <!--This calls the named templates found in the following xslt(s) for parsing specific fields into approprite data for ingest  -->
    <xsl:import href="SplitField_helper.xslt"/>
    <xsl:import href="Filename_helper.xslt"/>
    <!--This changes the output to xml -->
    <xsl:output method="xml" indent="yes" use-character-maps="killSmartPunctuation" encoding="UTF-8"/>
    <xsl:character-map name="killSmartPunctuation">
        <xsl:output-character character="“" string="&quot;"/>
        <xsl:output-character character="”" string="&quot;"/>
        <xsl:output-character character="’" string="'"/>
        <xsl:output-character character="‘" string="'"/>
    </xsl:character-map>
    <!-- this starts the crosswalk-->
    <xsl:template match="/">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/">
            <ListRecords>
                <xsl:for-each select="document(.//doc/@href)">
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
                                <dc11:description>Springer Open.</dc11:description>
                                <dc:isPartOf>Tufts University faculty scholarship</dc:isPartOf>
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
								    <xsl:text>SpringerBatchTransform: </xsl:text>
									<xsl:value-of select="current-dateTime()"/>
                                    <xsl:text>; Tisch manages metadata and binary.</xsl:text>
                                </tufts:internal_note>
                                <tufts:displays_in>dl</tufts:displays_in>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="//JournalInfo" name="file">
        <tufts:filename type="representative"><xsl:value-of select="//JournalInfo/JournalID"/>_<xsl:value-of
                select="//RegistrationDate/Year"/>_Article_<xsl:value-of select="//ArticleID"
            />.pdf</tufts:filename>
    </xsl:template>
    <xsl:template match="//ArticleTitle" name="title">
        <dc:title>
            <xsl:value-of select="//ArticleTitle"/>
        </dc:title>
    </xsl:template>
    <xsl:template match="//AuthorGroup" name="creator">
        <xsl:variable name="authors" select=".//AuthorGroup/Author | .//AuthorGroup/InstitutionalAuthor"/>
        <xsl:choose>
            <xsl:when test="count($authors) > 25">
			    <tufts:internal_note>Article has more than 25 authors, too many to list</tufts:internal_note>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="$authors">
                    <xsl:choose>
                        <xsl:when test=".//InstitutionalAuthorName">
                            <dc11:creator>
                                <xsl:value-of select="normalize-space(.//InstitutionalAuthorName)"/>
                            </dc11:creator>
                        </xsl:when>
                        <xsl:when test=".//GivenName[2]">
                            <dc11:creator>
                                <xsl:value-of select="normalize-space(.//FamilyName)"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="normalize-space(.//GivenName[1])"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="normalize-space(replace(.//GivenName[2], '\.+$', ''))"/>
                            </dc11:creator>
                        </xsl:when>
                        <xsl:otherwise>
                            <dc11:creator>
                                <xsl:value-of select="normalize-space(.//FamilyName)"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="normalize-space(.//GivenName[1])"/>
                            </dc11:creator>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="abstract">
        <xsl:choose>
            <xsl:when test="//AbstractSection[@ID]/Heading">
                <dc:abstract>
                    <xsl:value-of select=".//AbstractSection[@ID][1]/Heading"/>: <xsl:value-of
                        select=".//AbstractSection[@ID][1]/Para[1]"/>
                </dc:abstract>
            </xsl:when>
            <xsl:when test="//Abstract/Heading">
                <dc:abstract>
                    <xsl:value-of select=".//Abstract/Heading"/>: <xsl:value-of
                        select="normalize-space(.//Abstract[1]/Para[1])"/></dc:abstract>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="keywords">
        <xsl:choose>
            <xsl:when test=".//KeywordGroup/Heading">
                <dc11:description>
                    <xsl:value-of select=".//KeywordGroup/Heading"/>: <xsl:for-each
                        select=".//Keyword[not(position() = last())]"><xsl:value-of
                            select="normalize-space(.)"/><xsl:text>, </xsl:text></xsl:for-each>
                    <xsl:if test=".//Keyword[last()]">
                        <xsl:value-of select="normalize-space(.//Keyword[last()])"/>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:when test=".//KeywordGroup">
                <dc11:description>
                    <xsl:text>Keywords: </xsl:text>
                    <xsl:for-each select=".//Keyword[not(position() = last())]">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if test=".//Keyword[last()]">
                        <xsl:value-of select="normalize-space(.//Keyword[last()])"/>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:when test=".//AbbreviationGroup">
                <dc11:description>
                    <xsl:text>Keywords: </xsl:text>
                    <xsl:for-each
                        select=".//AbbreviationGroup/DefinitionList/DefinitionListEntry[not(position() = last())]">
                        <xsl:value-of select="normalize-space(.//Para)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test=".//AbbreviationGroup/DefinitionList/DefinitionListEntry[position() = last()]">
                        <xsl:value-of
                            select="normalize-space(replace(.//AbbreviationGroup/DefinitionList/DefinitionListEntry[last()]/Description/Para, '\.+$', ''))"/>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="doi">
        <xsl:choose>
            <xsl:when test="//ArticleDOI">
                <bibframe:doi>
                    <xsl:value-of select="//ArticleDOI"/>
                </bibframe:doi>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="//AuthorGroup" name="citation">
        <dc:bibliographicCitation>
            <xsl:variable name="authors" select=".//AuthorGroup/Author | .//AuthorGroup/InstitutionalAuthor"/>
            <xsl:for-each select="$authors">
                <xsl:choose>
                    <xsl:when test="((count($authors) >5) and (position() = last()))">
                        <xsl:text>et. al.</xsl:text>
                    </xsl:when>
                    <xsl:when test="((count($authors) >5) and (position() >1))">
                    </xsl:when>
                    <xsl:when test=".//InstitutionalAuthorName">
                        <xsl:value-of select="normalize-space(.//InstitutionalAuthorName)"/>
                        <xsl:choose>
                            <xsl:when test="(position() = last()) and (not(ends-with(.//InstitutionalAuthorName, '.')))">
                                <xsl:text>.</xsl:text>
                            </xsl:when>
                            <xsl:when test="not(position() = last())">
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test=".//GivenName[2]">
                                <xsl:value-of select="normalize-space(.//GivenName[1])"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="normalize-space(.//GivenName[2])"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="normalize-space(.//FamilyName)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="normalize-space(.//GivenName[1])"/>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="normalize-space(.//FamilyName)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="(position() = last()) and (not(ends-with(.//FamilyName, '.')))">
                                <xsl:text>.</xsl:text>
                            </xsl:when>
                            <xsl:when test="not(position() = last())">
                                <xsl:text>, </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>	
            </xsl:for-each>			
            <xsl:text> "</xsl:text>
            <xsl:value-of select="//ArticleTitle"/>
            <xsl:if test="not(ends-with(//ArticleTitle, '.'))">
                <xsl:if test="not(ends-with(//ArticleTitle, '?'))">
                    <xsl:if test="not(ends-with(//ArticleTitle, '!'))">
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
            <xsl:text>" </xsl:text>
            <xsl:value-of select="//JournalTitle"/>
            <xsl:text>, </xsl:text>
            <xsl:if test="//PublisherName">
                <xsl:value-of select="//PublisherName"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="//PublisherLocation">
               <xsl:value-of select="//PublisherLocation"/>
                <xsl:text>, </xsl:text>
             </xsl:if>
            <xsl:if test="//VolumeIDStart">
                <xsl:text>v.</xsl:text>
                <xsl:value-of select="//Article//VolumeIDStart"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:if test="//IssueIDStart">
                <xsl:text>no.</xsl:text>
                <xsl:value-of select="//Article//IssueIDStart"/>
                <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="//CoverDate/Year"/>
        </dc:bibliographicCitation>
    </xsl:template>
    <xsl:template name="rights">
        <xsl:choose>
            <xsl:when test=".//ArticleCopyright/CopyrightComment/SimplePara/ExternalRef[1]/RefTarget[1]/@Address">
                <edm:rights>
                    <xsl:value-of select=".//ArticleCopyright/CopyrightComment/SimplePara/ExternalRef[1]/RefTarget[1]/@Address"/>
                </edm:rights>
            </xsl:when>
            <xsl:otherwise>
                <edm:rights>
                    <xsl:value-of select=".//License/SimplePara/ExternalRef[1]/RefTarget[1]/@Address"/>
                </edm:rights>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//OnlineDate/Year" name="date">
        <dc11:date>
            <xsl:value-of select=".//OnlineDate/Year"/>
        </dc11:date>
    </xsl:template>
</xsl:stylesheet>
