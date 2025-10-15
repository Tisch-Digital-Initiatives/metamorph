<?xml version="1.0" encoding="UTF-8"?>
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
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:bf2="http://bibframe.org/vocab/">
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
        <xsl:output-character character="{" string="("/>
        <xsl:output-character character="}" string=")"/>
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
                                <tufts:visibility>open</tufts:visibility>
                                <tufts:memberOf>4f16c2806</tufts:memberOf>
                                <xsl:call-template name="title"/>
                                <xsl:call-template name="creator"/>
                                <xsl:call-template name="abstract"/>
                                <xsl:call-template name="degree"/>
                                <xsl:call-template name="department"/>
                                <xsl:call-template name="advisors"/>
                                <xsl:call-template name="committee"/>
                                <xsl:call-template name="keywords"/>
                                <xsl:call-template name="institution"/>
                                <dc:isPartOf>Tufts University electronic theses and dissertations</dc:isPartOf>
                                <dc11:publisher>Tufts University Tisch Library</dc11:publisher>
                                <xsl:call-template name="date"/>
                                <dc:created>
                                    <xsl:value-of select="current-dateTime()"/>
                                </dc:created>
                                <xsl:call-template name="dcaterms_department"/>
                                <dc:type>Text</dc:type>
                                <dc:format>application/pdf</dc:format>
                                <mads:GenreForm>Tufts dissertations and theses</mads:GenreForm>
                                <mads:GenreForm>Academic theses</mads:GenreForm>
                                <terms:steward>tarc</terms:steward>
                                <tufts:qr_note>Metadata reviewed by: smcdon03 on <xsl:value-of
                                    select="current-dateTime()"/>.</tufts:qr_note>
                                <tufts:internal_note>ProquestBatchTransform: <xsl:value-of
                                    select="current-dateTime()"/>; Tisch and DCA allowed to manage metadata and binary.</tufts:internal_note>
                                <xsl:call-template name="displays"/>
                                <xsl:call-template name="embargo"/>
                            </mira_import>
                        </metadata>
                    </record>
                </xsl:for-each>
            </ListRecords>
        </OAI-PMH>
    </xsl:template>
    <xsl:template match="//DISS_binary" name="file">
        <tufts:filename type="representative">
            <xsl:value-of select="//DISS_binary"/>
        </tufts:filename>
	</xsl:template>
    <xsl:template match="//DISS_title" name="title">
        <dc:title>
            <xsl:value-of select="normalize-space(replace(//DISS_title, '\.+$', '.'))"/>
        </dc:title>
    </xsl:template>
    <xsl:template match="//DISS_author" name="creator">
        <dc11:creator>
            <xsl:value-of
                select="normalize-space(/DISS_submission/DISS_authorship/DISS_author/DISS_name/DISS_surname)"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of
                select="normalize-space(/DISS_submission/DISS_authorship/DISS_author/DISS_name/DISS_fname)"/>
        </dc11:creator>
    </xsl:template>
    <xsl:template match="//DISS_abstract" name="abstract">
        <dc:abstract>
            <xsl:value-of select="normalize-space(/DISS_submission/DISS_content/DISS_abstract)"/>
        </dc:abstract>
    </xsl:template>
    <xsl:template match="//DISS_degree" name="degree">
        <dc11:description>
            <xsl:text>Thesis (</xsl:text>
            <xsl:value-of select="normalize-space(/DISS_submission/DISS_description/DISS_degree)"/>
            <xsl:text>)--Tufts University, </xsl:text>
            <xsl:value-of select="./DISS_submission/DISS_description/DISS_dates/DISS_comp_date"/>
            <xsl:text>.</xsl:text>
        </dc11:description>
        <bf2:dissertation>
            <xsl:choose>
                <xsl:when test="/DISS_submission/DISS_description/DISS_degree[contains(text(), 'Ph.D.')]">
                    <xsl:text>Doctoral</xsl:text>
                </xsl:when>
                <xsl:when test="/DISS_submission/DISS_description/DISS_degree[contains(text(), 'D.V.M.')]">
                    <xsl:text>Doctoral</xsl:text>
                </xsl:when>
                <xsl:when test="/DISS_submission/DISS_description/DISS_degree[contains(text(), 'D.M.D.')]">
                    <xsl:text>Doctoral</xsl:text>
                </xsl:when>
                <xsl:when test="/DISS_submission/DISS_description/DISS_degree[contains(text(), 'D.P.T.')]">
                    <xsl:text>Doctoral</xsl:text>
                </xsl:when>
                <xsl:when test="/DISS_submission/DISS_description/DISS_degree[contains(text(), 'M.D.')]">
                    <xsl:text>Doctoral</xsl:text>
                </xsl:when>
                <xsl:when test="/DISS_submission/DISS_description/DISS_degree[contains(text(), 'D.P.H.')]">
                    <xsl:text>Doctoral</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Master's</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </bf2:dissertation>
    </xsl:template>
    <xsl:template match="//DISS_inst_contact[1]" name="department">
        <xsl:choose>
            <xsl:when
				test=".//DISS_inst_contact[contains(text(), 'Veterinary')]">
				<dc11:description>
					<xsl:text>Submitted to the </xsl:text>
					<xsl:value-of
						select="DISS_submission/DISS_description[1]/DISS_institution[1]/DISS_inst_contact[1]"/>
					<xsl:text>.</xsl:text>
				</dc11:description>
            </xsl:when>
            <xsl:when
				test="//DISS_inst_contact[contains(text(), 'Other')]">
				<dc11:description>
					<xsl:text>Submitted to the </xsl:text>
					<xsl:value-of
						select="DISS_submission/DISS_description[1]/DISS_institution[1]/DISS_inst_name[1]"/>
					<xsl:text>.</xsl:text>
				</dc11:description>
            </xsl:when>
            <xsl:otherwise>
				<dc11:description>
					<xsl:text>Submitted to the Dept. of </xsl:text>
					<xsl:value-of
						select="DISS_submission/DISS_description[1]/DISS_institution[1]/DISS_inst_contact[1]"/>
					<xsl:text>.</xsl:text>
				</dc11:description>
            </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    <xsl:template match="//DISS_advisor" name="advisors">
        <xsl:choose>
            <xsl:when
                test="/DISS_submission/DISS_description/DISS_advisor[not(position() = last())]/DISS_name">
                <dc11:description>
                    <xsl:text>Advisors: </xsl:text>
                    <xsl:for-each
                        select="/DISS_submission/DISS_description/DISS_advisor[not(position() = last())]/DISS_name">
                        <xsl:value-of select="normalize-space(DISS_fname)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(DISS_surname)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test="/DISS_submission/DISS_description/DISS_advisor[position() > 1][last()]/DISS_name">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_advisor[position() > 1][last()]/DISS_name/DISS_fname"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_advisor[position() > 1][last()]/DISS_name/DISS_surname"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise>
                <dc11:description>
                    <xsl:text>Advisor: </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_advisor[1]/DISS_name[1]/DISS_fname[1])"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_advisor[1]/DISS_name[1]/DISS_surname[1])"/>
                    <xsl:text>.</xsl:text>
                </dc11:description>
            </xsl:otherwise>
        </xsl:choose>
		<xsl:for-each
		    select="/DISS_submission/DISS_description/DISS_advisor/DISS_name">
		    <dc11:contributor>
                <xsl:value-of select="normalize-space(DISS_surname)"/>
                <xsl:text>, </xsl:text>
                <xsl:value-of select="normalize-space(DISS_fname)"/>
		    </dc11:contributor>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="//DISS_cmte_member" name="committee">
        <xsl:choose>
            <xsl:when
                test="/DISS_submission/DISS_description/DISS_cmte_member[not(position() = last())]/DISS_name">
                <dc11:description>
                    <xsl:text>Committee: </xsl:text>
                    <xsl:for-each
                        select="/DISS_submission/DISS_description/DISS_cmte_member[not(position() = last())]/DISS_name">
                        <xsl:value-of select="normalize-space(DISS_fname)"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="normalize-space(DISS_surname)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test="/DISS_submission/DISS_description/DISS_cmte_member[position() > 1][last()]/DISS_name">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_cmte_member[position() > 1][last()]/DISS_name/DISS_fname"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_cmte_member[position() > 1][last()]/DISS_name/DISS_surname"/>
                        <xsl:text>.</xsl:text>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:when test="/DISS_submission/DISS_description[1]/DISS_cmte_member[1]/DISS_name[1]">
                <dc11:description>
                    <xsl:text>Committee: </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_cmte_member[1]/DISS_name[1]/DISS_fname[1])"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_cmte_member[1]/DISS_name[1]/DISS_surname[1])"/>
                    <xsl:text>.</xsl:text>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_category" name="keywords">
        <xsl:choose>
            <xsl:when
                test="/DISS_submission/DISS_description/DISS_categorization/DISS_category[not(position() = last())]/DISS_cat_desc">
                <dc11:description>
                    <xsl:text>Keywords: </xsl:text>
                    <xsl:for-each
                        select="/DISS_submission/DISS_description/DISS_categorization/DISS_category[not(position() = last())]/DISS_cat_desc">
                        <xsl:value-of select="normalize-space(.)"/>
                        <xsl:text>, </xsl:text>
                    </xsl:for-each>
                    <xsl:if
                        test="/DISS_submission/DISS_description/DISS_categorization/DISS_category[position() > 1][last()]/DISS_cat_desc">
                        <xsl:text>and </xsl:text>
                        <xsl:value-of
                            select="/DISS_submission/DISS_description/DISS_categorization/DISS_category[position() > 1][last()]/DISS_cat_desc"/>
                    </xsl:if>
                </dc11:description>
            </xsl:when>
            <xsl:otherwise>
                <dc11:description>
                    <xsl:text>Keyword: </xsl:text>
                    <xsl:value-of
                        select="normalize-space(/DISS_submission/DISS_description[1]/DISS_categorization[1]/DISS_category[1]/DISS_cat_desc[1])"/>
                </dc11:description>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_inst_code" name="institution">
        <xsl:choose>
            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0930')]">
                <tufts:memberOf>9g54xz56n</tufts:memberOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0234')] and //DISS_inst_contact[contains(text(), 'Engineering')]">
                <tufts:memberOf>kw52jp30s</tufts:memberOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0234')] and //DISS_inst_contact[contains(text(), 'Veterinary')]">
                <tufts:memberOf>sj139f93n</tufts:memberOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0234')] and //DISS_inst_contact[not(contains(text(), 'Engineering'))] and
				//DISS_inst_contact[not(contains(text(), 'Veterinary'))]">
                <tufts:memberOf>6q183162k</tufts:memberOf>
            </xsl:when>
			
            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '0845')]">
                <tufts:memberOf>t722hq69n</tufts:memberOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '1546')]">
                <tufts:memberOf>th83mc242</tufts:memberOf>
            </xsl:when>

            <xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '1547')]">
                <tufts:memberOf>fj236h191</tufts:memberOf>
            </xsl:when>
			
			<xsl:when
                test="./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '2681')]">
                <tufts:memberOf>m613nc59s</tufts:memberOf>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_comp_date" name="date">
        <dc11:date>
            <xsl:value-of select="./DISS_submission/DISS_description/DISS_dates/DISS_comp_date"/>
        </dc11:date>
    </xsl:template>
    <xsl:template match="//DISS_inst_contact[1]" name="dcaterms_department">
        <xsl:choose>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Fletcher')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_contact[1][contains(text(), 'Diplomacy, History, and Politics')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'International Law and Organization')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Economics and International Business')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Global Master of Arts Program')]">
                <tufts:creator_department>Fletcher School of Law and Diplomacy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Chemistry')]">
                <tufts:creator_department>Tufts University Department of Chemistry</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Agriculture')]">
                <tufts:creator_department>Gerald J. &amp; Dorothy R. Friedman School of Nutrition Science and Policy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Art')]">
                <tufts:creator_department>Tufts University Department of the History of Art and Architecture</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Biology')]">
                <tufts:creator_department>Tufts University Department of Biology</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Biomedical Engineering')]">
                <tufts:creator_department>Tufts University Department of Biomedical Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Biological')]">
                <tufts:creator_department>Tufts University Department of Chemical and Biological Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Civil')]">
                <tufts:creator_department>Tufts University Department of Civil and Environmental Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Classics')]">
                <tufts:creator_department>Tufts University Department of Classical Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Classical')]">
                <tufts:creator_department>Tufts University Department of Classical Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Computer')]">
                <tufts:creator_department>Tufts University Department of Computer Science</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Dance')]">
                <tufts:creator_department>Tufts University Department of Theatre, Dance and Performance Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Drama')]">
                <tufts:creator_department>Tufts University Department of Theatre, Dance and Performance Studies</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Economics')]">
                <tufts:creator_department>Tufts University Department of Economics</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Education')]">
                <tufts:creator_department>Tufts University Department of Education</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Electrical')]">
                <tufts:creator_department>Tufts University Department of Electrical and Computer Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'English')]">
                <tufts:creator_department>Tufts University Department of English</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][matches(text(), 'History')]">
                <tufts:creator_department>Tufts University Department of History</tufts:creator_department>
            </xsl:when>
			<xsl:when test="//DISS_inst_contact[1][matches(text(), 'Leadership')]">
                <tufts:creator_department>Tufts University Department of Leadership</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Mathematics')]">
                <tufts:creator_department>Tufts University Department of Mathematics</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Mechanical')]">
                <tufts:creator_department>Tufts University Department of Mechanical Engineering</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Music')]">
                <tufts:creator_department>Tufts University Department of Music</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Physics')]">
                <tufts:creator_department>Tufts University Department of Physics and Astronomy</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Romance')]">
                <tufts:creator_department>Tufts University Department of Romance Languages</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Psychology')]">
                <tufts:creator_department>Tufts University Department of Psychology</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Urban')]">
                <tufts:creator_department>Tufts University Department of Urban and Environmental Policy and Planning</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Child')]">
                <tufts:creator_department>Tufts University Eliot-Pearson Department of Child Study and Human Development</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Nutrition')]">
                <tufts:creator_department>Gerald J. &amp; Dorothy R. Friedman School of Nutrition Science and Policy</tufts:creator_department>
            </xsl:when>
			<xsl:when test="//DISS_inst_contact[1][contains(text(), 'Posthodontics')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
			<xsl:when test="//DISS_inst_contact[1][contains(text(), 'Orthodontics')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
			<xsl:when test="//DISS_inst_contact[1][contains(text(), 'Periodontology')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Dental')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Dentistry')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Endodontics')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when
				test="//DISS_inst_contact[contains(text(), 'Other')] and
				./DISS_submission/DISS_description[1]/DISS_institution[1][contains(DISS_inst_code, '1547')]">
                <tufts:creator_department>Tufts University School of Dental Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Occupational')]">
                <tufts:creator_department>Tufts University Occupational Therapy Department</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Public Health')]">
                <tufts:creator_department>Tufts University Public Health and Professional Degree Programs</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Interdisciplinary')]">
                <tufts:creator_department>Tufts University Graduate School of Arts and Sciences</tufts:creator_department>
            </xsl:when>
            <xsl:when test="//DISS_inst_contact[1][contains(text(), 'Veterinary')]">
                <tufts:creator_department>Cummings School of Veterinary Medicine</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Biochemistry')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Biochemistry</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Cell')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Cell, Molecular and Developmental Biology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Cellular')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Cellular and Molecular Physiology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Translational')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Clinical and Translational Science</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Clinical Research')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Clinical Research</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Immunology')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Immunology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Genetics')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Genetics</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Microbiology')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Molecular Microbiology</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Neuroscience')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Neuroscience Program</tufts:creator_department>
            </xsl:when>
            <xsl:when
                test="//DISS_inst_name[1][contains(text(), 'Graduate School of Biomedical Sciences')] and //DISS_inst_contact[1][contains(text(), 'Pharmacology')]">
                <tufts:creator_department>Tufts Graduate School of Biomedical Sciences Department of Pharmacology and Drug Development</tufts:creator_department>
            </xsl:when>
            <xsl:otherwise>
                <tufts:creator_department>NONEFOUND</tufts:creator_department>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_comp_date" name="displays">
        <xsl:choose>
            <xsl:when test="(number(substring(//DISS_comp_date,1,4)) &lt; 2011)">
                <terms:displays_in>nowhere</terms:displays_in>
            </xsl:when>
            <xsl:otherwise>
                <terms:displays_in>dl</terms:displays_in>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="//DISS_submission" name="embargo">
        <xsl:choose>
            <xsl:when test="/DISS_submission[@embargo_code = '1']">
                <terms:embargo_release_date>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$3-')"/>
                    <xsl:value-of
                        select="(number(replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$1')) + 6)"/>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '-$2')"
                    />
                </terms:embargo_release_date>
            </xsl:when>
            <xsl:when test="/DISS_submission[@embargo_code = '2']">
                <terms:embargo_release_date>
                    <xsl:value-of
                        select="number(replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$3')) + 1"/>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '-$1-$2')"
                    />
                </terms:embargo_release_date>
            </xsl:when>
            <xsl:when test="/DISS_submission[@embargo_code = '3']">
                <terms:embargo_release_date>
                    <xsl:value-of
                        select="number(replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '$3')) + 2"/>
                    <xsl:value-of
                        select="replace(./DISS_submission/DISS_description/DISS_dates/DISS_accept_date, '(\d{2})/(\d{2})/((\d{4}))', '-$1-$2')"
                    />
                </terms:embargo_release_date>
            </xsl:when>
            <xsl:when
                test="/DISS_submission[@embargo_code = '4'] and /DISS_submission/DISS_restriction/DISS_sales_restriction[@remove = '']">
                <terms:embargo_release_date> 2999 </terms:embargo_release_date>
            </xsl:when>
            <xsl:when test="/DISS_submission[@embargo_code = '4']">
                <terms:embargo_release_date>
                    <xsl:value-of
                        select="normalize-space(replace(/DISS_submission/DISS_restriction/DISS_sales_restriction/@remove, '(\d{2})/(\d{2})/((\d{4}))', '$3-$1-$2'))"
                    />
                </terms:embargo_release_date>
            </xsl:when>
            <xsl:otherwise>
                <terms:embargo_release_date/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
