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

<xsl:attribute-set name="book.titlepage.recto.style"/>
<xsl:attribute-set name="book.titlepage.verso.style"/>

<xsl:attribute-set name="article.titlepage.recto.style"/>
<xsl:attribute-set name="article.titlepage.verso.style"/>

<xsl:attribute-set name="set.titlepage.recto.style"/>
<xsl:attribute-set name="set.titlepage.verso.style"/>

<xsl:attribute-set name="part.titlepage.recto.style"/>
<xsl:attribute-set name="part.titlepage.verso.style"/>

<xsl:attribute-set name="partintro.titlepage.recto.style"/>
<xsl:attribute-set name="partintro.titlepage.verso.style"/>

<xsl:attribute-set name="reference.titlepage.recto.style"/>
<xsl:attribute-set name="reference.titlepage.verso.style"/>

<xsl:attribute-set name="refentry.titlepage.recto.style"/>
<xsl:attribute-set name="refentry.titlepage.verso.style"/>

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

<xsl:attribute-set name="glossary.titlepage.recto.style"/>
<xsl:attribute-set name="glossary.titlepage.verso.style"/>

<xsl:attribute-set name="index.titlepage.recto.style"/>
<xsl:attribute-set name="index.titlepage.verso.style"/>

<xsl:attribute-set name="setindex.titlepage.recto.style"/>
<xsl:attribute-set name="setindex.titlepage.verso.style"/>

<xsl:attribute-set name="sidebar.titlepage.recto.style"/>
<xsl:attribute-set name="sidebar.titlepage.verso.style"/>

<xsl:attribute-set name="topic.titlepage.recto.style"/>
<xsl:attribute-set name="topic.titlepage.verso.style"/>

<xsl:attribute-set name="section.titlepage.recto.style"/>
<xsl:attribute-set name="section.titlepage.verso.style"/>

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

<xsl:attribute-set name="list.of.unknowns.titlepage.recto.style"/>
<xsl:attribute-set name="list.of.unknowns.contents.titlepage.verso.style"/>

<xsl:attribute-set name="dialogue.titlepage.recto.style"/>
<xsl:attribute-set name="dialogue.titlepage.verso.style"/>

<xsl:attribute-set name="drama.titlepage.recto.style"/>
<xsl:attribute-set name="drama.titlepage.verso.style"/>

<xsl:attribute-set name="poetry.titlepage.recto.style"/>
<xsl:attribute-set name="poetry.titlepage.verso.style"/>


<!-- ==================================================================== -->

<xsl:template match="*" mode="titlepage.mode">
  <!-- if an element isn't found in this mode, try the default mode -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:abbrev" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:abstract" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:call-template name="anchor"/>
    <xsl:if test="$abstract.notitle.enabled = 0">
      <xsl:call-template name="formal.object.heading">
        <xsl:with-param name="title">
          <xsl:apply-templates select="." mode="title.markup"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates mode="titlepage.mode"/>
    <xsl:call-template name="process.footnotes"/>
  </div>
</xsl:template>

<xsl:template match="d:abstract/d:title" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:address" mode="titlepage.mode">
  <xsl:param name="suppress-numbers" select="'0'"/>

  <xsl:variable name="rtf">
    <xsl:apply-templates mode="titlepage.mode"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$suppress-numbers = '0'
                    and @linenumbering = 'numbered'
                    and $use.extensions != '0'
                    and $linenumbering.extension != '0'">
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="paragraph">
          <xsl:with-param name="content">
            <xsl:call-template name="number.rtf.lines">
              <xsl:with-param name="rtf" select="$rtf"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:when>

    <xsl:otherwise>
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="paragraph">
          <xsl:with-param name="content">
            <xsl:call-template name="make-verbatim">
              <xsl:with-param name="rtf" select="$rtf"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:affiliation" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="d:artpagenums" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:author|d:editor" mode="titlepage.mode">
  <xsl:call-template name="credits.div"/>
</xsl:template>

<xsl:template name="credits.div">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="self::d:editor and
                  count(preceding-sibling::d:editor) = 0 and
                  not($editedby.enabled = 0)">
      <h4 class="editedby"><xsl:call-template name="gentext.edited.by"/></h4>
    </xsl:if>
    <h3>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:choose>
        <xsl:when test="d:orgname">
          <xsl:apply-templates/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="person.name"/>
        </xsl:otherwise>
      </xsl:choose>
    </h3>
    <xsl:if test="not($contrib.inline.enabled = 0)">
      <xsl:apply-templates mode="titlepage.mode" select="d:contrib"/>
    </xsl:if>
    <xsl:apply-templates mode="titlepage.mode" select="d:affiliation"/>
    <xsl:apply-templates mode="titlepage.mode" select="d:email"/>
    <xsl:if test="not($blurb.on.titlepage.enabled = 0)">
      <xsl:choose>
        <xsl:when test="$contrib.inline.enabled = 0">
          <xsl:apply-templates mode="titlepage.mode"
                               select="d:contrib|d:authorblurb|d:personblurb"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="titlepage.mode"
                               select="d:authorblurb|d:personblurb"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="d:authorblurb|d:personblurb" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="d:authorgroup" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:if test="parent::d:refentryinfo">
      <h2>Authors</h2>
    </xsl:if>
      
    <xsl:call-template name="anchor"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="d:authorinitials" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:bibliomisc" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:bibliomset" mode="titlepage.mode">
  <xsl:apply-templates mode="titlepage.mode"/>
</xsl:template>

<xsl:template match="d:collab" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:collabname" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </span>
</xsl:template>

<xsl:template match="d:confgroup" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="d:confdates" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:confsponsor" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:conftitle" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:confnum" mode="titlepage.mode">
  <!-- suppress -->
</xsl:template>

<xsl:template match="d:contractnum" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:contractsponsor" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:contrib" mode="titlepage.mode">
  <xsl:choose>
    <xsl:when test="not($contrib.inline.enabled = 0)">
      <span>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:apply-templates mode="titlepage.mode"/>
      </span><xsl:text>&#160;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute"/>
        <p><xsl:apply-templates mode="titlepage.mode"/></p>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:copyright" mode="titlepage.mode">

  <xsl:if test="generate-id() = generate-id(//d:refentryinfo/d:copyright[1])
      and ($stylesheet.result.type = 'html' or $stylesheet.result.type = 'xhtml')">
    <h2>Copyright</h2>
  </xsl:if>

  <p>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
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
  </p>
</xsl:template>

<xsl:template match="d:year" mode="titlepage.mode">
  <xsl:choose>
    <xsl:when test="$show.revisionflag != 0 and @revisionflag">
      <span class="{@revisionflag}">
        <xsl:apply-templates mode="titlepage.mode"/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="titlepage.mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:holder" mode="titlepage.mode">
  <xsl:choose>
    <xsl:when test="$show.revisionflag != 0 and @revisionflag">
      <span class="{@revisionflag}">
        <xsl:apply-templates mode="titlepage.mode"/>
      </span>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="titlepage.mode"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="position() &lt; last()">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:corpauthor" mode="titlepage.mode">
  <h3>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </h3>
</xsl:template>

<xsl:template match="d:corpcredit" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:corpname" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:date" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:edition" mode="titlepage.mode">
  <p>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <xsl:call-template name="gentext.space"/>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Edition'"/>
    </xsl:call-template>
  </p>
</xsl:template>

<xsl:template match="d:email" mode="titlepage.mode">
  <!-- use the normal e-mail handling code -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:firstname" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:graphic" mode="titlepage.mode">
  <!-- use the normal graphic handling code -->
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="d:honorific" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:isbn" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:issn" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:biblioid" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:itermset" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:invpartnumber" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:issuenum" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:jobtitle" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:keywordset" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:legalnotice" mode="titlepage.mode">
  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:choose>
    <xsl:when test="$generate.legalnotice.link != 0">
      
      <!-- Compute name of legalnotice file -->
      <xsl:variable name="file">
	<xsl:call-template name="ln.or.rh.filename"/>
      </xsl:variable>

      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
	  <xsl:with-param name="base.name" select="$file"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="title">
        <xsl:apply-templates select="." mode="title.markup"/>
      </xsl:variable>

      <a href="{$file}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content"/>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <div>
                <xsl:apply-templates select="." mode="common.html.attributes"/>
                <xsl:call-template name="id.attribute">
                  <xsl:with-param name="conditional" select="0"/>
                </xsl:call-template>
                <xsl:apply-templates mode="titlepage.mode"/>
              </div>
            </body>
          </html>
          <xsl:value-of select="$chunk.append"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <div>
        <xsl:apply-templates select="." mode="common.html.attributes"/>
        <xsl:call-template name="id.attribute">
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <xsl:call-template name="anchor">
          <xsl:with-param name="conditional" select="0"/>
        </xsl:call-template>
        <xsl:apply-templates mode="titlepage.mode"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:legalnotice/d:title" mode="titlepage.mode">
  <p class="legalnotice-title"><b><xsl:apply-templates/></b></p>
</xsl:template>

<xsl:template match="d:lineage" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:modespec" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:orgdiv" mode="titlepage.mode">
  <xsl:if test="preceding-sibling::*[1][self::d:orgname]">
    <xsl:text> </xsl:text>
  </xsl:if>
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:orgname" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:othercredit" mode="titlepage.mode">
<xsl:choose>
  <xsl:when test="not($othercredit.like.author.enabled = 0)">
  <xsl:variable name="contrib" select="string(d:contrib)"/>
  <xsl:choose>
    <xsl:when test="d:contrib">
      <xsl:if test="not(preceding-sibling::d:othercredit[string(d:contrib)=$contrib])">
        <xsl:call-template name="paragraph">
          <xsl:with-param name="class" select="local-name(.)"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="titlepage.mode" select="d:contrib"/>
            <xsl:text>: </xsl:text>
            <xsl:call-template name="person.name"/>
            <xsl:apply-templates mode="titlepage.mode" select="d:affiliation"/>
            <xsl:apply-templates select="following-sibling::d:othercredit[string(d:contrib)=$contrib]" mode="titlepage.othercredits"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="paragraph">
        <xsl:with-param name="class" select="local-name(.)"/>
        <xsl:with-param name="content">
          <xsl:call-template name="person.name"/>
        </xsl:with-param>
      </xsl:call-template>
      <xsl:apply-templates mode="titlepage.mode" select="d:affiliation"/>
    </xsl:otherwise>
  </xsl:choose>
  </xsl:when>
  <xsl:otherwise>
    <xsl:call-template name="credits.div"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="d:othercredit" mode="titlepage.othercredits">
  <xsl:text>, </xsl:text>
  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="d:othername" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:pagenums" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:printhistory" mode="titlepage.mode">
  <div>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </div>
</xsl:template>

<xsl:template match="d:productname" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:productnumber" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:pubdate" mode="titlepage.mode">
  <xsl:call-template name="paragraph">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="content">
      <xsl:apply-templates mode="titlepage.mode"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:publisher" mode="titlepage.mode">
  <xsl:call-template name="paragraph">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="content">
      <xsl:apply-templates mode="titlepage.mode"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:publishername" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:pubsnumber" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:releaseinfo" mode="titlepage.mode">
  <xsl:call-template name="paragraph">
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="content">
      <xsl:apply-templates mode="titlepage.mode"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:revhistory" mode="titlepage.mode">
  <xsl:variable name="numcols">
    <xsl:choose>
      <xsl:when test=".//d:authorinitials|.//d:author">3</xsl:when>
      <xsl:otherwise>2</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="id"><xsl:call-template name="object.id"/></xsl:variable>

  <xsl:variable name="title">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key">RevHistory</xsl:with-param>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="contents">
    <div>
      <xsl:apply-templates select="." mode="common.html.attributes"/>
      <xsl:call-template name="id.attribute"/>
      <table>
        <xsl:if test="$css.decoration != 0">
          <xsl:attribute name="style">
            <xsl:text>border-style:solid; width:100%;</xsl:text>
          </xsl:attribute>
        </xsl:if>
        <!-- include summary attribute if not HTML5 -->
        <xsl:if test="$div.element != 'section'">
          <xsl:attribute name="summary">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key">revhistory</xsl:with-param>
            </xsl:call-template>
          </xsl:attribute>
        </xsl:if>
        <tr>
          <th align="{$direction.align.start}" valign="top" colspan="{$numcols}">
            <b>
              <xsl:call-template name="gentext">
                <xsl:with-param name="key" select="'RevHistory'"/>
              </xsl:call-template>
            </b>
          </th>
        </tr>
        <xsl:apply-templates mode="titlepage.mode">
          <xsl:with-param name="numcols" select="$numcols"/>
        </xsl:apply-templates>
      </table>
    </div>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$generate.revhistory.link != 0">
      
      <!-- Compute name of revhistory file -->
      <xsl:variable name="file">
	<xsl:call-template name="ln.or.rh.filename">
	  <xsl:with-param name="is.ln" select="false()"/>
	</xsl:call-template>
      </xsl:variable>

      <xsl:variable name="filename">
        <xsl:call-template name="make-relative-filename">
          <xsl:with-param name="base.dir" select="$chunk.base.dir"/>
          <xsl:with-param name="base.name" select="$file"/>
        </xsl:call-template>
      </xsl:variable>

      <a href="{$file}">
        <xsl:copy-of select="$title"/>
      </a>

      <xsl:call-template name="write.chunk">
        <xsl:with-param name="filename" select="$filename"/>
        <xsl:with-param name="quiet" select="$chunk.quietly"/>
        <xsl:with-param name="content">
        <xsl:call-template name="user.preroot"/>
          <html>
            <head>
              <xsl:call-template name="system.head.content"/>
              <xsl:call-template name="head.content">
                <xsl:with-param name="title">
                    <xsl:value-of select="$title"/>
                    <xsl:if test="../../d:title">
                        <xsl:value-of select="concat(' (', ../../d:title, ')')"/>
                    </xsl:if>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="user.head.content"/>
            </head>
            <body>
              <xsl:call-template name="body.attributes"/>
              <xsl:copy-of select="$contents"/>
            </body>
          </html>
          <xsl:text>&#x0a;</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$contents"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:revhistory/d:revision" mode="titlepage.mode">
  <xsl:param name="numcols" select="'3'"/>
  <xsl:variable name="revnumber" select="d:revnumber"/>
  <xsl:variable name="revdate"   select="d:date"/>
  <xsl:variable name="revauthor" select="d:authorinitials|d:author"/>
  <xsl:variable name="revremark" select="d:revremark|d:revdescription"/>
  <tr>
    <td align="{$direction.align.start}">
      <xsl:if test="$revnumber">
        <xsl:call-template name="gentext">
          <xsl:with-param name="key" select="'Revision'"/>
        </xsl:call-template>
        <xsl:call-template name="gentext.space"/>
        <xsl:apply-templates select="$revnumber[1]" mode="titlepage.mode"/>
      </xsl:if>
    </td>
    <td align="{$direction.align.start}">
      <xsl:apply-templates select="$revdate[1]" mode="titlepage.mode"/>
    </td>
    <xsl:choose>
      <xsl:when test="$revauthor">
        <td align="{$direction.align.start}">
          <xsl:for-each select="$revauthor">
            <xsl:apply-templates select="." mode="titlepage.mode"/>
            <xsl:if test="position() != last()">
	      <xsl:text>, </xsl:text>
	    </xsl:if>
	  </xsl:for-each>
        </td>
      </xsl:when>
      <xsl:when test="$numcols &gt; 2">
        <td>&#160;</td>
      </xsl:when>
      <xsl:otherwise></xsl:otherwise>
    </xsl:choose>
  </tr>
  <xsl:if test="$revremark">
    <tr>
      <td align="{$direction.align.start}" colspan="{$numcols}">
        <xsl:apply-templates select="$revremark[1]" mode="titlepage.mode"/>
      </td>
    </tr>
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
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:shortaffil" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:subjectset" mode="titlepage.mode">
</xsl:template>

<xsl:template match="d:subtitle" mode="titlepage.mode">
  <h2>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
  </h2>
</xsl:template>

<xsl:template match="d:surname" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<xsl:template match="d:title" mode="titlepage.mode">
  <xsl:variable name="id">
    <xsl:choose>
      <!-- if title is in an *info wrapper, get the grandparent -->
      <xsl:when test="contains(local-name(..), 'info')">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="../.."/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select=".."/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <h1>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:choose>
      <xsl:when test="$generate.id.attributes = 0">
        <a name="{$id}"/>
      </xsl:when>
      <xsl:otherwise>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="$show.revisionflag != 0 and @revisionflag">
	<span class="{@revisionflag}">
	  <xsl:apply-templates mode="titlepage.mode"/>
	</span>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="titlepage.mode"/>
      </xsl:otherwise>
    </xsl:choose>
  </h1>
</xsl:template>

<xsl:template match="d:titleabbrev" mode="titlepage.mode">
  <!-- nop; title abbreviations don't belong on the title page! -->
</xsl:template>

<xsl:template match="d:volumenum" mode="titlepage.mode">
  <span>
    <xsl:apply-templates select="." mode="common.html.attributes"/>
    <xsl:call-template name="id.attribute"/>
    <xsl:apply-templates mode="titlepage.mode"/>
    <br/>
  </span>
</xsl:template>

<!-- This template computes the filename for legalnotice and revhistory chunks -->
<xsl:template name="ln.or.rh.filename">
  <xsl:param name="node" select="."/>
  <xsl:param name="is.ln" select="true()"/>

  <xsl:variable name="dbhtml-filename">
    <xsl:call-template name="pi.dbhtml_filename">
      <xsl:with-param name="node" select="$node"/>
    </xsl:call-template>
  </xsl:variable>
 
  <xsl:choose>
    <!--  1. If there is a dbhtml_filename PI, use that -->
    <xsl:when test="$dbhtml-filename != ''">
      <xsl:value-of select="$dbhtml-filename"/>
    </xsl:when>
    <xsl:when test="($node/@id or $node/@xml:id) and not($use.id.as.filename = 0)">
      <!-- * 2. If this legalnotice/revhistory has an ID, then go ahead and use -->
      <!-- * just the value of that ID as the basename for the file -->
      <!-- * (that is, without prepending an "ln-" or "rh-" to it) -->
      <xsl:value-of select="($node/@id|$node/@xml:id)[1]"/>
      <xsl:value-of select="$html.ext"/>
    </xsl:when>
    <xsl:when test="not ($node/@id or $node/@xml:id) or $use.id.as.filename = 0">
      <!-- * 3. Otherwise, if this legalnotice/revhistory does not have an ID, or -->
      <!-- * if $use.id.as.filename = 0 -->
      <!-- * then we generate an ID... -->
      <xsl:variable name="id">
	<xsl:value-of select="generate-id($node)"/>
      </xsl:variable>
      <!-- * ...and then we take that generated ID, prepend a -->
      <!-- * prefix to it, and use that as the basename for the file -->
      <xsl:choose>
	<xsl:when test="$is.ln">
	  <xsl:value-of select="concat('ln-',$id,$html.ext)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="concat('rh-',$id,$html.ext)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>
    
<!-- ==================================================================== -->

</xsl:stylesheet>
