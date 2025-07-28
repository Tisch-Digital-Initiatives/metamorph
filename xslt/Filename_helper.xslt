<?xml version="1.0" encoding="UTF-8"?>

<!--    
CREATED BY: Alex May, Tisch Library
CREATED ON: 2014-07-07
UPDATED ON: 2017-04-02

This stylesheet creates a template which is called in another stylsheet, and creates a unique filename.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:dcadesc="http://nils.lib.tufts.edu/dcadesc/">
    <xsl:template match="pid"/>
    <xsl:template name="pidname">
        <xsl:param name="pid"/>
        <xsl:value-of
            select="substring-after(pid,'tufts:')"/>
        <xsl:choose>
            <xsl:when test="Format|format='application/mp4'">.mp4</xsl:when>
            <xsl:when test="Format|format='application/mp3'">.mp3</xsl:when>
            <xsl:when test="Format|format='image/tiff'">.tif</xsl:when>
            <xsl:when test="Format|format='image/jpg'">.jpg</xsl:when>
            <xsl:when test="Format|format='image/gif'">.gif</xsl:when>
            <xsl:when test="Format|format='video/quicktime'">.mov</xsl:when>
            <xsl:when test="Format|format='audio/wav'">.wav</xsl:when>
            <xsl:otherwise>.archival.pdf</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="Accession"/>
    <xsl:template name="filename">
        <xsl:param name="file"/>
        <xsl:value-of
            select="replace(normalize-space($file),'[^0-9A-Za-z.-]','_')"/>
            <xsl:choose>
            <xsl:when test="ends-with($file, '.mp4')"></xsl:when>
            <xsl:when test="ends-with($file, '.mp3')"></xsl:when>
            <xsl:when test="ends-with($file, '.tif')"></xsl:when>
            <xsl:when test="ends-with($file, '.jpg')"></xsl:when>
            <xsl:when test="ends-with($file, '.gif')"></xsl:when>
            <xsl:when test="ends-with($file, '.mov')"></xsl:when>
            <xsl:when test="ends-with($file, '.wav')"></xsl:when>
            <xsl:when test="ends-with($file, '.pdf')"></xsl:when>
            <xsl:when test="Format|format='application/mp4'">.mp4</xsl:when>
            <xsl:when test="Format|format='application/mp3'">.mp3</xsl:when>
            <xsl:when test="Format|format='image/tiff'">.tif</xsl:when>
            <xsl:when test="Format|format='image/jpg'">.jpg</xsl:when>
            <xsl:when test="Format|format='image/gif'">.gif</xsl:when>
            <xsl:when test="Format|format='video/quicktime'">.mov</xsl:when>
            <xsl:when test="Format|format='audio/wav'">.wav</xsl:when>
            <xsl:otherwise>.pdf</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="marc:datafield[@tag = '035']"/>
    <xsl:template name="archive_name">
        <xsl:param name="file"/>
        <xsl:value-of select="replace((marc:datafield[@tag = '035']/marc:subfield[@code = 'a'][starts-with(text(),'(OCoLC)')])[1], '\(OCoLC\)', '')"/>.pdf</xsl:template>
    <xsl:template name="marc_mp4">
        <xsl:param name="file"/>
        <xsl:value-of select="replace((marc:datafield[@tag = '035']/marc:subfield[@code = 'a'][starts-with(text(),'(OCoLC)')])[1], '\(OCoLC\)', '')"/>.mp4</xsl:template>
</xsl:stylesheet>
