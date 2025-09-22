<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="2.0"
    xmlns:terms="http://dl.tufts.edu/terms#" xmlns:model="info:fedora/fedora-system:def/model#"
    xmlns:dc="http://purl.org/dc/terms/" xmlns:dc11="http://purl.org/dc/elements/1.1/"
    xmlns:tufts="http://dl.tufts.edu/terms#" xmlns:bibframe="http://bibframe.org/vocab/"
    xmlns:ebucore="http://www.ebu.ch/metadata/ontologies/ebucore/ebucore#"
    xmlns:premis="http://www.loc.gov/premis/rdf/v1#" xmlns:mads="http://www.loc.gov/mads/rdf/v1#"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:marcrelators="http://id.loc.gov/vocabulary/relators/"
    xmlns:scholarsphere="http://scholarsphere.psu.edu/ns#"
    xmlns:edm="http://www.europeana.eu/schemas/edm/" xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#">
    <!--This calls the named templates found in the following xslt(s) for parsing specific fields into approprite data for ingest  -->
    <xsl:import href="MARC_helper.xslt"/>
    <xsl:import href="Filename_helper.xslt"/>
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
                <xsl:for-each select="marc:collection/marc:record">
                    <record>
                        <metadata>
                            <mira_import>
                                <xsl:call-template name="file"/>
                                <tufts:visibility>authenticated</tufts:visibility>
                                <tufts:downloadable>no-link</tufts:downloadable>
                                <model:hasModel>Video</model:hasModel>
                                <tufts:memberOf>ks65hg19p</tufts:memberOf>
                                <xsl:call-template name="title"/>
                                <xsl:call-template name="alternative"/>
                                <xsl:call-template name="creator"/>
                                <xsl:call-template name="contributor"/>
                                <xsl:call-template name="edition"/>
                                <xsl:call-template name="physical_item_description"/>
                                <xsl:call-template name="notes"/>
                                <xsl:call-template name="toc"/>
                                <xsl:call-template name="boundwith"/>
                                <xsl:call-template name="repoduction_note"/>
                                <xsl:call-template name="provenance"/>
                                <xsl:call-template name="binding"/>
                                <xsl:call-template name="indexed_in"/>
                                <xsl:call-template name="summary"/>
                                <xsl:call-template name="isbn"/>
                                <xsl:call-template name="oclc_number"/>
                                <xsl:call-template name="language"/>
                                <xsl:call-template name="internet_archive"/>
                                <dc11:publisher/>
                                <xsl:call-template name="phys_source"/>
                                <dc:isPartOf/>
                                <xsl:call-template name="date"/>
                                <dc:created>
                                    <xsl:value-of select="current-dateTime()"/>
                                </dc:created>
                                <dc:type>MovingImage</dc:type>
                                <dc:format>application/mp4</dc:format>
                                <xsl:call-template name="persname_subject"/>
                                <xsl:call-template name="corpname_subject"/>
                                <xsl:call-template name="geo_subject"/>
                                <xsl:call-template name="topic_subject"/>
                                <xsl:call-template name="genre"/>
                                <edm:rights>http://rightsstatements.org/vocab/InC/1.0/</edm:rights>
                                <terms:steward>tisch</terms:steward>
                                <tufts:qr_note>Metadata reviewed by: smcdon03 on <xsl:value-of
                                    select="current-dateTime()"/>.</tufts:qr_note>
                                <tufts:internal_note/>
                                <terms:displays_in>dl</terms:displays_in>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="@tag" name="file">
        <tufts:filename type="representative">
                <xsl:call-template name="marc_mp4">
                    <xsl:with-param name="file"/>
                </xsl:call-template>
        </tufts:filename>
    </xsl:template>
    <xsl:template match="@tag" name="title">
        <dc:title>
            <xsl:value-of
                select="normalize-space(replace(string-join(marc:datafield[@tag = '245']/marc:subfield[matches(@code, '[abfgknps]')], ' '), '(/|:|;|,)$', ''))"
            />
        </dc:title>
    </xsl:template>
    <xsl:template match="@tag" name="alternative">
        <xsl:for-each
            select="marc:datafield[@tag = '246'][1]/marc:subfield[@code = 'a'] | marc:datafield[@tag = '240'][1]">
            <dc:alternative>
                <xsl:value-of select="normalize-space(.)"/>
            </dc:alternative>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="creator">
        <xsl:for-each
            select="marc:datafield[@tag = '100'] | marc:datafield[@tag = '110'] | marc:datafield[@tag = '111'] | marc:datafield[@tag = '130']">
            <dc11:creator>
                <xsl:call-template name="nameSelect">
                    <xsl:with-param name="delimiter">
                        <xsl:text> </xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </dc11:creator>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="contributor">
        <xsl:for-each
            select="marc:datafield[@tag = '700'] | marc:datafield[@tag = '710'] | marc:datafield[@tag = '711'] | marc:datafield[@tag = '720']">
            <dc11:contributor>
                <xsl:call-template name="nameSelect">
                    <xsl:with-param name="delimiter">
                        <xsl:text> </xsl:text>
                    </xsl:with-param>
                </xsl:call-template>
            </dc11:contributor>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="edition">
        <xsl:for-each select="marc:datafield[@tag = '250']/marc:subfield[@code = 'a']">
                    <dc11:description>
                        <xsl:value-of select="normalize-space(.)"/>
                    </dc11:description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="physical_item_description">
        <dc:extent>
            <xsl:value-of
                select="normalize-space(replace(replace(marc:datafield[@tag = '300']/replace(., '(\w )$', '$1.'), '(/|:|;|,)', '$1 '), '(\w)$', '$1.'))"
            />
        </dc:extent>
    </xsl:template>
    <xsl:template match="@tag" name="notes">
        <xsl:for-each select="marc:datafield[@tag = '500']">
            <dc11:description>
                <xsl:value-of select="normalize-space(.)"/>
            </dc11:description>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="@tag" name="boundwith">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '501'][text()]">
                <dc11:description>Bound with: <xsl:value-of
                        select="normalize-space(marc:datafield[@tag = '501']/replace(., '(MMeT.)|(MMeT)|(MMet)', ''))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="toc">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '505'][text()]">
                <xsl:for-each select="marc:datafield[@tag = '505']">
                    <dc:tableOfContents>Table of Contents: <xsl:value-of
                            select="normalize-space(.)"/>
                    </dc:tableOfContents>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="indexed_in">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '510'][text()]">
                <xsl:for-each select="marc:datafield[@tag = '510']">
                    <dc11:description>Indexed in: <xsl:value-of select="normalize-space(.)"/>
                    </dc11:description>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="summary">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '520'][text()]">
                <xsl:for-each select="marc:datafield[@tag = '520']">
                    <dc11:description>summary: <xsl:value-of select="normalize-space(.)"/>
                    </dc11:description>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="repoduction_note">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '533'][text()]">
                <dc11:description>
                    <xsl:value-of
                        select="normalize-space(replace(marc:datafield[@tag = '533']/replace(., '(MMeT.)|(MMeT)|(MMet)', ''), '(:|;|,|\.)', '$1 '))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="provenance">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '561'][text()]">
                <xsl:for-each select="marc:datafield[@tag = '561']">
                    <dc11:description>Provenance: <xsl:value-of
                            select="normalize-space(./replace(., '(MMeT.)|(MMeT)|(MMet)', ''))"/>
                    </dc11:description>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="binding">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '563'][text()]">
                <dc11:description>
                    <xsl:value-of
                        select="normalize-space(replace(./replace(marc:datafield[@tag = '563'], '(MMeT.)|(MMeT)|(MMet)', ''), '(:|;|,|\.)', '$1 '))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="isbn">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '020']/marc:subfield[@code = 'a'][text()]">
                <xsl:for-each select="marc:datafield[@tag = '020']/marc:subfield[@code = 'a']">
                    <bibframe:isbn><xsl:value-of select="normalize-space(.)"/>
                    </bibframe:isbn>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="oclc_number">
        <xsl:choose>
            <xsl:when test="marc:controlfield[@tag = '003'][text()='OCoLC']">
                <tufts:oclc><xsl:value-of select="replace(marc:controlfield[@tag = '001'],'ocm|ocn|on','')"/>
                </tufts:oclc>
            </xsl:when>
            <xsl:when test="marc:datafield[@tag = '035']/marc:subfield[@code = 'a'][starts-with(text(),'(OCoLC)')]">
                <tufts:oclc><xsl:value-of select="replace(marc:datafield[@tag = '035']/marc:subfield[@code = 'a'][starts-with(text(),'(OCoLC)')][1], '\(OCoLC\)', '')"/>
                    </tufts:oclc>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="language">
        <dc11:language>
            <xsl:value-of
                select="normalize-space(marc:controlfield[@tag = '008']/replace(., '(.{35})(\w{3}).*', '$2'))"
            />
        </dc11:language>
    </xsl:template>
    <xsl:template match="@tag" name="internet_archive">
        <xsl:choose>
            <xsl:when
                test="marc:datafield[@tag = '910']/marc:subfield[@code = 'a'][contains(text(), 'Tisch')]">
                <dc11:description>
                    <xsl:value-of
                        select="normalize-space(./replace(marc:datafield[@tag = '910']/marc:subfield[@code = 'a'][contains(text(), 'Tisch')], '.*/', ''))"
                    />
                </dc11:description>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="phys_source">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = '776'][@ind2 = '8']">
                <dc:source>
                    <xsl:value-of select="marc:datafield[@tag = '776'][1]"/>
                </dc:source>
            </xsl:when>
			<xsl:when test=".//marc:datafield[@tag = '264'][@ind2='1'][1]">
                <dc:source>Original print publication: <xsl:value-of
                    select="normalize-space(marc:datafield[@tag = '264'][@ind2='1'])"
                /></dc:source>
            </xsl:when>
            <xsl:otherwise>
                <dc:source>Original print publication: <xsl:value-of
                    select="normalize-space(marc:datafield[@tag = '260'][1])"
                /></dc:source>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="date">
        <xsl:choose>
            <xsl:when test=".//marc:datafield[@tag = '264'][@ind2='1']/marc:subfield[@code='c']">
                <dc11:date>
                    <xsl:for-each select=".//marc:datafield[@tag = '264'][@ind2='1']/marc:subfield[@code='c']">
                        <xsl:value-of select="normalize-space(replace(.,'\?|\[|\]|\.',''))"
                        />
                    </xsl:for-each>
                </dc11:date>
            </xsl:when>
            <xsl:when test=".//marc:datafield[@tag = '260']/marc:subfield[@code='c']">
                <dc11:date>
                    <xsl:for-each select=".//marc:datafield[@tag = '260']/marc:subfield[@code='c']">
                        <xsl:value-of select="normalize-space(replace(.,'\?|\[|\]|\.',''))"/>
                    </xsl:for-each> 
                </dc11:date>
            </xsl:when>     
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="persname_subject">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = 600][text()]">
                <xsl:for-each select="marc:datafield[@tag = 600]">
                    <mads:PersonalName>
                        <xsl:call-template name="nameSelect">
                            <xsl:with-param name="delimiter">
                                <xsl:text> </xsl:text>
                            </xsl:with-param>
                        </xsl:call-template>
                    </mads:PersonalName>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="corpname_subject">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = 610][text()] | marc:datafield[@tag = 611][text()]">
                <xsl:for-each select="marc:datafield[@tag = 610] | marc:datafield[@tag = 611]">
                    <mads:CorporateName>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </mads:CorporateName>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="geo_subject">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = 651][text()]">
                <xsl:for-each select="marc:datafield[@tag = 651]">
                    <dc:spatial>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc:spatial>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="topic_subject">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = 650][. != '']">
                <xsl:for-each select="marc:datafield[@tag = 650]">
                    <dc11:subject>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </dc11:subject>
                </xsl:for-each>
            </xsl:when>  
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@tag" name="genre">
        <xsl:choose>
            <xsl:when test="marc:datafield[@tag = 655][text()]">
                <xsl:for-each select="marc:datafield[@tag = '655']">
                    <mads:GenreForm>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="delimiter">--</xsl:with-param>
                        </xsl:call-template>
                    </mads:GenreForm>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
