<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="d"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:template match="d:bibliography">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>

    <xsl:call-template name="bibliography.titlepage"/>

    <xsl:apply-templates/>

    <xsl:if test="not(parent::d:article)">
      <xsl:call-template name="process.footnotes"/>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="d:bibliography/d:bibliographyinfo"></xsl:template>
<xsl:template match="d:bibliography/d:info"></xsl:template>
<xsl:template match="d:bibliography/d:title"></xsl:template>
<xsl:template match="d:bibliography/d:subtitle"></xsl:template>
<xsl:template match="d:bibliography/d:titleabbrev"></xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:bibliodiv">
  <xsl:call-template name="id.warning"/>

  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute">
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="d:bibliodiv/d:title">
  <h3>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="anchor">
      <xsl:with-param name="node" select=".."/>
      <xsl:with-param name="conditional" select="0"/>
    </xsl:call-template>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:bibliolist">
  <div>
    <xsl:call-template name="common.html.attributes">
      <xsl:with-param name="inherit" select="0"/>
    </xsl:call-template>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="d:blockinfo/d:title|d:info/d:title|d:title">
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>
    <xsl:apply-templates select="*[not(self::d:blockinfo)
                                   and not(self::d:info)
                                   and not(self::d:title)
                                   and not(self::d:titleabbrev)
                                   and not(self::d:biblioentry)
                                   and not(self::d:bibliomixed)]"/>
    <xsl:apply-templates select="d:biblioentry|d:bibliomixed"/>
  </div>
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
          <div>
            <xsl:call-template name="common.html.attributes"/>
            <xsl:call-template name="id.attribute"/>
            <xsl:call-template name="anchor"/>
            <p>
              <xsl:copy-of select="$label"/>
              <xsl:text>Error: no bibliography entry: </xsl:text>
              <xsl:value-of select="$id"/>
              <xsl:text> found in </xsl:text>
              <xsl:value-of select="$bibliography.collection"/>
            </p>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:call-template name="common.html.attributes"/>
        <xsl:call-template name="id.attribute">
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <p>
          <xsl:copy-of select="$label"/>
	  <xsl:choose>
	    <xsl:when test="$bibliography.style = 'iso690'">
	      <xsl:call-template name="iso690.makecitation"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:apply-templates mode="bibliography.mode"/>
	    </xsl:otherwise>
	  </xsl:choose>
        </p>
      </div>
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
          <div>
            <xsl:call-template name="common.html.attributes"/>
            <xsl:call-template name="id.attribute"/>
            <xsl:call-template name="anchor"/>
            <p>
              <xsl:copy-of select="$label"/>
              <xsl:text>Error: no bibliography entry: </xsl:text>
              <xsl:value-of select="$id"/>
              <xsl:text> found in </xsl:text>
              <xsl:value-of select="$bibliography.collection"/>
            </p>
          </div>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:call-template name="common.html.attributes"/>
        <xsl:call-template name="id.attribute">
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <p>
          <xsl:call-template name="common.html.attributes"/>
          <xsl:copy-of select="$label"/>
          <xsl:apply-templates mode="bibliomixed.mode"/>
        </p>
      </div>
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
    <xsl:when test="$node/@id">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$node/@id"/>
      <xsl:text>] </xsl:text>
    </xsl:when>
    <xsl:when test="$node/@xml:id">
      <xsl:text>[</xsl:text>
      <xsl:value-of select="$node/@xml:id"/>
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
    <xsl:apply-templates mode="bibliography.mode"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:abstract" mode="bibliography.mode">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="d:address" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:affiliation" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:shortaffil" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:jobtitle" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:artheader|d:articleinfo|d:info" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:artpagenums" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:author" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:choose>
      <xsl:when test="d:orgname">
        <xsl:apply-templates select="d:orgname" mode="bibliography.mode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="person.name"/>
        <xsl:copy-of select="$biblioentry.item.separator"/>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="d:authorblurb|d:personblurb" mode="bibliography.mode">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="d:authorgroup" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="person.name.list"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:authorinitials" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:bibliomisc" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:bibliomset" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:biblioset" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:biblioset/d:title|d:biblioset/d:citetitle"
              mode="bibliography.mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:apply-templates/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <i><xsl:apply-templates/></i>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:copy-of select="$biblioentry.item.separator"/>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:citetitle" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:choose>
      <xsl:when test="@pubwork = 'article'">
        <xsl:call-template name="gentext.startquote"/>
        <xsl:call-template name="inline.charseq"/>
        <xsl:call-template name="gentext.endquote"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="inline.italicseq"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:collab" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:collabname" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:confgroup" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:confdates" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:conftitle" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:confnum" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:confsponsor" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:contractnum" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:contractsponsor" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:contrib" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:copyright" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
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
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
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
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:corpcredit" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:corpname" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:date" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:edition" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:editor" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="person.name"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:firstname" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:honorific" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:indexterm" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:invpartnumber" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:isbn" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:issn" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:issuenum" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:lineage" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:orgname" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:orgdiv" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:othercredit" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:othername" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:pagenums" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:printhistory" mode="bibliography.mode">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="d:productname" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:productnumber" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:pubdate" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:publisher" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:publishername" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:pubsnumber" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:revhistory" mode="bibliography.mode">
  <!-- suppressed; how could this be represented? -->
</xsl:template>

<xsl:template match="d:seriesinfo" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:seriesvolnums" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:subtitle" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:surname" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:title" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <i><xsl:apply-templates mode="bibliography.mode"/></i>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:volumenum" mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<xsl:template match="d:bibliocoverage|d:biblioid|d:bibliorelation|d:bibliosource"
              mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliography.mode"/>
    <xsl:copy-of select="$biblioentry.item.separator"/>
  </span>
</xsl:template>

<!-- See FR #1934434 and http://doi.org -->
<xsl:template match="d:biblioid[@class='doi']"
              mode="bibliography.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <a href="{concat('http://dx.doi.org/', .)}">doi:<xsl:value-of select="."/></a>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="bibliomixed.mode">
  <xsl:apply-templates select="."/><!-- try the default mode -->
</xsl:template>

<xsl:template match="d:abbrev" mode="bibliomixed.mode">
  <xsl:if test="preceding-sibling::*">
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </xsl:if>
</xsl:template>

<xsl:template match="d:abstract" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:address" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:affiliation" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:shortaffil" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:jobtitle" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:artpagenums" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:author" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:choose>
      <xsl:when test="d:orgname">
        <xsl:apply-templates select="d:orgname" mode="bibliomixed.mode"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="person.name"/>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>

<xsl:template match="d:authorblurb|d:personblurb" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:authorgroup" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:authorinitials" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:bibliomisc" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:bibliomset" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:bibliomset/d:title|d:bibliomset/d:citetitle"
              mode="bibliomixed.mode">
  <xsl:variable name="relation" select="../@relation"/>
  <xsl:choose>
    <xsl:when test="$relation='article' or @pubwork='article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:apply-templates/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <i><xsl:apply-templates/></i>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="d:biblioset" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:citetitle" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:choose>
      <xsl:when test="@pubwork = 'article'">
        <xsl:call-template name="gentext.startquote"/>
        <xsl:call-template name="inline.charseq"/>
        <xsl:call-template name="gentext.endquote"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="inline.italicseq"/>
      </xsl:otherwise>
    </xsl:choose>
  </span>
</xsl:template>


<xsl:template match="d:collab" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:confgroup" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:contractnum" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:contractsponsor" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:contrib" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:copyright" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:corpauthor" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:corpcredit" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:corpname" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:date" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:edition" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:editor" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:firstname" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:honorific" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:indexterm" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:invpartnumber" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:isbn" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:issn" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:issuenum" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:lineage" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:orgname" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:othercredit" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:othername" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:pagenums" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:printhistory" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:productname" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:productnumber" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:pubdate" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:publisher" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:publishername" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:pubsnumber" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:revhistory" mode="bibliomixed.mode">
  <!-- suppressed; how could this be represented? -->
</xsl:template>

<xsl:template match="d:seriesvolnums" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:subtitle" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:surname" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:title" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:volumenum" mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:bibliocoverage|d:biblioid|d:bibliorelation|d:bibliosource"
              mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="bibliomixed.mode"/>
  </span>
</xsl:template>

<!-- See FR #1934434 and http://doi.org -->
<xsl:template match="d:biblioid[@class='doi']"
              mode="bibliomixed.mode">
  <span>
    <xsl:call-template name="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <a href="{concat('http://dx.doi.org/', .)}">doi:<xsl:value-of select="."/></a>
  </span>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
