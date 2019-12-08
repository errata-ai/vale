<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:bibliography">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="not(parent::*) or parent::d:part or parent::d:book">
      <xsl:variable name="master-reference">
        <xsl:call-template name="select.pagemaster"/>
      </xsl:variable>

      <fo:page-sequence hyphenate="{$hyphenate}"
                        master-reference="{$master-reference}">
        <xsl:attribute name="language">
          <xsl:call-template name="l10n.language"/>
        </xsl:attribute>
        <xsl:attribute name="format">
          <xsl:call-template name="page.number.format">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="initial-page-number">
          <xsl:call-template name="initial.page.number">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="force-page-count">
          <xsl:call-template name="force.page.count">
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-character">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-character'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-push-character-count">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-push-character-count'"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="hyphenation-remain-character-count">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'hyphenation-remain-character-count'"/>
          </xsl:call-template>
        </xsl:attribute>

        <xsl:apply-templates select="." mode="running.head.mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="." mode="running.foot.mode">
          <xsl:with-param name="master-reference" select="$master-reference"/>
        </xsl:apply-templates>

        <fo:flow flow-name="xsl-region-body">
          <xsl:call-template name="set.flow.properties">
            <xsl:with-param name="element" select="local-name(.)"/>
            <xsl:with-param name="master-reference" select="$master-reference"/>
          </xsl:call-template>

          <fo:block id="{$id}">
            <xsl:call-template name="bibliography.titlepage"/>
          </fo:block>
          <xsl:apply-templates/>
        </fo:flow>
      </fo:page-sequence>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}"
                space-before.minimum="1em"
                space-before.optimum="1.5em"
                space-before.maximum="2em">
        <xsl:call-template name="bibliography.titlepage"/>
      </fo:block>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:bibliography/d:bibliographyinfo"></xsl:template>
<xsl:template match="d:bibliography/d:info"></xsl:template>
<xsl:template match="d:bibliography/d:title"></xsl:template>
<xsl:template match="d:bibliography/d:subtitle"></xsl:template>
<xsl:template match="d:bibliography/d:titleabbrev"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:bibliodiv">
  <fo:block>
    <xsl:attribute name="id">
      <xsl:call-template name="object.id"/>
    </xsl:attribute>
    <xsl:call-template name="bibliodiv.titlepage"/>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:bibliodiv/d:title"/>
<xsl:template match="d:bibliodiv/d:subtitle"/>
<xsl:template match="d:bibliodiv/d:titleabbrev"/>

<!-- ==================================================================== -->

<xsl:template match="d:bibliolist">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}"
            space-before.minimum="1em"
            space-before.optimum="1.5em"
            space-before.maximum="2em">

    <xsl:if test="d:blockinfo/d:title|d:info/d:title|d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>

    <xsl:apply-templates select="*[not(self::d:blockinfo)
                                   and not(self::d:info)
                                   and not(self::d:title)
                                   and not(self::d:titleabbrev)]"/>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:biblioentry">
  <xsl:param name="label">
    <xsl:call-template name="biblioentry.label"/>
  </xsl:param>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="string(.) = ''">
      <xsl:variable name="bib" select="document($bibliography.collection,.)"/>
      <xsl:variable name="entry" select="$bib/d:bibliography//
                                         *[@id=$id or @xml:id=$id][1]"/>
      <xsl:choose>
        <xsl:when test="$entry">
          <xsl:choose>
            <xsl:when test="$bibliography.numbered != 0">
              <xsl:apply-templates select="$entry">
                <xsl:with-param name="label" select="$label"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$entry"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No bibliography entry: </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> found in </xsl:text>
            <xsl:value-of select="$bibliography.collection"/>
          </xsl:message>
          <fo:block id="{$id}" xsl:use-attribute-sets="normal.para.spacing">
            <xsl:text>Error: no bibliography entry: </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> found in </xsl:text>
            <xsl:value-of select="$bibliography.collection"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}" xsl:use-attribute-sets="biblioentry.properties">
        <xsl:copy-of select="$label"/>
	<xsl:choose>
	  <xsl:when test="$bibliography.style = 'iso690'">
	    <xsl:call-template name="iso690.makecitation"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates mode="bibliography.mode"/>
	  </xsl:otherwise>
	</xsl:choose>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:bibliomixed">
  <xsl:param name="label">
    <xsl:call-template name="biblioentry.label"/>
  </xsl:param>

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="string(.) = ''">
      <xsl:variable name="bib" select="document($bibliography.collection,.)"/>
      <xsl:variable name="entry" select="$bib/d:bibliography//
                                         *[@id=$id or @xml:id=$id][1]"/>
      <xsl:choose>
        <xsl:when test="$entry">
          <xsl:choose>
            <xsl:when test="$bibliography.numbered != 0">
              <xsl:apply-templates select="$entry">
                <xsl:with-param name="label" select="$label"/>
              </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$entry"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>No bibliography entry: </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> found in </xsl:text>
            <xsl:value-of select="$bibliography.collection"/>
          </xsl:message>
          <fo:block id="{$id}" xsl:use-attribute-sets="normal.para.spacing">
            <xsl:text>Error: no bibliography entry: </xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text> found in </xsl:text>
            <xsl:value-of select="$bibliography.collection"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <fo:block id="{$id}" xsl:use-attribute-sets="biblioentry.properties">
        <xsl:copy-of select="$label"/>
        <xsl:apply-templates mode="bibliomixed.mode"/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="biblioentry.label">
  <xsl:param name="node" select="."/>

  <xsl:choose>
    <xsl:when test="$bibliography.numbered != 0">
      <xsl:text>[</xsl:text>
      <xsl:number from="d:bibliography" count="d:biblioentry|d:bibliomixed"
                  level="any" format="1"/>
      <xsl:text>] </xsl:text>
    </xsl:when>
    <xsl:when test="local-name($node/child::*[1]) = 'abbrev'">
      <xsl:text>[</xsl:text>
      <xsl:apply-templates select="$node/d:abbrev[1]"/>
      <xsl:text>] </xsl:text>
    </xsl:when>
    <xsl:when test="$node/@xreflabel">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$node/@xreflabel"/>
      <xsl:text>] </xsl:text>
    </xsl:when>
    <xsl:when test="$node/@id or $node/@xml:id">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="($node/@id|$node/@xml:id)[1]"/>
      <xsl:text>] </xsl:text>
    </xsl:when>
    <xsl:otherwise><!-- nop --></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="bibliography.mode">
  <xsl:apply-templates select="."/><!-- try the default mode -->
</xsl:template>

<xsl:template match="d:abbrev" mode="bibliography.mode">
  <xsl:if test="preceding-sibling::*">
    <fo:inline>
      <xsl:apply-templates mode="bibliography.mode"/>
    </fo:inline>
  </xsl:if>
</xsl:template>

<xsl:template match="d:abstract" mode="bibliography.mode">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="d:address" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:affiliation" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:shortaffil" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:jobtitle" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:artheader|d:articleinfo|d:article/d:info"
              mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:artpagenums" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:author" mode="bibliography.mode">
  <fo:inline>
    <xsl:choose>
      <xsl:when test="d:orgname">
        <xsl:apply-templates select="d:orgname" mode="bibliography.mode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="person.name"/>
        <xsl:value-of select="$biblioentry.item.separator"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorblurb|d:personblurb" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorgroup" mode="bibliography.mode">
  <fo:inline>
    <xsl:call-template name="person.name.list"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorinitials" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:bibliomisc" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:bibliomset" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:biblioset" mode="bibliography.mode">
  <fo:inline>
    <xsl:if test="@id">
      <xsl:attribute name="id">
        <xsl:value-of select="@id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates mode="bibliography.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:biblioset/d:title|d:biblioset/d:citetitle"
              mode="bibliography.mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:apply-templates mode="bibliography.mode"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$biblioentry.item.separator"/>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:citetitle" mode="bibliography.mode">
  <fo:inline>
    <xsl:choose>
      <xsl:when test="@pubwork = 'article'">
        <xsl:call-template name="gentext.startquote"/>
        <xsl:apply-templates mode="bibliography.mode"/>
        <xsl:call-template name="gentext.endquote"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline font-style="italic">
          <xsl:apply-templates mode="bibliography.mode"/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:collab" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:confgroup" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:contractnum" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:contractsponsor" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:contrib" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:copyright" mode="bibliography.mode">
  <fo:inline>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat">copyright</xsl:with-param>
    </xsl:call-template>
    <xsl:call-template name="gentext.space"/>
    <xsl:apply-templates select="d:year" mode="bibliography.mode"/>
    <xsl:if test="d:holder">
      <xsl:call-template name="gentext.space"/>
      <xsl:apply-templates select="d:holder" mode="bibliography.mode"/>
    </xsl:if>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:year" mode="bibliography.mode">
  <xsl:apply-templates/><xsl:text>, </xsl:text>
</xsl:template>

<xsl:template match="d:year[position()=last()]" mode="bibliography.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:holder" mode="bibliography.mode">
  <xsl:apply-templates/>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:corpauthor" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:corpcredit" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:corpname" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:date" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:edition" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:editor" mode="bibliography.mode">
  <fo:inline>
    <xsl:call-template name="person.name"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:firstname" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:honorific" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:indexterm" mode="bibliography.mode">
  <xsl:apply-templates select="."/> 
</xsl:template>

<xsl:template match="d:invpartnumber" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:isbn" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:issn" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:issuenum" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:lineage" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:orgname" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:othercredit" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:othername" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:pagenums" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:printhistory" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:productname" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:productnumber" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:pubdate" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:publisher" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:publishername" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:pubsnumber" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:revhistory" mode="bibliography.mode">
  <fo:block>
    <xsl:apply-templates select="."/> <!-- use normal mode -->
  </fo:block>
</xsl:template>

<xsl:template match="d:seriesinfo" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:seriesvolnums" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:subtitle" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:surname" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:title" mode="bibliography.mode">
  <fo:inline>
    <fo:inline font-style="italic">
      <xsl:apply-templates mode="bibliography.mode"/>
    </fo:inline>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:volumenum" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:orgdiv" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:collabname" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:confdates" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:conftitle" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:confnum" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:confsponsor" mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:bibliocoverage|d:biblioid|d:bibliorelation|d:bibliosource"
              mode="bibliography.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:value-of select="$biblioentry.item.separator"/>
  </fo:inline>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="bibliomixed.mode">
  <xsl:apply-templates select="."/><!-- try the default mode -->
</xsl:template>

<xsl:template match="d:abbrev" mode="bibliomixed.mode">
  <xsl:if test="preceding-sibling::*">
    <fo:inline>
      <xsl:apply-templates mode="bibliomixed.mode"/>
    </fo:inline>
  </xsl:if>
</xsl:template>

<xsl:template match="d:abstract" mode="bibliomixed.mode">
  <fo:block start-indent="1in">
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:para" mode="bibliomixed.mode">
  <fo:block>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:address" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:affiliation" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:shortaffil" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:jobtitle" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliography.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:artpagenums" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:author" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:choose>
      <xsl:when test="d:orgname">
        <xsl:apply-templates select="d:orgname" mode="bibliomixed.mode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="person.name"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorblurb|d:personblurb" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorgroup" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:authorinitials" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:bibliomisc" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:bibliomset" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:bibliomset/d:title|d:bibliomset/d:citetitle" 
              mode="bibliomixed.mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:apply-templates mode="bibliomixed.mode"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:biblioset" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:citetitle" mode="bibliomixed.mode">
  <xsl:choose>
    <xsl:when test="@pubwork = 'article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:apply-templates mode="bibliomixed.mode"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates mode="bibliography.mode"/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:collab" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:confgroup" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:contractnum" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:contractsponsor" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:contrib" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:copyright" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:corpauthor" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:corpcredit" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:corpname" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:date" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:edition" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:editor" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:firstname" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:honorific" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:indexterm" mode="bibliomixed.mode">
  <xsl:apply-templates select="."/> 
</xsl:template>

<xsl:template match="d:invpartnumber" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:isbn" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:issn" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:issuenum" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:lineage" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:orgname" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:othercredit" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:othername" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:pagenums" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:printhistory" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:productname" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:productnumber" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:pubdate" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:publisher" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:publishername" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:pubsnumber" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:revhistory" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:seriesvolnums" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:subtitle" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:surname" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:title" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:volumenum" mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<xsl:template match="d:bibliocoverage|d:biblioid|d:bibliorelation|d:bibliosource"
              mode="bibliomixed.mode">
  <fo:inline>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </fo:inline>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
