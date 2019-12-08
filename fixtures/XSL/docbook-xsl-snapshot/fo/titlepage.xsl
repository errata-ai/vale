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

<xsl:attribute-set name="book.titlepage.recto.style">
  <xsl:attribute name="font-family">
    <xsl:value-of select="$title.fontset"/>
  </xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-size">12pt</xsl:attribute>
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="book.titlepage.verso.style">
  <xsl:attribute name="font-size">10pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="article.titlepage.recto.style"/>
<xsl:attribute-set name="article.titlepage.verso.style"/>

<xsl:attribute-set name="set.titlepage.recto.style"/>
<xsl:attribute-set name="set.titlepage.verso.style"/>

<xsl:attribute-set name="part.titlepage.recto.style">
  <xsl:attribute name="text-align">center</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="part.titlepage.verso.style"/>

<xsl:attribute-set name="partintro.titlepage.recto.style"/>
<xsl:attribute-set name="partintro.titlepage.verso.style"/>

<xsl:attribute-set name="reference.titlepage.recto.style"/>
<xsl:attribute-set name="reference.titlepage.verso.style"/>

<xsl:attribute-set name="dedication.titlepage.recto.style"/>
<xsl:attribute-set name="dedication.titlepage.verso.style"/>

<xsl:attribute-set name="acknowledgements.titlepage.recto.style"/>
<xsl:attribute-set name="acknowledgements.titlepage.verso.style"/>

<xsl:attribute-set name="preface.titlepage.recto.style"/>
<xsl:attribute-set name="preface.titlepage.verso.style"/>

<xsl:attribute-set name="chapter.titlepage.recto.style"/>
<xsl:attribute-set name="chapter.titlepage.verso.style"/>

<xsl:attribute-set name="appendix.titlepage.recto.style"/>
<xsl:attribute-set name="appendix.titlepage.verso.style"/>

<xsl:attribute-set name="bibliography.titlepage.recto.style"/>
<xsl:attribute-set name="bibliography.titlepage.verso.style"/>

<xsl:attribute-set name="bibliodiv.titlepage.recto.style"/>
<xsl:attribute-set name="bibliodiv.titlepage.verso.style"/>

<xsl:attribute-set name="glossary.titlepage.recto.style"/>
<xsl:attribute-set name="glossary.titlepage.verso.style"/>

<xsl:attribute-set name="glossdiv.titlepage.recto.style"/>
<xsl:attribute-set name="glossdiv.titlepage.verso.style"/>

<xsl:attribute-set name="index.titlepage.recto.style"/>
<xsl:attribute-set name="index.titlepage.verso.style"/>

<xsl:attribute-set name="setindex.titlepage.recto.style"/>
<xsl:attribute-set name="setindex.titlepage.verso.style"/>

<xsl:attribute-set name="indexdiv.titlepage.recto.style"/>
<xsl:attribute-set name="indexdiv.titlepage.verso.style"/>

<xsl:attribute-set name="colophon.titlepage.recto.style"/>
<xsl:attribute-set name="colophon.titlepage.verso.style"/>

<xsl:attribute-set name="sidebar.titlepage.recto.style"/>
<xsl:attribute-set name="sidebar.titlepage.verso.style"/>

<xsl:attribute-set name="qandaset.titlepage.recto.style"/>
<xsl:attribute-set name="qandaset.titlepage.verso.style"/>

<xsl:attribute-set name="section.titlepage.recto.style">
  <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="section.titlepage.verso.style">
  <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
  <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="sect1.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="sect1.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="sect2.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="sect2.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="sect3.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="sect3.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="sect4.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="sect4.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="sect5.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="sect5.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="simplesect.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="simplesect.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="dialogue.titlepage.recto.style"/>
<xsl:attribute-set name="dialogue.titlepage.verso.style"/>
<xsl:attribute-set name="drama.titlepage.recto.style"/>
<xsl:attribute-set name="drama.titlepage.verso.style"/>
<xsl:attribute-set name="poetry.titlepage.recto.style"/>
<xsl:attribute-set name="poetry.titlepage.verso.style"/>

<xsl:attribute-set name="topic.titlepage.recto.style"/>
<xsl:attribute-set name="topic.titlepage.verso.style"/>

<xsl:attribute-set name="refnamediv.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="refnamediv.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="refsynopsisdiv.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="refsynopsisdiv.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="refsection.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="refsection.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="refsect1.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="refsect1.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="refsect2.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="refsect2.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="refsect3.titlepage.recto.style"
                   use-attribute-sets="section.titlepage.recto.style"/>
<xsl:attribute-set name="refsect3.titlepage.verso.style"
                   use-attribute-sets="section.titlepage.verso.style"/>

<xsl:attribute-set name="table.of.contents.titlepage.recto.style"/>
<xsl:attribute-set name="table.of.contents.titlepage.verso.style"/>

<xsl:attribute-set name="list.of.tables.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.tables.contents.titlepage.verso.style"/>

<xsl:attribute-set name="list.of.figures.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.figures.contents.titlepage.verso.style"/>

<xsl:attribute-set name="list.of.equations.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.equations.contents.titlepage.verso.style"/>

<xsl:attribute-set name="list.of.examples.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.examples.contents.titlepage.verso.style"/>

<xsl:attribute-set name="list.of.procedures.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.procedures.contents.titlepage.verso.style"/>

<xsl:attribute-set name="list.of.unknowns.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.unknowns.contents.titlepage.verso.style"/>

<xsl:attribute-set name="component.list.of.tables.titlepage.recto.style"/>
<xsl:attribute-set name="component.list.of.tables.contents.titlepage.verso.style"/>

<xsl:attribute-set name="component.list.of.figures.titlepage.recto.style"/>
<xsl:attribute-set name="component.list.of.figures.contents.titlepage.verso.style"/>

<xsl:attribute-set name="component.list.of.equations.titlepage.recto.style"/>
<xsl:attribute-set name="component.list.of.equations.contents.titlepage.verso.style"/>

<xsl:attribute-set name="component.list.of.examples.titlepage.recto.style"/>
<xsl:attribute-set name="component.list.of.examples.contents.titlepage.verso.style"/>

<xsl:attribute-set name="component.list.of.procedures.titlepage.recto.style"/>
<xsl:attribute-set name="component.list.of.procedures.contents.titlepage.verso.style"/>

<xsl:attribute-set name="component.list.of.unknowns.titlepage.recto.style"/>
<xsl:attribute-set name="component.list.of.unknowns.contents.titlepage.verso.style"/>

<!-- ==================================================================== -->

<xsl:template match="*" mode="titlepage.mode">
  <!-- if an element isn't found in this mode, try the default mode -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:abbrev" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:abstract" mode="titlepage.mode">
  <fo:block xsl:use-attribute-sets="abstract.properties">
    <fo:block xsl:use-attribute-sets="abstract.title.properties">
      <xsl:choose>
	<xsl:when test="d:title|d:info/d:title">
	  <xsl:apply-templates select="d:title|d:info/d:title"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:call-template name="gentext">
	    <xsl:with-param name="key" select="'Abstract'"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </fo:block>
    <xsl:apply-templates select="*[not(self::d:title)]" mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:abstract/d:title" mode="titlepage.mode"/>

<xsl:template match="d:abstract/d:title" mode="titlepage.abstract.title.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:address" mode="titlepage.mode">
  <!-- use the normal address handling code -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:affiliation" mode="titlepage.mode">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:artpagenums" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:author" mode="titlepage.mode">
  <fo:block>
    <xsl:call-template name="anchor"/>
    <xsl:choose>
      <xsl:when test="d:orgname">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="person.name"/>
        <xsl:if test="d:affiliation/d:orgname">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="d:affiliation/d:orgname" mode="titlepage.mode"/>
        </xsl:if>
        <xsl:if test="d:email|d:affiliation/d:address/d:email">
          <xsl:text> </xsl:text>
          <xsl:apply-templates select="(d:email|d:affiliation/d:address/d:email)[1]"/>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<xsl:template match="d:authorblurb" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:authorgroup" mode="titlepage.mode">
  <fo:wrapper>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:wrapper>
</xsl:template>

<xsl:template match="d:authorinitials" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:bibliomisc" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:bibliomset" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:collab" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:collabname" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:confgroup" mode="titlepage.mode">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:confdates" mode="titlepage.mode">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:conftitle" mode="titlepage.mode">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:confnum" mode="titlepage.mode">
  <!-- suppress -->
</xsl:template>

<xsl:template match="d:contractnum" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:contractsponsor" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:contrib" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:copyright" mode="titlepage.mode">
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Copyright'"/>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="dingbat">
    <xsl:with-param name="dingbat">copyright</xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="copyright.years">
    <xsl:with-param name="years" select="d:year"/>
    <xsl:with-param name="print.ranges" select="$make.year.ranges"/>
    <xsl:with-param name="single.year.ranges"
                    select="$make.single.year.ranges"/>
  </xsl:call-template>
  <xsl:call-template name="gentext.space"/>
  <xsl:apply-templates select="d:holder" mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:year" mode="titlepage.mode">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:holder" mode="titlepage.mode">
  <xsl:apply-templates/>
  <xsl:if test="position() &lt; last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:corpauthor" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:corpcredit" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:corpname" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:date" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:edition" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Edition'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:editor" mode="titlepage.mode">
  <!-- The first editor is dealt with in the following template,
       which in turn displays all editors of the same mode. -->
</xsl:template>

<xsl:template match="d:editor[1]" priority="2" mode="titlepage.mode">
  <xsl:call-template name="gentext.edited.by"/>
  <xsl:call-template name="gentext.space"/>
  <xsl:call-template name="person.name.list">
    <xsl:with-param name="person.list" select="../d:editor"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:firstname" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:graphic" mode="titlepage.mode">
  <!-- use the normal graphic handling code -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:honorific" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:isbn" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:issn" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:biblioid" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:itermset" mode="titlepage.mode">
  <xsl:apply-templates select="d:indexterm"/>
</xsl:template>

<xsl:template match="d:invpartnumber" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:issuenum" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:jobtitle" mode="titlepage.mode">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:keywordset" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:legalnotice" mode="titlepage.mode">

  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <fo:block id="{$id}">
    <xsl:if test="d:title"> <!-- FIXME: add param for using default title? -->
      <xsl:call-template name="formal.object.heading"/>
    </xsl:if>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:legalnotice/d:title" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:lineage" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:modespec" mode="titlepage.mode">
  <!-- discard -->
</xsl:template>

<xsl:template match="d:orgdiv" mode="titlepage.mode">
  <xsl:if test="preceding-sibling::*[1][self::d:orgname]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:orgname" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:othercredit" mode="titlepage.mode">
  <xsl:variable name="contrib" select="string(d:contrib)"/>
  <xsl:choose>
    <xsl:when test="d:contrib">
      <xsl:if test="not(preceding-sibling::d:othercredit[string(d:contrib)=$contrib])">
        <fo:block>
          <xsl:apply-templates mode="titlepage.mode" select="d:contrib"/>
          <xsl:text>: </xsl:text>
          <xsl:call-template name="person.name"/>
          <xsl:apply-templates mode="titlepage.mode" select="d:affiliation"/>
          <xsl:apply-templates select="following-sibling::d:othercredit[string(d:contrib)=$contrib]" mode="titlepage.othercredits"/>
        </fo:block>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <fo:block><xsl:call-template name="person.name"/></fo:block>
      <xsl:apply-templates mode="titlepage.mode" select="./d:affiliation"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:othercredit" mode="titlepage.othercredits">
  <xsl:text>, </xsl:text>
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="d:othername" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:pagenums" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:printhistory" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:productname" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:productnumber" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:pubdate" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:publisher" mode="titlepage.mode">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:publishername" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:pubsnumber" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:revhistory" mode="titlepage.mode">

  <xsl:variable name="explicit.table.width">
    <xsl:call-template name="pi.dbfo_table-width"/>
  </xsl:variable>

  <xsl:variable name="table.width">
    <xsl:choose>
      <xsl:when test="$explicit.table.width != ''">
        <xsl:value-of select="$explicit.table.width"/>
      </xsl:when>
      <xsl:when test="$default.table.width = ''">
        <xsl:text>100%</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$default.table.width"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

 <fo:table table-layout="fixed" width="{$table.width}" xsl:use-attribute-sets="revhistory.table.properties">
    <fo:table-column column-number="1" column-width="proportional-column-width(1)"/>
    <fo:table-column column-number="2" column-width="proportional-column-width(1)"/>
    <fo:table-column column-number="3" column-width="proportional-column-width(1)"/>
    <fo:table-body start-indent="0pt" end-indent="0pt">
      <fo:table-row>
        <fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="revhistory.table.cell.properties">
          <fo:block xsl:use-attribute-sets="revhistory.title.properties">
	    <xsl:choose>
	      <xsl:when test="d:title|d:info/d:title">
		<xsl:apply-templates select="d:title|d:info/d:title" mode="titlepage.mode"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key" select="'RevHistory'"/>
		</xsl:call-template>
	      </xsl:otherwise>
	    </xsl:choose>
	  </fo:block>
        </fo:table-cell>
      </fo:table-row>
      <xsl:apply-templates select="*[not(self::d:title)]" mode="titlepage.mode"/>
    </fo:table-body>
  </fo:table>

</xsl:template>


<xsl:template match="d:revhistory/d:revision" mode="titlepage.mode">
  <xsl:variable name="revnumber" select="d:revnumber"/>
  <xsl:variable name="revdate"   select="d:date"/>
  <xsl:variable name="revauthor" select="d:authorinitials|d:author"/>
  <xsl:variable name="revremark" select="d:revremark|d:revdescription"/>
  <fo:table-row>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:if test="$revnumber">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'Revision'"/>
          </xsl:call-template>
          <xsl:call-template name="gentext.space"/>
          <xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:apply-templates select="$revdate[1]" mode="titlepage.mode"/>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell xsl:use-attribute-sets="revhistory.table.cell.properties">
      <fo:block>
        <xsl:for-each select="$revauthor">
          <xsl:apply-templates select="." mode="titlepage.mode"/>
          <xsl:if test="position() != last()">
            <xsl:text>, </xsl:text>
          </xsl:if>
        </xsl:for-each>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>
  <xsl:if test="$revremark">
    <fo:table-row>
      <fo:table-cell number-columns-spanned="3" xsl:use-attribute-sets="revhistory.table.cell.properties">
        <fo:block>
          <xsl:apply-templates select="$revremark[1]" mode="titlepage.mode"/>
        </fo:block>
      </fo:table-cell>
    </fo:table-row>
  </xsl:if>
</xsl:template>

<xsl:template match="d:revision/d:revnumber" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:revision/d:date" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:revision/d:authorinitials" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:revision/d:author" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:revision/d:revremark" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:revision/d:revdescription" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:seriesvolnums" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:shortaffil" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:subjectset" mode="titlepage.mode">
  <!-- discard -->
</xsl:template>

<xsl:template match="d:subtitle" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:surname" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:title" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:volumenum" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<!-- ==================================================================== -->
<!-- Book templates -->

<!-- Note: these templates cannot use *.titlepage.recto.mode or
     *.titlepage.verso.mode. If they do then subsequent use of a custom
     titlepage.templates.xml file will not work correctly. -->

<!-- book recto -->

<xsl:template match="d:bookinfo/d:authorgroup|d:book/d:info/d:authorgroup"
              mode="titlepage.mode" priority="2">
  <fo:block>
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<!-- book verso -->

<xsl:template name="book.verso.title">
  <fo:block>
    <xsl:apply-templates mode="titlepage.mode"/>

    <xsl:if test="following-sibling::d:subtitle
                  |following-sibling::d:info/d:subtitle
                  |following-sibling::d:bookinfo/d:subtitle">
      <xsl:text>: </xsl:text>

      <xsl:apply-templates select="(following-sibling::d:subtitle
                                   |following-sibling::d:info/d:subtitle
                                   |following-sibling::d:bookinfo/d:subtitle)[1]"
                           mode="book.verso.subtitle.mode"/>
    </xsl:if>
  </fo:block>
</xsl:template>

<xsl:template match="d:subtitle" mode="book.verso.subtitle.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
  <xsl:if test="following-sibling::d:subtitle">
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="following-sibling::d:subtitle[1]"
                         mode="book.verso.subtitle.mode"/>
  </xsl:if>
</xsl:template>

<xsl:template name="verso.authorgroup">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'by'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:call-template name="person.name.list">
      <xsl:with-param name="person.list" select="d:author|d:corpauthor|d:editor"/>
    </xsl:call-template>
  </fo:block>
  <xsl:apply-templates select="d:othercredit" mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:bookinfo/d:author|d:book/d:info/d:author"
              mode="titlepage.mode" priority="2">
  <fo:block>
    <xsl:call-template name="person.name"/>
  </fo:block>
</xsl:template>

<xsl:template match="d:bookinfo/d:corpauthor|d:book/d:info/d:corpauthor"
              mode="titlepage.mode" priority="2">
  <fo:block>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<xsl:template match="d:bookinfo/d:pubdate|d:book/d:info/d:pubdate"
              mode="titlepage.mode" priority="2">
  <fo:block>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'pubdate'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:apply-templates mode="titlepage.mode"/>
  </fo:block>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
