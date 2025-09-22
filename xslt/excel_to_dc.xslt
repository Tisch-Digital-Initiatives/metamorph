<?xml version="1.0" encoding="UTF-8"?>
<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2017-03-31
UPDATED ON: 2017-12-14
This stylesheet converts Excel metadata to qualified Dublin Core based on the mappings found in the MIRA data dictionary.-->
<!--Name space declarations and XSLT version -->
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
        <xsl:output-character character="&#x2013;" string="-"/>
		<xsl:output-character character="&#x2009;" string=" "/>
    </xsl:character-map>
    <!-- this starts the crosswalk-->
    <xsl:template match="/">
        <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/">
            <ListRecords>
			    <xsl:for-each select="/root/row">
                    <record>
                        <metadata>
                            <mira_import>
                                <xsl:call-template name="file"/>
                                <xsl:call-template name="visibility"/>
                                <xsl:call-template name="member"/>
                                <xsl:call-template name="has_model"/>
                                <xsl:call-template name="title"/>
                                <xsl:call-template name="alternative"/>
                                <xsl:call-template name="creator"/>
                                <xsl:call-template name="contributor"/>
                                <xsl:call-template name="description"/>
                                <xsl:call-template name="creatorDept"/>
                                <xsl:call-template name="source_bibliographicCitation"/>
                                <xsl:call-template name="bibliographicCitation"/>
                                <xsl:call-template name="is_part_of"/>
                                <dc11:publisher>Tufts University Tisch Library</dc11:publisher>
                                <xsl:call-template name="date"/>
                                <dc:created>
                                    <xsl:value-of select="current-dateTime()"/>
                                </dc:created>
                                <xsl:call-template name="type"/>
                                <xsl:call-template name="format"/>
                                <xsl:call-template name="doi"/>
                                <xsl:call-template name="isbn"/>
                                <xsl:call-template name="oclc"/>
                                <xsl:call-template name="extent"/>
                                <xsl:call-template name="intnote"/>
                                <xsl:call-template name="qrnote"/>
                                <xsl:call-template name="subject"/>
                                <xsl:call-template name="persname"/>
                                <xsl:call-template name="corpname"/>
                                <xsl:call-template name="geogname"/>
                                <xsl:call-template name="genre"/>
                                <xsl:call-template name="temporal"/>
                                <xsl:call-template name="spatial"/>
                                <xsl:call-template name="rights"/>
                                <xsl:call-template name="license"/>
                                <xsl:call-template name="tableofcontents"/>
                                <tufts:steward>tisch</tufts:steward>
                                <tufts:qr_note>Metadata reviewed by: smcdon03 on <xsl:value-of
                                        select="current-dateTime()"/>.</tufts:qr_note>
                                <xsl:call-template name="original_file_name"/>
                                <xsl:call-template name="admin_comment"/>
                                <xsl:call-template name="admin_displays"/>
                                <xsl:call-template name="embargo"/>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="Filename" name="file">
        <xsl:call-template name="FilenameSplit">
            <xsl:with-param name="FilenameText">
                <xsl:value-of select="Filename"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Process" name="visibility">
        <xsl:choose>
            <xsl:when test="Visibility = 'open'">
                <tufts:visibility>open</tufts:visibility>
            </xsl:when>
            <xsl:when test="Visibility = 'restricted'">
                <tufts:visibility>restricted</tufts:visibility>
            </xsl:when>
            <xsl:when test="Visibility = 'authenticated'">
                <tufts:visibility>authenticated</tufts:visibility>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <tufts:visibility>authenticated</tufts:visibility>
            </xsl:when>
            <xsl:otherwise>
                <tufts:visibility>open</tufts:visibility>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Process" name="member">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <tufts:memberOf>nc580m649</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Faculty')]">
                <tufts:memberOf>qz20ss48r</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Student')]">
                <tufts:memberOf>nk322d32h</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Concert')]">
                <tufts:memberOf>pv63gf62j</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Nutrition')]">
                <tufts:memberOf>p55484009</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Jordan')]">
                <tufts:memberOf>kd17d6985</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'FoodSystems')]">
                <tufts:memberOf>02871b02q</tufts:memberOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'SMFA')]">
                <tufts:memberOf>vq27zn406</tufts:memberOf>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:call-template name="memberOfSplit">
            <xsl:with-param name="memberOfText">
                <dc:alternative>
                    <xsl:value-of select="normalize-space(Member_Of)"/>
                </dc:alternative>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Format" name="has_model">
        <xsl:choose>
            <xsl:when test="Format = 'application/mp3'">
                <model:hasModel>Audio</model:hasModel>
            </xsl:when>
            <xsl:when test="Format = 'application/mp4'">
                <model:hasModel>Video</model:hasModel>
            </xsl:when>
            <xsl:when test="Format = 'image/tiff'">
                <model:hasModel>Image</model:hasModel>
            </xsl:when>
            <xsl:when test="Format = 'image/jpg'">
                <model:hasModel>Image</model:hasModel>
            </xsl:when>
                <xsl:when test="Format = 'image/gif'">
                <model:hasModel>Image</model:hasModel>
            </xsl:when>
            <xsl:when test="Format = 'video/quicktime'">
                <model:hasModel>Video</model:hasModel>
            </xsl:when>
            <xsl:when test="Format = 'audio/wav'">
                <model:hasModel>Audio</model:hasModel>
            </xsl:when>
            <xsl:otherwise>
                <model:hasModel>Pdf</model:hasModel>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Title" name="title">
        <dc:title>
            <xsl:value-of select="normalize-space(replace(replace(Title, '\.$', ''), '; ', ';'))"
            /></dc:title>
    </xsl:template>
    <xsl:template match="Alternative_Title" name="alternative">
        <xsl:call-template name="altTitleSplit">
            <xsl:with-param name="altTitleText">
                <dc:alternative>
                    <xsl:value-of
                        select="normalize-space(replace(replace(Alternative_Title, '\.$', ''), '; ', ';'))"
                    />
                </dc:alternative>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Creator" name="creator">
        <xsl:call-template name="CreatorSplit">
            <xsl:with-param name="creatorText">
                <xsl:value-of select="normalize-space(Creator)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Contributor" name="contributor">
        <xsl:call-template name="ContributorSplit">
            <xsl:with-param name="contributorText">
                <xsl:value-of select="normalize-space(Contributor)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Description" name="description">
        <xsl:call-template name="DescriptionSplit">
            <xsl:with-param name="descriptionText">
                <xsl:value-of select="normalize-space(Description)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Creator_Department" name="creatorDept">
        <xsl:choose>
            <xsl:when test="Creator_Department[contains(text(), 'Fletcher')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Diplomacy, History, and Politics')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'International Law and Organization')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Economics and International Business')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Global Master of Arts Program')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Chemistry')]">
                <tufts:creator_department>Tufts University. Department of Chemistry</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Agriculture')]">
                <tufts:creator_department>Gerald J. &amp; Dorothy R. Friedman School of Nutrition Science and Policy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Art')]">
                <tufts:creator_department>Tufts University Department of the History of Art and Architecture</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Biology')]">
                <tufts:creator_department>Tufts University Department of Biology</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Biomedical Engineering')]">
                <tufts:creator_department>Tufts University Department of Biomedical Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Biological')]">
                <tufts:creator_department>Tufts University Department of Chemical and Biological Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Civil')]">
                <tufts:creator_department>Tufts University Department of Civil and Environmental Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Classics')]">
                <tufts:creator_department>Tufts University Department of Classical Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Classical')]">
                <tufts:creator_department>Tufts University Department of Classical Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Computer')]">
                <tufts:creator_department>Tufts University Department of Computer Science</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Dance')]">
                <tufts:creator_department>Tufts University Department of Theatre, Dance and Performance Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Drama')]">
                <tufts:creator_department>Tufts University Department of Theatre, Dance and Performance Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Economics')]">
                <tufts:creator_department>Tufts University Department of Economics</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Education')]">
                <tufts:creator_department>Tufts University Department of Education</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Electrical')]">
                <tufts:creator_department>Tufts University Department of Electrical and Computer Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'English')]">
                <tufts:creator_department>Tufts University Department of English</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[matches(text(), 'History')]">
                <tufts:creator_department>Tufts University Department of History</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Mathematics')]">
                <tufts:creator_department>Tufts University Department of Mathematics</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Mechanical')]">
                <tufts:creator_department>Tufts University Department of Mechanical Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Music')]">
                <tufts:creator_department>Tufts University Department of Music</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Physics')]">
                <tufts:creator_department>Tufts University Department of Physics and Astronomy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Romance')]">
                <tufts:creator_department>Tufts University Department of Romance Languages</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Psychology')]">
                <tufts:creator_department>Tufts University Department of Psychology</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Urban')]">
                <tufts:creator_department>Tufts University Department of Urban and Environmental Policy and Planning</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Child')]">
                <tufts:creator_department>Tufts University Eliot-Pearson Department of Child Study and Human Development</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Nutrition')]">
                <tufts:creator_department>Gerald J. &amp; Dorothy R. Friedman School of Nutrition Science and Policy</tufts:creator_department>
            </xsl:when>
			<xsl:when test="Creator_Department[contains(text(), 'Posthodontics')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
			<xsl:when test="Creator_Department[contains(text(), 'Orthodontics')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
			<xsl:when test="Creator_Department[contains(text(), 'Periodontology')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Dental')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Dentistry')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Endodontics')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Occupational')]">
                <tufts:creator_department>Tufts University Occupational Therapy Department</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Public Health')]">
                <tufts:creator_department>Tufts University Public Health and Professional Degree Programs</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Interdisciplinary')]">
                <tufts:creator_department>Tufts University Graduate School of Arts and Sciences</tufts:creator_department>
            </xsl:when>
            <xsl:when test="Creator_Department[contains(text(), 'Veterinary')]">
                <tufts:creator_department>Cummings School of Veterinary Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Biochemistry')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Biochemistry</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Cell')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Cell, Molecular and Developmental Biology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Cellular')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Cellular and Molecular Physiology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Translational')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Clinical and Translational Science</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Clinical Research')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Clinical Research</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Immunology')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Immunology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Genetics')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Genetics</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Microbiology')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Molecular Microbiology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Neuroscience')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Neuroscience Program</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="Creator_Department[contains(text(), 'Pharmacology')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Pharmacology and Drug Development</tufts:creator_department>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="DOI" name="doi">
        <xsl:call-template name="doiSplit">
            <xsl:with-param name="doiText">
                <bibframe:doi>
                    <xsl:value-of select="normalize-space(DOI)"/>
                </bibframe:doi>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="ISBN" name="isbn">
        <xsl:call-template name="isbnSplit">
            <xsl:with-param name="isbnText">
                <bibframe:isbn>
                    <xsl:value-of select="normalize-space(ISBN)"/>
                </bibframe:isbn>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="OCLC" name="oclc">
        <xsl:call-template name="oclcSplit">
            <xsl:with-param name="oclcText">
                <tufts:oclc>
                    <xsl:value-of select="normalize-space(OCLC)"/>
                </tufts:oclc>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Extent" name="extent">
        <xsl:call-template name="extentSplit">
            <xsl:with-param name="extentText">
                <dc:extent>
                    <xsl:value-of select="normalize-space(Extent)"/>
                </dc:extent>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Internal_Note" name="intnote">
        <xsl:call-template name="intnoteSplit">
            <xsl:with-param name="intnoteText">
                <tufts:internal_note>
                    <xsl:value-of select="normalize-space(Internal_Note)"/>
                </tufts:internal_note>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="QR_Note" name="qrnote">
        <xsl:call-template name="qrnoteSplit">
            <xsl:with-param name="qrnoteText">
                <tufts:qr_note>
                    <xsl:value-of select="normalize-space(QR_Note)"/>
                </tufts:qr_note>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="Source" name="source_bibliographicCitation">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <dc:source>
                    <xsl:value-of select="normalize-space(Source)"/>
                </dc:source>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'SMFA')]">
                <dc:source>
                    <xsl:value-of select="normalize-space(Source)"/>
                </dc:source>
            </xsl:when>
            <xsl:otherwise>
                <dc:bibliographicCitation>
                    <xsl:value-of select="normalize-space(Source)"/>
                </dc:bibliographicCitation>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Bibliographic_Citation" name="bibliographicCitation">
        <xsl:choose>
            <xsl:when test="Bibliographic_Citation[text()]">
                <dc:bibliographicCitation>
                    <xsl:value-of select="normalize-space(Bibliographic_Citation)"/>
                </dc:bibliographicCitation>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Process" name="is_part_of">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Faculty')]">
                <dc:isPartOf>Tufts University faculty scholarship.</dc:isPartOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Nutrition')]">
                <dc:isPartOf>Tufts University faculty scholarship.</dc:isPartOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Student')]">
                <dc:isPartOf>Tufts University student scholarship.</dc:isPartOf>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'SMFA')]">
                <dc:isPartOf>Digitized books.</dc:isPartOf>
                <dc:isPartOf>SMFA Artist books.</dc:isPartOf>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
        <xsl:call-template name="partOfSplit">
            <xsl:with-param name="partOfText">
                <dc:isPartOf>
                    <xsl:value-of select="normalize-space(Is_Part_Of)"/>
                </dc:isPartOf>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Primary_Date" name="date">
        <xsl:call-template name="dateSplit">
            <xsl:with-param name="dateText">
                <xsl:value-of select="normalize-space(Primary_Date)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Process" name="type">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <dc:type>http://purl.org/dc/dcmitype/Image</dc:type>
            </xsl:when>
            <xsl:when test="Format = 'application/mp4'">
                <dc:type>http://purl.org/dc/dcmitype/MovingImage</dc:type>
            </xsl:when>
            <xsl:when test="Format = 'image/tiff'">
                <dc:type>http://purl.org/dc/dcmitype/Image</dc:type>
            </xsl:when>
            <xsl:when test="Format = 'image/jpg'">
                <dc:type>http://purl.org/dc/dcmitype/Image</dc:type>
            </xsl:when>
                <xsl:when test="Format = 'image/gif'">
                <dc:type>http://purl.org/dc/dcmitype/Image</dc:type>
            </xsl:when>
            <xsl:when test="Format = 'video/quicktime'">
                <dc:type>http://purl.org/dc/dcmitype/MovingImage</dc:type>
            </xsl:when>
            <xsl:when test="Format = 'audio/wav'">
                <dc:type>http://purl.org/dc/dcmitype/Sound</dc:type>
            </xsl:when>
            <xsl:otherwise>
                <dc:type>http://purl.org/dc/dcmitype/Text</dc:type>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Format" name="format">
        <dc:format>
            <xsl:value-of select="normalize-space(lower-case(Format))"/>
        </dc:format>
    </xsl:template>
    <xsl:template match="Subject" name="subject">
        <xsl:call-template name="SubjectSplit">
            <xsl:with-param name="subjectText">
                <xsl:value-of select="normalize-space(Subject)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Personal_Name" name="persname">
        <xsl:call-template name="persNames">
            <xsl:with-param name="persText">
                <xsl:value-of select="normalize-space(Personal_Name)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Corporate_Name" name="corpname">
        <xsl:call-template name="corpNames">
            <xsl:with-param name="corpText">
                <xsl:value-of select="normalize-space(Corporate_Name)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Geographic_Name" name="geogname">
        <xsl:call-template name="geogNames">
            <xsl:with-param name="geogText">
                <xsl:value-of select="normalize-space(Geographic_Name)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Genre" name="genre">
        <xsl:call-template name="GenreSplit">
            <xsl:with-param name="genreText">
                <xsl:value-of select="normalize-space(Genre)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Temporal" name="temporal">
        <xsl:call-template name="TemporalSplit">
            <xsl:with-param name="temporalText">
                <xsl:value-of select="normalize-space(replace(Temporal, '\..$', ''))"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Spatial" name="spatial">
        <xsl:call-template name="SpatialSplit">
            <xsl:with-param name="SpatialSplitText">
                <xsl:value-of select="normalize-space(Spatial)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="Process" name="admin_displays">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <tufts:displays_in>trove</tufts:displays_in>
            </xsl:when>
            <xsl:otherwise>
                <tufts:displays_in>dl</tufts:displays_in>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Process" name="admin_comment">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <tufts:internal_note>ArtBatchIngest: <xsl:value-of 
				select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Faculty')]">
                <tufts:internal_note>FacultyScholarshipIngest: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Student')]">
                <tufts:internal_note>StudentScholarshipIngest: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Concert')]">
                <tufts:internal_note>MusicConcertBatchTransform: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Nutrition')]">
                <tufts:internal_note>NutritionBatchTransform: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'Jordan')]">
                <tufts:internal_note>JordanBatchTransform: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'FoodSystems')]">
                <tufts:internal_note>FoodSystemsBatchTransform: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:when test="Process[contains(text(), 'SMFA')]">
                <tufts:internal_note>SMFA_ArtistBooksBatchIngest: <xsl:value-of
                        select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:when>
            <xsl:otherwise>
                <tufts:internal_note>OtherBatchIngest: <xsl:value-of 
				select="current-dateTime()"/>; Tisch manages metadata and binary.</tufts:internal_note>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Filename" name="original_file_name">
        <tufts:internal_note>Original file name: <xsl:value-of select="normalize-space(Filename)"/>
        </tufts:internal_note>
    </xsl:template>
    <xsl:template match="Rights" name="rights">
        <dc11:rights>
            <xsl:value-of select="normalize-space(Rights_Note)"/>
        </dc11:rights>
    </xsl:template>
    <xsl:template match="Embargo_Release_Date" name="embargo">
        <tufts:embargo_release_date>
            <xsl:value-of select="normalize-space(Embargo_Release_Date)"/>
        </tufts:embargo_release_date>
    </xsl:template>
    <xsl:template match="License" name="license">
        <xsl:choose>
            <xsl:when test="Process[contains(text(), 'Trove')]">
                <edm:rights>
                    https://tarc.tufts.edu/research/policies-fees/reproductions-and-use
                </edm:rights>
            </xsl:when>
            <xsl:otherwise>
                <edm:rights><xsl:value-of select="normalize-space(License)"/></edm:rights>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Table_Of_Contents" name="tableofcontents">
        <xsl:call-template name="tocSplit">
            <xsl:with-param name="tocText">
                <xsl:value-of select="normalize-space(Table_Of_Contents)"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>


