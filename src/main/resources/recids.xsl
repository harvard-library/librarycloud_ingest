<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3" version="1.0">

    <xsl:output indent="no" encoding="UTF-8" method="text"/>

    <xsl:template match="mods:modsCollection">
      <xsl:apply-templates select="mods:mods" />
    </xsl:template>

    <xsl:template match="mods:mods">
    <xsl:element name="add">
        <xsl:apply-templates select="mods:recordInfo/mods:recordIdentifier"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:recordIdentifier">
      <xsl:value-of select="."/><xsl:if test="not(position()=last())"><xsl:text>+OR+</xsl:text></xsl:if>
    </xsl:template>

    <xsl:template match="*"/>

</xsl:stylesheet>
