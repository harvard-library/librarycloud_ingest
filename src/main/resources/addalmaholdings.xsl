<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs mods"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:urlinfo="http://lib.harvard.edu/urlinfo" version="2.0"
    >

    <xsl:output indent="no" omit-xml-declaration="yes" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>

    <xsl:param name="param1"><holdings/></xsl:param>

    <xsl:template match="@*|node()">
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="mods:modsCollection">
        <mods:modsCollection>
            <xsl:apply-templates/>
        </mods:modsCollection>
    </xsl:template>


    <xsl:template match="mods:mods">
        <xsl:copy>
            <xsl:apply-templates select="*" />
            <xsl:variable name="holdings" select="$param1"/>
             <!--<xsl:variable name="holdings" select="document('')//xsl:param[@name='param1']//holdings"/>-->
            <xsl:variable name="hollisid"><xsl:value-of select="./mods:recordInfo/mods:recordIdentifier"/></xsl:variable>

<!--             <xsl:message>HollisID:(<xsl:value-of select="$hollisid"/>)</xsl:message>
            <xsl:message>Comparing to:(<xsl:value-of select="$holdings//doc/str[@name='originalMarc']/marc:record/marc:controlfield[@tag='001']" />)</xsl:message>

            <xsl:message><xsl:copy-of select="$holdings//doc/str[@name='originalMarc']/marc:record/marc:controlfield[@tag='001']" /></xsl:message>
<xsl:message>Three</xsl:message>
            <xsl:message><xsl:copy-of select="$holdings//doc/str[@name='originalMarc']/marc:record[marc:controlfield[@tag='001']=$hollisid]" /></xsl:message>
 -->

            <xsl:for-each select="$holdings//doc/str[@name='originalMarc']/marc:record[marc:controlfield[@tag='001']=$hollisid]">
                <xsl:element name="location" namespace="http://www.loc.gov/mods/v3">

                        <!-- <xsl:apply-templates select="./str[@name='originalMarc']"/> -->
                        <xsl:apply-templates select="./marc:datafield[@tag='852']"/>
                        <xsl:apply-templates select="./marc:datafield[@tag='843']"/>
                        <xsl:apply-templates select="./marc:datafield[@tag='856']"/>

                 </xsl:element>
            </xsl:for-each>

        </xsl:copy>
    </xsl:template>

<!--     <xsl:template match="str[@name='originalMarc']">

        <xsl:message>In template 1</xsl:message>

        <xsl:apply-templates select="./marc:record/marc:datafield[@tag='852']"/>
        <xsl:apply-templates select="./marc:record/marc:datafield[@tag='843']"/>
        <xsl:apply-templates select="./marc:record/marc:datafield[@tag='856']"/>
    </xsl:template>
 -->
    <xsl:template match="marc:datafield[@tag='852']">

        <xsl:if test="./marc:subfield[@code='b']">

                <xsl:choose>
                    <xsl:when test="./marc:subfield[@code='b']='MMF'"/>
                    <xsl:when test="./marc:subfield[@code='b']='NET'"/>
                    <xsl:otherwise>
                        <xsl:element name="physicalLocation" namespace="http://www.loc.gov/mods/v3">
                        <xsl:attribute name="type">
                            <xsl:text>repository</xsl:text>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="./marc:subfield[@code='b']='DIV'">Andover-Harvard Theological Library, Harvard Divinity School, Harvard University</xsl:when>
                            <xsl:when test="./marc:subfield[@code='b']='BAK'">Baker Library Historical Collections, Harvard Business School, Harvard University</xsl:when>
                            <xsl:when test="./marc:subfield[@code='b']='HUA'">Harvard University Archives</xsl:when>
                            <xsl:when test="./marc:subfield[@code='b']='SCH'">Arthur and Elizabeth Schlesinger Library on the History of Women in America, Radcliffe Institute for Advanced Study, Harvard University</xsl:when>
                            <xsl:when test="./marc:subfield[@code='b']='MED'">Center for the History of Medicine (Francis A. Countway Library of Medicine)</xsl:when>
                            <xsl:when test="./marc:subfield[@code='b']='LAW'">Harvard Law School Library, Harvard Library, Harvard University</xsl:when>
                            <xsl:when test="./marc:subfield[@code='b']='HOU'">Houghton Library, Harvard Library, Harvard University</xsl:when>
                            <xsl:otherwise><xsl:value-of select="./marc:subfield[@code='b']"/></xsl:otherwise>
                        </xsl:choose>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
                <!--<xsl:copy-of select="./str[@name='originalMarc']"></xsl:copy-of>-->
            <xsl:if test="./marc:subfield[@code='h' or @code='i' or @code='j' or @code='k' or @code='l' or @code='m' or @code='t']">
                <xsl:element name="shelfLocator" namespace="http://www.loc.gov/mods/v3">
                    <xsl:variable name="str">
                        <xsl:for-each select="marc:subfield[@code='h' or @code='i' or @code='j' or @code='k' or @code='l' or @code='m' or @code='t']">
                            <xsl:value-of select="."/>
                            <xsl:text> </xsl:text>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
                </xsl:element>
            </xsl:if>
        </xsl:if>
    </xsl:template>



    <xsl:template match="marc:datafield[@tag='843']">
        <xsl:element name="holdingSimple" namespace="http://www.loc.gov/mods/v3">
            <xsl:element name="copyInformation" namespace="http://www.loc.gov/mods/v3">
            <xsl:element name="note" namespace="http://www.loc.gov/mods/v3">
                <xsl:attribute name="type"><xsl:text>reproduction</xsl:text></xsl:attribute>
                <xsl:variable name="str">
                    <xsl:for-each select="marc:subfield[@code!='3' and @code!='5' and @code!='6' and @code!='7' and @code!='8']">
                        <xsl:value-of select="."/>
                        <xsl:text> </xsl:text>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="substring($str,1,string-length($str)-1)"/>
            </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="marc:datafield[@tag='856']">
                <xsl:element name="url" namespace="http://www.loc.gov/mods/v3">
                    <xsl:attribute name="access"><xsl:text>raw object</xsl:text></xsl:attribute>
                    <xsl:apply-templates select="marc:subfield[@code='3']" mode="url"/>
                    <xsl:apply-templates select="marc:subfield[@code='z']" mode="url"/>
                    <xsl:apply-templates select="marc:subfield[@code='u']" mode="url"/>
                </xsl:element>
    </xsl:template>

    <xsl:template match="marc:subfield[@code='3']" mode="url">
        <xsl:attribute name="displayLabel">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="marc:subfield[@code='z']" mode="url">
        <xsl:attribute name="note">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="marc:subfield[@code='u']" mode="url">
        <xsl:value-of select="."/>
    </xsl:template>

</xsl:stylesheet>