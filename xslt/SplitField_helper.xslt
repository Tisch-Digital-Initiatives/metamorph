<?xml version="1.0" encoding="UTF-8"?>
<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2014-07-07
UPDATED ON: 2014-11-22
This stylesheet creates a group of templates for normalizing data entry errors, which are called in the _RunThis xslts -->
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
    <xsl:import href="Filename_helper.xslt"/>
    
    <!-- this portion of the XSLT creates a named template for Filename (or Accession), identifies delimiters from the input file and splits them into seperate dcterms:alternative elements, 
       it also strips out any full stops-->
    <xsl:template name="FilenameSplit" match="text()">
        <xsl:param name="FilenameText" select="Accession"/>
        <xsl:if test="string-length($FilenameText)">
            <xsl:choose>
            <xsl:when test="($FilenameText = Accession)">
                <tufts:filename type="representative">
                    <xsl:call-template name="filename">
                        <xsl:with-param name="file" select="substring-before(concat($FilenameText, '|'), '|')"/>
                    </xsl:call-template>
                </tufts:filename>
            </xsl:when>
            <xsl:otherwise>
                <tufts:filename>
                    <xsl:call-template name="filename">
                        <xsl:with-param name="file" select="substring-before(concat($FilenameText, '|'), '|')"/>
                    </xsl:call-template>
                </tufts:filename>
            </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="FilenameSplit">
                <xsl:with-param name="FilenameText" select="substring-after($FilenameText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for altTitle, identifies delimiters from the input file and splits them into seperate dcterms:alternative elements, 
       it also strips out any full stops-->
    <xsl:template name="altTitleSplit" match="text()">
        <xsl:param name="altTitleText" select="."/>
        <xsl:if test="string-length($altTitleText)">
            <xsl:if test="not($altTitleText = .)"> </xsl:if>
            <dc:alternative>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($altTitleText, '|'), '|'))"
                />
            </dc:alternative>
            <xsl:call-template name="altTitleSplit">
                <xsl:with-param name="altTitleText" select="substring-after($altTitleText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for creators, identifies delimiters from the input file and splits them into seperate dc:creator elements, 
       it also ensures that each creator ends with a full stop-->
    <xsl:template name="CreatorSplit" match="text()">
        <xsl:param name="creatorText" select="."/>
        <xsl:if test="string-length($creatorText)">
            <xsl:if test="not($creatorText = .)"> </xsl:if>
            <dc11:creator>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($creatorText, '|'), '|'))"
                />
            </dc11:creator>
            <xsl:call-template name="CreatorSplit">
                <xsl:with-param name="creatorText"
                    select="substring-after($creatorText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- this portion of the XSLT creates a named template for creators, identifies delimiters from the input file and splits them into seperate dc:creator elements, 
       it also ensures that each creator ends with a full stop-->
    <xsl:template name="ContributorSplit" match="text()">
        <xsl:param name="contributorText" select="."/>
        <xsl:if test="string-length($contributorText)">
            <xsl:if test="not($contributorText = .)"> </xsl:if>
            <dc11:contributor>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($contributorText, '|'), '|'))"
                />
            </dc11:contributor>
            <xsl:call-template name="ContributorSplit">
                <xsl:with-param name="contributorText"
                    select="substring-after($contributorText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for dates, identifies delimiters from the input file and splits them into seperate dcterms date elements, 
       it also ensures that each date ends with a full stop-->
    <xsl:template name="dateSplit" match="text()">
        <xsl:param name="dateText" select="."/>
        <xsl:if test="string-length($dateText)">
            <xsl:if test="not($dateText = .)"> </xsl:if>
            <dc11:date>
                <xsl:value-of
                    select="normalize-space(replace(substring-before(concat($dateText, '|'), '|'), '\.$', ''))"
                />
            </dc11:date>
            <xsl:call-template name="dateSplit">
                <xsl:with-param name="dateText"
                    select="replace(substring-after($dateText, '|'), '([\..]$)', '')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- this portion of the XSLT splits the Description chunk into smaller bits, it also ensures each description ends in a full stop-->
    <xsl:template name="DescriptionSplit" match="text()">
        <xsl:param name="descriptionText" select="."/>
        <xsl:if test="string-length($descriptionText)">
            <xsl:if test="not($descriptionText = .)"> </xsl:if>
            <dc11:description>
                <xsl:value-of
                    select="replace(replace(replace(replace(normalize-space(replace(substring-before(concat($descriptionText, '|'), '|'), 'Description:', '')), '([\w]$)', '$1.'), '\)\.', ')'), '\.+$', '.'), '..+?X\.', '')"
                />
            </dc11:description>
            <xsl:call-template name="DescriptionSplit">
                <xsl:with-param name="descriptionText"
                    select="substring-after($descriptionText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for topic subjects, identifies delimiters from the input file and splits them into seperate dcadesc:subject elements, 
        it also normalizes spacing between headings,and ensures each term ends with either a full-stop or closing parens-->
    <xsl:template name="SubjectSplit" match="text()">
        <xsl:param name="subjectText" select="."/>
        <xsl:if test="string-length($subjectText)">
            <xsl:if test="not($subjectText = .)"> </xsl:if>
            <dc11:subject>
                <xsl:value-of
                    select="replace(replace(replace(normalize-space(replace(substring-before(concat($subjectText, '|'), '|'), '(\s\-\-\s)|(\s\-\s)|(\s\-\-)|(\-\-\s)', '--')), '([\w]$)', '$1'), '\)\.', ')'), '\.+$', '.')"
                />
            </dc11:subject>
            <xsl:call-template name="SubjectSplit">
                <xsl:with-param name="subjectText" select="substring-after($subjectText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for personal name subjects, identifies delimiters from the input file  and splits them into seperate dcadesc:persname elements, 
        it normalizes spacing between headings,and ensures each term ends with either a full-stop or closing parens-->
    <xsl:template name="persNames" match="text()">
        <xsl:param name="persText" select="."/>
        <xsl:if test="string-length($persText)">
            <xsl:if test="not($persText = .)"> </xsl:if>
            <mads:PersonalName>
                <xsl:value-of
                    select="replace(normalize-space(replace(substring-before(concat($persText, '|'), '|'), '(\s\-\-\s)|(\s\-\s)|(\s\-\-)|(\-\-\s)', '--')), '(\w)$', '$1')"
                />
            </mads:PersonalName>
            <xsl:call-template name="persNames">
                <xsl:with-param name="persText" select="substring-after($persText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for corporate name subjects which identifies delimiters from the input file allows for their replacement-->
    <xsl:template name="corpNames" match="text()">
        <xsl:param name="corpText" select="."/>
        <xsl:if test="string-length($corpText)">
            <xsl:if test="not($corpText = .)"> </xsl:if>
            <mads:CorporateName>
                <xsl:value-of
                    select="replace(replace(normalize-space(replace(substring-before(concat($corpText, '|'), '|'), '(\s\-\-\s)|(\s\-\s)|(\s\-\-)|(\-\-\s)', '--')), '([a-z]$)', '$1'), '\)\.', ')')"
                />
            </mads:CorporateName>
            <xsl:call-template name="corpNames">
                <xsl:with-param name="corpText" select="substring-after($corpText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for geographic name subjects which identifies delimiters from the input file allows for their replacement-->
    <xsl:template name="geogNames" match="text()">
        <xsl:param name="geogText" select="."/>
        <xsl:if test="string-length($geogText)">
            <xsl:if test="not($geogText = .)"> </xsl:if>
            <dc:spatial>
                <xsl:value-of
                    select="replace(replace(normalize-space(replace(substring-before(concat($geogText, '|'), '|'), '(\s\-\-\s)|(\s\-\s)|(\s\-\-)|(\-\-\s)', '--')), '([a-z]$)', '$1'), '\)\.', ')')"
                />
            </dc:spatial>
            <xsl:call-template name="geogNames">
                <xsl:with-param name="geogText" select="substring-after($geogText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT identifies pipe delimiters from the input file at 'Genre' and splits it into small bits-->
    <xsl:template name="GenreSplit" match="text()">
        <xsl:param name="genreText" select="."/>
        <xsl:if test="string-length($genreText)">
            <xsl:if test="not($genreText = .)"> </xsl:if>
            <mads:GenreForm>
                <xsl:value-of
                    select="replace(replace(normalize-space(replace(substring-before(concat($genreText, '|'), '|'), '(\s\-\-\s)|(\s\-\s)|(\s\-\-)|(\-\-\s)', '--')), '([a-z]$)', '$1'), '\)\.', ')')"
                />
            </mads:GenreForm>
            <xsl:call-template name="GenreSplit">
                <xsl:with-param name="genreText" select="substring-after($genreText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT identifies pipe delimiters from the input file at 'temporal' and splits it into small bits-->
    <xsl:template name="TemporalSplit" match="text()">
        <xsl:param name="temporalText" select="."/>
        <xsl:if test="string-length($temporalText)">
            <xsl:if test="not($temporalText = .)"> </xsl:if>
            <dc:temporal>
                <xsl:value-of
                    select="normalize-space(replace(substring-before(concat($temporalText, '|'), '|'), '\..$', ''))"
                /></dc:temporal>
            <xsl:call-template name="TemporalSplit">
                <xsl:with-param name="temporalText"
                    select="replace(substring-after($temporalText, '|'), '([\..]$)', '')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT identifies pipe delimiters from the input file at 'spatial' and splits it into small bits-->
    <xsl:template name="SpatialSplit" match="text()">
        <xsl:param name="SpatialSplitText" select="."/>
        <xsl:if test="string-length($SpatialSplitText)">
            <xsl:if test="not($SpatialSplitText = .)"> </xsl:if>
            <dc:spatial>
                <xsl:value-of
                    select="replace(normalize-space(replace(substring-before(concat($SpatialSplitText, '|'), '|'), '(\s\-\-\s)|(\s\-\s)|(\s\-\-)|(\-\-\s)', '--')), '([\w]$)', '$1')"
                />
            </dc:spatial>
            <xsl:call-template name="SpatialSplit">
                <xsl:with-param name="SpatialSplitText"
                    select="substring-after($SpatialSplitText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!--This portion of the XSLT identifies pipe delimiters from the input file at the 'AdministrativeNote' and splites it into small bits-->
    <xsl:template name="AdminNoteSplit" match="text()">
        <xsl:param name="adminText" select="."/>
        <xsl:if test="string-length($adminText)">
            <xsl:if test="not($adminText = .)"> </xsl:if>
            <tufts:internal_note>
                <xsl:value-of
                    select="normalize-space(replace(substring-before(concat($adminText, '|'), '|'), '\..$', ''))"
                />.</tufts:internal_note>
            <xsl:call-template name="AdminNoteSplit">
                <xsl:with-param name="adminText"
                    select="replace(substring-after($adminText, '|'), '([\..]$)', '')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for memberOf, identifies delimiters from the input file and splits them into seperate tufts:memberOf elements-->
    <xsl:template name="memberOfSplit" match="text()">
        <xsl:param name="memberOfText" select="."/>
        <xsl:if test="string-length($memberOfText)">
            <xsl:if test="not($memberOfText = .)"> </xsl:if>
            <tufts:memberOf>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($memberOfText, '|'), '|'))"
                />
            </tufts:memberOf>
            <xsl:call-template name="memberOfSplit">
                <xsl:with-param name="memberOfText" select="substring-after($memberOfText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for doi, identifies delimiters from the input file and splits them into seperate bibframe:doi elements-->
    <xsl:template name="doiSplit" match="text()">
        <xsl:param name="doiText" select="."/>
        <xsl:if test="string-length($doiText)">
            <xsl:if test="not($doiText = .)"> </xsl:if>
            <bibframe:doi>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($doiText, '|'), '|'))"
                />
            </bibframe:doi>
            <xsl:call-template name="doiSplit">
                <xsl:with-param name="doiText" select="substring-after($doiText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for isbn, identifies delimiters from the input file and splits them into seperate bibframe:isbn elements-->
    <xsl:template name="isbnSplit" match="text()">
        <xsl:param name="isbnText" select="."/>
        <xsl:if test="string-length($isbnText)">
            <xsl:if test="not($isbnText = .)"> </xsl:if>
            <bibframe:isbn>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($isbnText, '|'), '|'))"
                />
            </bibframe:isbn>
            <xsl:call-template name="isbnSplit">
                <xsl:with-param name="isbnText" select="substring-after($isbnText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for oclc, identifies delimiters from the input file and splits them into seperate tufts:oclc elements-->
    <xsl:template name="oclcSplit" match="text()">
        <xsl:param name="oclcText" select="."/>
        <xsl:if test="string-length($oclcText)">
            <xsl:if test="not($oclcText = .)"> </xsl:if>
            <tufts:oclc>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($oclcText, '|'), '|'))"
                />
            </tufts:oclc>
            <xsl:call-template name="oclcSplit">
                <xsl:with-param name="oclcText" select="substring-after($oclcText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for extent, identifies delimiters from the input file and splits them into seperate dc:extent elements-->
    <xsl:template name="extentSplit" match="text()">
        <xsl:param name="extentText" select="."/>
        <xsl:if test="string-length($extentText)">
            <xsl:if test="not($extentText = .)"> </xsl:if>
            <dc:extent>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($extentText, '|'), '|'))"
                />
            </dc:extent>
            <xsl:call-template name="extentSplit">
                <xsl:with-param name="extentText" select="substring-after($extentText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for intnote, identifies delimiters from the input file and splits them into seperate tufts:internal_note elements-->
    <xsl:template name="intnoteSplit" match="text()">
        <xsl:param name="intnoteText" select="."/>
        <xsl:if test="string-length($intnoteText)">
            <xsl:if test="not($intnoteText = .)"> </xsl:if>
            <tufts:internal_note>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($intnoteText, '|'), '|'))"
                />
            </tufts:internal_note>
            <xsl:call-template name="intnoteSplit">
                <xsl:with-param name="intnoteText" select="substring-after($intnoteText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for qrnote, identifies delimiters from the input file and splits them into seperate tufts:qr_note elements-->
    <xsl:template name="qrnoteSplit" match="text()">
        <xsl:param name="qrnoteText" select="."/>
        <xsl:if test="string-length($qrnoteText)">
            <xsl:if test="not($qrnoteText = .)"> </xsl:if>
            <tufts:qr_note>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($qrnoteText, '|'), '|'))"
                />
            </tufts:qr_note>
            <xsl:call-template name="qrnoteSplit">
                <xsl:with-param name="qrnoteText" select="substring-after($qrnoteText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for is_part_of, identifies delimiters from the input file and splits them into seperate dc:isPartOf elements-->
    <xsl:template name="partOfSplit" match="text()">
        <xsl:param name="partOfText" select="."/>
        <xsl:if test="string-length($partOfText)">
            <xsl:if test="not($partOfText = .)"> </xsl:if>
            <dc:isPartOf>
                <xsl:value-of
                    select="normalize-space(substring-before(concat($partOfText, '|'), '|'))"
                />
            </dc:isPartOf>
            <xsl:call-template name="partOfSplit">
                <xsl:with-param name="partOfText" select="substring-after($partOfText, '|')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    <!-- this portion of the XSLT creates a named template for Table of Contents, identifies delimiters from the input file and splits them into seperate dc:tableOfContents elements -->
    <xsl:template name="tocSplit" match="text()">
        <xsl:param name="tocText" select="."/>
        <xsl:if test="string-length($tocText)">
            <xsl:if test="not($tocText = .)"> </xsl:if>
            <dc:tableOfContents>
                <xsl:value-of
                    select="normalize-space(replace(substring-before(concat($tocText, '|'), '|'), '(\w)$', '$1.'))"
                />
            </dc:tableOfContents>
            <xsl:call-template name="tocSplit">
                <xsl:with-param name="tocText"
                    select="replace(substring-after($tocText, '|'), '([\..]$)', '')"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
