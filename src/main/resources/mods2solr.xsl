<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:usage="http://lib.harvard.edu/usagedata" version="1.0"
    xmlns:set="http://hul.harvard.edu/ois/xml/ns/libraryCloud"
    xmlns:HarvardDRS="http://hul.harvard.edu/ois/xml/ns/HarvardDRS"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:ext="http://exslt.org/common"
    >

    <xsl:output indent="yes" encoding="UTF-8"/>

    <xsl:template match="mods:modsCollection">
        <xsl:element name="add">
            <xsl:apply-templates select="mods:mods"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:mods">
        <xsl:element name="doc">
            <xsl:apply-templates select="mods:titleInfo"/>
            <xsl:apply-templates select="mods:name"/>
            <xsl:apply-templates select="mods:typeOfResource"/>
             <!-- put the isOnline field here to keep grouped with isCollection and isManuscript -->
            <xsl:element name="field">
                <xsl:attribute name="name">
                    <xsl:text>isOnline</xsl:text>
                </xsl:attribute>
                <xsl:choose>
                    <xsl:when test=".//mods:location/mods:url[@access='raw object']">
                        <xsl:text>true</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>false</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:element>
            <xsl:apply-templates select="mods:genre"/>
            <xsl:apply-templates select="mods:originInfo"/>
            <xsl:apply-templates select="mods:language"/>
            <!--<xsl:apply-templates select="mods:physicalDescription"/>-->
            <xsl:apply-templates select="mods:tableOfContents"/>
            <xsl:apply-templates select="mods:abstract"/>
            <!--<xsl:apply-templates select="mods:targetAudience"/>
            <xsl:apply-templates select="mods:note"/>-->
            <xsl:apply-templates select="mods:subject"/>
            <xsl:apply-templates select="mods:classification"/>
            <xsl:apply-templates select="mods:identifier"/>
            <xsl:apply-templates select=".//mods:location"/>
            <xsl:apply-templates select="mods:recordInfo"/>
            <xsl:apply-templates select="mods:relatedItem[@type='series']"/>
            <xsl:apply-templates select="mods:extension/usage:usageData/usage:stackScore"/>
            <xsl:apply-templates select="mods:extension/set:sets/set:set/set:setName"/>
            <xsl:apply-templates select="mods:extension/set:sets/set:set/set:setSpec"/>
            <xsl:apply-templates select="mods:extension/set:sets/set:set/set:systemId"/>
            <xsl:choose>
                <xsl:when test="mods:extension/HarvardDRS:DRSMetadata">
                    <xsl:element name="field">
                        <xsl:attribute name="name">
                            <xsl:text>inDRS</xsl:text>
                        </xsl:attribute>
                        <xsl:text>true</xsl:text>
                    </xsl:element>
                    <xsl:apply-templates select="mods:extension/HarvardDRS:DRSMetadata"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="field">
                        <xsl:attribute name="name">
                            <xsl:text>inDRS</xsl:text>
                        </xsl:attribute>
                        <xsl:text>false</xsl:text>
                    </xsl:element>
                </xsl:otherwise>
            </xsl:choose>
            <!--
            <xsl:apply-templates select="//mods:relatedItem[@displayLabel='collection']"/>
            <xsl:apply-templates select="mods:relatedItem[@type='constituent']"/>
            -->

            <xsl:element name="field">
                <xsl:attribute name="name">
                    <xsl:text>originalMods</xsl:text>
                </xsl:attribute>
                <xsl:text disable-output-escaping="yes">
                    &lt;![CDATA[
                </xsl:text>
                <xsl:copy-of select="."/>
                <xsl:text disable-output-escaping="yes">
                    ]]&gt;
                </xsl:text>
            </xsl:element>

            <xsl:variable name="dateRange">
              <xsl:call-template name="buildDateRange" />
            </xsl:variable>

            <xsl:if test="not(contains($dateRange, '100000'))">
              <xsl:element name="field">
                <xsl:attribute name="name">
                  <xsl:text>dateRange</xsl:text>
                </xsl:attribute>
                <xsl:value-of select="$dateRange" />
              </xsl:element>
            </xsl:if>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:titleInfo">
      <xsl:if test="not(@type)">
        <xsl:element name="field">
            <xsl:attribute name="name">
               <xsl:text>title</xsl:text>
                <!--
                <xsl:choose>
                    <xsl:when test="@type">
                        <xsl:text>title</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>title</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
                -->
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
      </xsl:if>
    </xsl:template>


    <xsl:template match="mods:name">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>name</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
        <xsl:apply-templates select="mods:role" mode="namerole"/>
    </xsl:template>

    <xsl:template match="mods:role" mode="namerole">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>role</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:typeOfResource">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>resourceType</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>isManuscript</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@manuscript='yes'">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>isCollection</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="@collection='yes'">
                    <xsl:text>true</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>false</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:genre">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>genre</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:originInfo">
        <xsl:apply-templates select="mods:place"/>
        <xsl:apply-templates select="mods:publisher"/>
        <xsl:apply-templates select="mods:dateIssued"/>
        <xsl:apply-templates select="mods:dateCreated"/>
        <xsl:apply-templates select="mods:dateCaptured"/>
        <xsl:apply-templates select="mods:copyrightDate"/>
        <xsl:apply-templates select="mods:edition"/>
        <xsl:apply-templates select="mods:issuance"/>
    </xsl:template>

    <xsl:template match="mods:place[mods:placeTerm/@type='text']">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>originPlace</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="mods:placeTerm"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:publisher">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>publisher</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:dateIssued">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>dateIssued</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:dateCreated">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>dateCreated</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:dateCaptured">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>dateCaptured</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:copyrightDate">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>copyrightDate</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:edition">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>edition</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:issuance">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>issuance</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:language">
      <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="mods:languageTerm">
      <xsl:element name="field">
            <xsl:attribute name="name">
              <xsl:choose>
                <xsl:when test="@type = 'code'">
                  <xsl:text>languageCode</xsl:text>
                </xsl:when>
                <xsl:when test="@type = 'text'">
                  <xsl:text>language</xsl:text>
                </xsl:when>
              </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="mods:physicalDescription">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>physicalDescription</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:abstract">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>abstractTOC</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:tableOfContent">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>abstractTOC</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:subject">
        <xsl:apply-templates mode="subject"/>
        <xsl:apply-templates select="mods:topic|mods:geographic|mods:temporal|mods:genre" mode="narrowersubjects"/>
        <xsl:apply-templates select="mods:titleInfo" mode="subjecttitle"/>
        <xsl:apply-templates select="mods:name" mode="subjectname"/>
        <xsl:apply-templates select="mods:hierarchicalGeographic"/>
    </xsl:template>

    <xsl:template match="*" mode="subject">
        <xsl:choose>
            <xsl:when test="local-name()='geographicCode' or local-name()='hierarchicalGeographic'">
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="field">
                    <xsl:attribute name="name">
                        <xsl:text>subject</xsl:text>
                    </xsl:attribute>
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="narrowersubjects">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>subject.</xsl:text><xsl:value-of select="local-name(.)"/>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="subjecttitle">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>subject.titleInfo</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="mods:title|mods:partName"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="subjectname">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>subject.name</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates select="mods:namePart"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:hierarchicalGeographic">
        <!--<xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>subject.hierarchicalGeographic</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>-->
        <xsl:apply-templates mode="hierarchicalGeographic"/>
    </xsl:template>

<!--     <xsl:template match="*" mode="hierarchicalGeographic">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>subject.hierarchicalGeographic</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>subject.hierarchicalGeographic.</xsl:text><xsl:value-of select="local-name(.)"/>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>
 -->
    <xsl:template match="mods:classification">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>classification</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:identifier">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>identifier</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:location">
        <xsl:apply-templates select="mods:physicalLocation"/>
        <xsl:apply-templates select="mods:url"/>
        <xsl:apply-templates select="mods:shelfLocator"/>
    </xsl:template>

    <xsl:template match="mods:physicalLocation">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>physicalLocation</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:shelfLocator">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>shelfLocator</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:url">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>url</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>urn</xsl:text>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="contains(.,'?')">
                    <xsl:value-of select="substring-before(substring-after(.,'http://nrs.harvard.edu/'),'?')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(.,'http://nrs.harvard.edu/')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:recordInfo">
        <xsl:apply-templates select="mods:recordIdentifier"/>
    </xsl:template>

    <xsl:template match="mods:recordIdentifier">
        <xsl:apply-templates select="@source"/>
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>recordIdentifier</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@source">
        <xsl:element name="field">
            <xsl:attribute name="name">source</xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='series']">
        <xsl:apply-templates select="./mods:titleInfo" />
        <xsl:apply-templates select="./mods:name" />
    </xsl:template>

    <!-- not using related item templates below for aleph, leave for possible use with ead -->
    <xsl:template match="mods:relatedItem[@displayLabel='collection']">
        <xsl:apply-templates select="./mods:titleInfo" mode="relatedItemHost"/>
        <xsl:apply-templates select="./mods:name" mode="relatedItemHost"/>
        <xsl:apply-templates select="./mods:recordInfo" mode="relatedItemHost"/>
    </xsl:template>

    <xsl:template match="mods:relatedItem[@type='constituent']">

        <xsl:apply-templates select="mods:titleInfo" mode="relatedItemConstituent"/>
        <!--
        <xsl:apply-templates select="mods:name" mode="relatedItemConstituent"/>
        <xsl:apply-templates select="mods:recordInfo" mode="relatedItemConstituent"/>
        -->
    </xsl:template>

    <xsl:template match="mods:titleInfo" mode="relatedItemHost">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>relatedItemHostTitle</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:name" mode="relatedItemHost">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>relatedItemHostName</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:recordInfo" mode="relatedItemHost">
        <xsl:apply-templates select="mods:recordIdentifier" mode="relatedItemHost"/>
    </xsl:template>

    <xsl:template match="mods:recordIdentifier" mode="relatedItemHost">
         <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>relatedItemHostRecId</xsl:text>
            </xsl:attribute>
             <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:titleInfo" mode="relatedItemConstituent">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>relatedItemConstituentTitle</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:name" mode="relatedItemConstituent">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>relatedItemConstituentName</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="mods:recordInfo" mode="relatedConstituent">
        <xsl:apply-templates select="mods:recordIdentifier" mode="relatedItemConstituent"/>
    </xsl:template>

    <xsl:template match="mods:recordIdentifier" mode="relatedItemConstituent">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>relatedItemConstituentRecId</xsl:text>
            </xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="usage:stackScore">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>stackscore</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="set:setName">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>setName</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="field">
          <xsl:attribute name="name">
            <xsl:text>collectionTitle</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="set:setSpec">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>setSpec</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
        <xsl:element name="field">
          <xsl:attribute name="name">
            <xsl:text>collectionTitle</xsl:text>
          </xsl:attribute>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="set:systemId">
      <xsl:element name="field">
        <xsl:attribute name="name">
          <xsl:text>setSystemId</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:element>
      <xsl:element name="field">
        <xsl:attribute name="name">
          <xsl:text>collectionId</xsl:text>
        </xsl:attribute>
        <xsl:value-of select="normalize-space(.)"/>
      </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:DRSMetadata">
        <xsl:apply-templates/>
    </xsl:template>

    <!--
    <xsl:template match="HarvardDRS:inDRS">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>inDRS</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>
    -->
    <xsl:template match="HarvardDRS:inDRS"/>

    <xsl:template match="HarvardDRS:accessFlag">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>accessFlag</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:contentModel">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>contentModel</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:uriType">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>uriType</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:ownerCode">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>ownerCode</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:ownerCodeDisplayName">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>ownerCodeDisplayName</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:metsLabel">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>metsLabel</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="HarvardDRS:lastModifiedDate">
        <xsl:element name="field">
            <xsl:attribute name="name">
                <xsl:text>lastModifiedDate</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:element>
    </xsl:template>


    <!-- will add space for sibs except for the last -->
    <xsl:template match="*">
        <xsl:value-of select="."/><xsl:if test="not(position()=last())"><xsl:text> </xsl:text></xsl:if>
    </xsl:template>

    <xsl:template name="buildDateRange">
      <xsl:param name="lowDate" select="100000"/>
      <xsl:param name="highDate" select="-100000"/>
      <xsl:param name="dateNodes" select="descendant::*[local-name()='dateIssued' or local-name()='dateCreated']" />
      <xsl:param name="position" select="1" />

      <xsl:choose>
        <xsl:when test="count($dateNodes[number($position)]) &gt; 0">
          <xsl:variable name="currentDateNode" select="$dateNodes[number($position)]" />

          <!-- collect all dates and build 4 digit dates separated by '_'
               e.g, '1910_1920_1930_' -->

          <xsl:variable name="dateString">
            <xsl:call-template name="normalizeDate">
              <xsl:with-param name="dateStringInput" select="$currentDateNode" />
            </xsl:call-template>
          </xsl:variable>

          <xsl:call-template name="buildDateRange">
            <xsl:with-param name="lowDate">
              <xsl:call-template name="findLowDate">
                <xsl:with-param name="dateString" select="$dateString" />
                <xsl:with-param name="lowDate" select="$lowDate" />
              </xsl:call-template>
            </xsl:with-param>

            <xsl:with-param name="highDate">
              <xsl:call-template name="findHighDate">
                <xsl:with-param name="dateString" select="$dateString" />
                <xsl:with-param name="highDate" select="$highDate" />
              </xsl:call-template>
            </xsl:with-param>

            <xsl:with-param name="dateNodes" select="$dateNodes" />
            <xsl:with-param name="position">
              <xsl:value-of select="$position+1" />
            </xsl:with-param>
          </xsl:call-template>

        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="formatDateRange">
            <xsl:with-param name="lowDate" select="$lowDate" />
            <xsl:with-param name="highDate" select="$highDate" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="formatDateRange">
      <xsl:param name="lowDate" />
      <xsl:param name="highDate" />

      <xsl:choose>
        <xsl:when test="starts-with($lowDate, '0')">
          <xsl:call-template name="formatDateRange">
            <xsl:with-param name="lowDate" select="substring($lowDate, 2)" />
            <xsl:with-param name="highDate" select="$highDate" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="starts-with($highDate, '0')">
          <xsl:call-template name="formatDateRange">
            <xsl:with-param name="lowDate" select="$lowDate" />
            <xsl:with-param name="highDate" select="substring($highDate, 2)" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="concat('[', string($lowDate), ' TO ', string($highDate), ']')" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="normalizeDate">
      <xsl:param name="dateStringInput"/>
      <xsl:param name="dateStringOutput"/>
      <xsl:param name="step" select="1" />
      <xsl:param name="brake" select="0" />

      <xsl:choose>
        <xsl:when test="$brake &gt; 1000">
          <xsl:message>breaking out of loop: normalizeDate</xsl:message>
        </xsl:when>
        <xsl:when test="string-length($dateStringInput) = 0 and string-length($dateStringOutput) = 0"></xsl:when>
        <xsl:when test="$step = 1 and string-length($dateStringInput) > 0">
          <xsl:call-template name="normalizeDate">
            <xsl:with-param name="dateStringInput">
              <xsl:value-of select="substring($dateStringInput, 2)" />
            </xsl:with-param>
            <xsl:with-param name="dateStringOutput">
              <xsl:choose>
                <xsl:when test="contains('0123456789?-/', substring($dateStringInput, 1, 1))">
                  <xsl:value-of select="concat($dateStringOutput, substring($dateStringInput, 1, 1))" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat($dateStringOutput, ' ')" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="brake" select="$brake+1" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$step = 1 and contains($dateStringOutput, '  ')">
          <xsl:call-template name="normalizeDate">
            <xsl:with-param name="brake" select="$brake+1" />
            <xsl:with-param name="dateStringOutput" select="concat(substring-before($dateStringOutput, '  '), ' ', substring-after($dateStringOutput, '  '))" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$step = 1 and starts-with($dateStringOutput, ' ')">
          <xsl:call-template name="normalizeDate">
            <xsl:with-param name="brake" select="$brake+1" />
            <xsl:with-param name="dateStringOutput" select="substring($dateStringOutput, 2)" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$step = 1 and substring($dateStringOutput, string-length($dateStringOutput) - 1, 1) = ' '">
          <xsl:call-template name="normalizeDate">
            <xsl:with-param name="brake" select="$brake+1" />
            <xsl:with-param name="dateStringOutput" select="substring($dateStringOutput, 1, string-length($dateStringOutput) -1)" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$step = 1 and not(substring($dateStringOutput, string-length($dateStringOutput)) = ' ')">
          <xsl:call-template name="normalizeDate">
            <xsl:with-param name="brake" select="$brake+1" />
            <xsl:with-param name="dateStringInput" select="concat($dateStringOutput, ' ')" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$step = 1">
          <xsl:call-template name="normalizeDate">
            <xsl:with-param name="brake" select="$brake+1" />
            <xsl:with-param name="dateStringInput" select="translate($dateStringOutput, ' ', '_')" />
            <xsl:with-param name="step" select="2" />
          </xsl:call-template>
        </xsl:when>
        <!-- now make each part 4 digits-->
        <xsl:when test="$step = 2">
          <xsl:choose>
            <xsl:when test="contains($dateStringInput, '_')">
              <xsl:variable name="normalizedFrag">
                <xsl:call-template name="padDateString">
                  <xsl:with-param name="dateString">
                    <xsl:call-template name="normalizeDateFrag">
                      <xsl:with-param name="dateStringInput" select="substring-before($dateStringInput, '_')" />
                    </xsl:call-template>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:variable>
              <xsl:call-template name="normalizeDate">
                <xsl:with-param name="brake" select="$brake+1" />
                <xsl:with-param name="dateStringInput" select="substring-after($dateStringInput, '_')" />
                <xsl:with-param name="dateStringOutput">
                  <xsl:choose>
                    <xsl:when test="string-length($dateStringOutput) > 0">
                      <xsl:value-of select="concat($dateStringOutput, '_', $normalizedFrag)" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$normalizedFrag" />
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:with-param>
                <xsl:with-param name="step" select="2" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <!--DONE -->
              <xsl:value-of select="translate($dateStringOutput, '-', '_')" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="normalizeDateFrag">
      <xsl:param name="dateStringInput"/>
      <xsl:param name="dateStringOutput"/>
      <xsl:choose>
        <xsl:when test="string-length($dateStringInput) = 5 and substring($dateStringInput, 4, 2) = '-?'">
          <xsl:call-template name="normalizeDateFrag">
            <xsl:with-param name="dateStringInput" select="translate($dateStringInput, '-?', '0')" />
            <xsl:with-param name="dateStringOutput" select="$dateStringOutput" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string-length($dateStringInput) = 4 and substring($dateStringInput, 4, 1) = '?'">
          <xsl:call-template name="normalizeDateFrag">
            <xsl:with-param name="dateStringInput" select="translate($dateStringInput, '?', '')" />
            <xsl:with-param name="dateStringOutput" select="$dateStringOutput" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string-length($dateStringInput) = 7 and substring($dateStringInput, 5, 1) = '/'">
          <xsl:call-template name="normalizeDateFrag">
            <xsl:with-param name="dateStringInput" select="concat(substring($dateStringInput, 1, 4), '-', substring($dateStringInput, 1, 2), substring($dateStringInput, 6, 2))" />
            <xsl:with-param name="dateStringOutput" select="$dateStringOutput" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string-length($dateStringInput) = 8 and substring($dateStringInput, 5, 1) = '/' and substring($dateStringInput, 8, 1) = '?'">
          <xsl:call-template name="normalizeDateFrag">
            <xsl:with-param name="dateStringInput" select="concat(substring($dateStringInput, 1, 4), '-', substring($dateStringInput, 1, 2), substring($dateStringInput, 6, 2))" />
            <xsl:with-param name="dateStringOutput" select="$dateStringOutput" />
          </xsl:call-template>
        </xsl:when>

        <xsl:when test="starts-with($dateStringInput, '[') and (substring($dateStringInput, string-length($dateStringInput), 1) = ']')">
          <xsl:call-template name="normalizeDateFrag">
            <xsl:with-param name="dateStringInput" select="substring($dateStringInput, 2, string-length($dateStringInput) - 2)" />
            <xsl:with-param name="dateStringOutput" select="$dateStringOutput" />
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="string-length($dateStringInput) &gt; 0">
          <xsl:call-template name="normalizeDateFrag">
            <xsl:with-param name="dateStringInput" select="substring($dateStringInput, 2)" />
            <xsl:with-param name="dateStringOutput">
              <xsl:choose>
                <xsl:when test="contains('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ[]', substring($dateStringInput, 1, 1))">
                  <xsl:value-of select="$dateStringOutput" />
                </xsl:when>
                <xsl:when test="contains('?', substring($dateStringInput, 1, 1))">
                  <xsl:value-of select="concat($dateStringOutput, '0')" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="concat($dateStringOutput, substring($dateStringInput, 1, 1))" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>

        <xsl:otherwise>
          <xsl:value-of select="$dateStringOutput" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="padDateString">
      <xsl:param name="dateString" />
      <xsl:choose>
        <xsl:when test="string-length($dateString) &lt; 4">
          <xsl:call-template name="padDateString">
            <xsl:with-param name="dateString" select="concat('0', $dateString)" />
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$dateString" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <xsl:template name="findLowDate">
      <xsl:param name="dateString" />
      <xsl:param name="lowDate" select="100000"/>

      <xsl:choose>
      <xsl:when test="string-length($dateString) &gt; 0">
        <xsl:call-template name="findLowDate">
          <xsl:with-param name="dateString" select="substring-after($dateString, '_')" />
          <xsl:with-param name="lowDate">
            <xsl:choose>
              <xsl:when test="number(substring($dateString, 1, 4)) &lt; number($lowDate)">
                <xsl:value-of select="substring($dateString, 1, 4)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$lowDate" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$lowDate" />
      </xsl:otherwise>
      </xsl:choose>
    </xsl:template>



    <xsl:template name="findHighDate">
      <xsl:param name="dateString" />
      <xsl:param name="highDate" select="-100000"/>

      <xsl:choose>
      <xsl:when test="string-length($dateString) &gt; 0">
        <xsl:call-template name="findHighDate">
          <xsl:with-param name="dateString" select="substring-after($dateString, '_')" />
          <xsl:with-param name="highDate">
            <xsl:choose>
              <xsl:when test="number(substring($dateString, 1, 4)) &gt; number($highDate)">
                <xsl:value-of select="substring($dateString, 1, 4)" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$highDate" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$highDate" />
      </xsl:otherwise>
      </xsl:choose>
    </xsl:template>

    <!--
        ? = not yet implemented
    <field name="resourceType" type="string" indexed="true" stored="true"/>
    <field name="publisher" type="string" indexed="true" stored="true"  multiValued="true"/>
  ?<field name="originDate" type="string" indexed="true" stored="true"/> - concatenation of other date types
  <field name="edition" type="string" indexed="true" stored="true"/>
  <field name="physicalDescription" type="string" indexed="true" stored="true"/>
  <field name="source" type="string" indexed="true" stored="true"/>
  <field name="recordIdentifier" type="string" indexed="true" stored="true"/>
  <field name="originalMods" type="string" indexed="false" stored="true"/>
  <field name="isCollection" type="string" indexed="true" stored="true"/>
  <field name="isManuscript" type="string" indexed="true" stored="true"/>

    <field name="genre" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="title" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="abstractTOC" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="languageCode" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="name" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="role" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="originPlace" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="dateIssued" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="dateCreated" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="dateCaptured" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="copyrightDate" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="classification" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="identifier" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="physicalLocation" type="string" indexed="true" stored="true" multiValued="true"/>
  ?<field name="shelfLocator" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="url" type="string" indexed="true" stored="true" multiValued="true"/> - waiting for holdings
  <field name="issuance" type="string" indexed="true" stored="true" multiValued="true"/>
  ?<field name="relatedItem" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.topic" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.geographic" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.temporal" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.titleInfo" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.name" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.genre" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.country" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.continent" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.province" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.region" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.state" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.territory" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.county" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.city" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.citySection" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.island" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.area" type="string" indexed="true" stored="true" multiValued="true"/>
  <field name="subject.hierarchicalGeographic.extraterrestrialArea" type="string" indexed="true" stored="true" multiValued="true"/>#
-->

</xsl:stylesheet>
