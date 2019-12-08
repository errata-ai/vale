<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:date="http://exslt.org/dates-and-times"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="date exsl d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

  <xsl:variable name="blurb-indent">
    <xsl:choose>
      <xsl:when test="not($man.indent.blurbs = 0)">
        <xsl:value-of select="$man.indent.width"/>
      </xsl:when>
      <xsl:when test="not($man.indent.refsect = 0)">
        <!-- * "zq" is the name of a register we set for -->
        <!-- * preserving the original default indent value -->
        <!-- * when $man.indent.refsect is non-zero; -->
        <!-- * "u" is a roff unit specifier -->
        <xsl:text>\n(zqu</xsl:text>
      </xsl:when>
      <xsl:otherwise/> <!-- * otherwise, just leave it empty -->
    </xsl:choose>
  </xsl:variable>

  <!-- ================================================================== -->
  <!-- * About the $info param used in this stylesheet -->
  <!-- * -->
  <!-- * The $info param is a "master info" node set that contains -->
  <!-- * the entire contents of the *info child of the current -->
  <!-- * Refentry, plus the entire contents of the *info children of -->
  <!-- * all ancestors of the current Refentry, in document order. -->
  <!-- * -->
  <!-- * We try to find a "best match" for selecting content from -->
  <!-- * $infor; we look through it in reverse document order until we -->
  <!-- * can find something usable. -->
  <!-- * -->
  <!-- * Specifically what the basic metadata-gathering XPath expression -->
  <!-- * in this stylesheet does is: -->
  <!-- * -->
  <!-- *   1. Look through the entire "master info" node set.-->
  <!-- *   2. Get the last node in the set that contains, for -->
  <!-- *      example, an Author element. That amounts to being the -->
  <!-- *      closest *info node to the Refentry - either its *info -->
  <!-- *      child, or the *info node of its closest ancestor that -->
  <!-- *      contains an Author. -->

  <!-- ================================================================== -->
  <!-- * Get user "refentry metadata" preferences -->
  <!-- ================================================================== -->
  <!-- * The DocBook XSL stylesheets include several user-configurable -->
  <!-- * global stylesheet parameters for controlling refentry metadata -->
  <!-- * gathering. Those parameters are not read directly by the other -->
  <!-- * refentry metadata-gathering templates. Instead, they are read -->
  <!-- * only by the get.refentry.metadata.prefs template, which -->
  <!-- * assembles them into a structure that is then passed to the -->
  <!-- * other refentry metadata-gathering template. -->

  <xsl:variable name="get.refentry.metadata.prefs">
    <!-- * get.refentry.metadata.prefs is in common/refentry.xsl -->
    <xsl:call-template name="get.refentry.metadata.prefs"/>
  </xsl:variable>

  <xsl:variable name="refentry.metadata.prefs"
                select="exsl:node-set($get.refentry.metadata.prefs)"/>
  
  <!-- * ============================================================== -->
  <!-- *    Get content for Author metadata field. -->
  <!-- * ============================================================== -->

  <!-- * The make.roff.metatada.author template and metadata.author -->
  <!-- * mode are used only for populating the Author field in the -->
  <!-- * metadata "top comment" we embed in roff source of each page. -->
  <xsl:template name="make.roff.metadata.author">
    <xsl:param name="info"/>
    <xsl:param name="refname"/>
    <xsl:choose>
      <xsl:when test="$info//d:author">
        <xsl:apply-templates
            select="(($info[//d:author])[last()]//d:author)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:corpauthor">
        <xsl:apply-templates
            select="(($info[//d:corpauthor])[last()]//d:corpauthor)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:editor">
        <xsl:apply-templates
            select="(($info[//d:editor])[last()]//d:editor)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:corpcredit">
        <xsl:apply-templates
            select="(($info[//d:corpcredit])[last()]//d:corpcredit)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:othercredit">
        <xsl:apply-templates
            select="(($info[//d:othercredit])[last()]//d:othercredit)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:collab">
        <xsl:apply-templates
            select="(($info[//d:collab])[last()]//d:collab)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:orgname">
        <xsl:apply-templates
            select="(($info[//d:orgname])[last()]//d:orgname)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:when test="$info//d:publishername">
        <xsl:apply-templates
            select="(($info[//d:publishername])[last()]//d:publishername)[1]"
            mode="metadata.author"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- * otherwise, we need to check to see if we have an "Author" -->
        <!-- * or "Authors" section in the refentry -->
        <xsl:variable name="gentext.author">
          <xsl:text>"</xsl:text>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'Author'"/>
          </xsl:call-template>
          <xsl:text>"</xsl:text>
        </xsl:variable>
        <xsl:variable name="gentext.AUTHOR">
          <xsl:if test="not($gentext.author = '')">
            <xsl:call-template name="string.upper">
              <xsl:with-param name="string" select="$gentext.author"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="gentext.authors">
          <xsl:text>"</xsl:text>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'Authors'"/>
          </xsl:call-template>
          <xsl:text>"</xsl:text>
        </xsl:variable>
        <xsl:variable name="gentext.AUTHORS">
          <xsl:if test="not($gentext.authors = '')">
            <xsl:call-template name="string.upper">
              <xsl:with-param name="string" select="$gentext.authors"/>
            </xsl:call-template>
          </xsl:if>
        </xsl:variable>
        <!-- * get all refentry/refsect1/title & refentry/refsection/title -->
        <!-- * instances, delimit each with double quotes, and put them -->
        <!-- * into a single refsect1.titles string -->
        <xsl:variable name="refsect1.titles">
          <xsl:for-each select="d:refsect1/d:title">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"</xsl:text>
            <xsl:text> </xsl:text>
          </xsl:for-each>
          <xsl:for-each select="d:refsection/d:title">
            <xsl:text>"</xsl:text>
            <xsl:value-of select="normalize-space(.)"/>
            <xsl:text>"</xsl:text>
            <xsl:text> </xsl:text>
          </xsl:for-each>
        </xsl:variable>
        <xsl:variable name="author.section.title">
          <xsl:choose>
            <xsl:when test="not($gentext.authors = '') and
              contains($refsect1.titles,$gentext.authors)">
              <xsl:value-of select="$gentext.authors"/>
            </xsl:when>
            <xsl:when test="not($gentext.AUTHORS = '') and
              contains($refsect1.titles,$gentext.AUTHORS)">
              <xsl:value-of select="$gentext.AUTHORS"/>
            </xsl:when>
            <xsl:when test="not($gentext.author = '') and
              contains($refsect1.titles,$gentext.author)">
              <xsl:value-of select="$gentext.author"/>
            </xsl:when>
            <xsl:when test="not($gentext.AUTHOR = '') and
              contains($refsect1.titles,$gentext.AUTHOR)">
              <xsl:value-of select="$gentext.AUTHOR"/>
            </xsl:when>
            <!-- * git docs (for one) use "DOCUMENTATION" for their authors section -->
            <xsl:when test="contains($refsect1.titles,'Documentation')">
              <xsl:text>Documentation</xsl:text>
            </xsl:when>
            <xsl:when test="contains($refsect1.titles,'DOCUMENTATION')">
              <xsl:text>DOCUMENTATION</xsl:text>
            </xsl:when>
            <xsl:otherwise/> <!-- * otherwise, leave empty -->
          </xsl:choose>
        </xsl:variable>
        <xsl:choose>
          <xsl:when test="not($author.section.title = '')">
            <!-- * if we have a non-empty $author.section.title value, -->
            <!-- * then reference that title (instead of putting a -->
            <!-- * specific author name) -->
            <xsl:text>[see the </xsl:text>
            <xsl:value-of select="$author.section.title"/>
            <xsl:text> section]</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- * otherwise we have no info/author content and no Author -->
            <!-- * or Authors section, so we insert a fixme and report -->
            <!-- * the problem to the user -->
            <xsl:text>[FIXME: author] [see http://www.docbook.org/tdg5/en/html/author]</xsl:text>
            <xsl:if test="$refentry.meta.get.quietly = 0">
              <xsl:call-template name="log.message">
                <xsl:with-param name="level">Warn</xsl:with-param>
                <xsl:with-param name="source" select="$refname"/>
                <xsl:with-param name="context-desc">meta author</xsl:with-param>
                <xsl:with-param name="message">
                  <xsl:text>no refentry/info/author</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="log.message">
                <xsl:with-param name="level">Note</xsl:with-param>
                <xsl:with-param name="source" select="$refname"/>
                <xsl:with-param name="context-desc">meta author</xsl:with-param>
                <xsl:with-param name="message">
                  <xsl:text>see http://www.docbook.org/tdg5/en/html/author</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="log.message">
                <xsl:with-param name="level">Warn</xsl:with-param>
                <xsl:with-param name="source" select="$refname"/>
                <xsl:with-param name="context-desc">meta author</xsl:with-param>
                <xsl:with-param name="message">
                  <xsl:text>no author data, so inserted a fixme</xsl:text>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:author|d:editor|d:othercredit|d:collab" mode="metadata.author">
    <xsl:choose>
      <xsl:when test="d:collabname">
        <!-- * If this node is a Collab, then it should have a -->
        <!-- * Collabname child, so get that. -->
        <xsl:variable name="contents">
          <xsl:apply-templates select="d:collabname"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($contents)"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- * Otherwise, this node is not a Collab, but instead -->
        <!-- * an author|editor|othercredit, which must have a name -->
        <!-- * of some kind; so get that name -->
        <xsl:call-template name="person.name.normalized"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test=".//d:email|d:address/d:otheraddr/d:ulink">
      <xsl:text> </xsl:text>
      <!-- * For each attribution found, use only the first e-mail -->
      <!-- * address or ulink value found -->
      <xsl:apply-templates select="(.//d:email|d:address/d:otheraddr/d:ulink)[1]"
                           mode="metadata.author"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:email|d:address/d:otheraddr/d:ulink" mode="metadata.author">
    <xsl:text>&lt;</xsl:text>
    <xsl:choose>
      <xsl:when test="self::d:email">
        <xsl:variable name="contents">
          <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($contents)"/>
      </xsl:when>
      <xsl:when test="self::d:ulink">
        <xsl:variable name="contents">
          <xsl:apply-templates select="."/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($contents)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:text>&gt;</xsl:text>
  </xsl:template>

  <xsl:template match="d:corpauthor|d:corpcredit|d:orgname|d:publishername" mode="metadata.author">
    <xsl:variable name="contents">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($contents)"/>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *     Assemble the AUTHOR/AUTHORS section -->
  <!-- * ============================================================== -->

  <xsl:template name="author.section">
    <xsl:param name="info"/>
    <!-- * The $info param is a "master info" node set that contains -->
    <!-- * the entires contents of the *info child of the current -->
    <!-- * Refentry, plus the entire contents of the *info children of -->
    <!-- * all ancestors of the current Refentry, in document order. -->
    <xsl:choose>
      <xsl:when test="$info//d:author|$info//d:editor|$info//d:collab|
                      $info//d:corpauthor|$info//d:corpcredit|
                      $info//d:othercredit|$info/d:orgname|
                      $info/d:publishername|$info/d:publisher">
        <xsl:variable name="authorcount">
          <xsl:value-of
              select="count(
                      $info//d:author|$info//d:editor|$info//d:collab|
                      $info//d:corpauthor|$info//d:corpcredit|
                      $info//d:othercredit)">
          </xsl:value-of>
        </xsl:variable>
        <xsl:call-template name="make.subheading">
          <xsl:with-param name="title">
            <xsl:call-template name="make.authorsecttitle">
              <xsl:with-param name="authorcount" select="$authorcount"/>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
        <!-- * Now output all the actual author, editor, etc. content -->
        <xsl:for-each
          select="$info//d:author|$info//d:editor|$info//d:collab|
          $info//d:corpauthor|$info//d:corpcredit|
          $info//d:othercredit|$info/d:orgname|
          $info/d:publishername|$info/d:publisher">
          <xsl:apply-templates select="." mode="authorsect"/>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise/> <!-- * do nothing, no author info found -->
    </xsl:choose>
  </xsl:template>

  <xsl:template name="make.authorsecttitle">
    <!-- * If we have exactly one attributable person/entity, then output -->
    <!-- * localized gentext for 'Author'; otherwise, output 'Authors'. -->
    <xsl:param name="authorcount"/>
    <xsl:param name="authorsecttitle">
      <xsl:choose>
        <xsl:when test="$authorcount = 1">
          <xsl:text>Author</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>Authors</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="$authorsecttitle"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="d:author|d:editor|d:othercredit" mode="authorsect">
    <xsl:variable name="person-name">
      <xsl:call-template name="person.name.normalized"/>
    </xsl:variable>
    <!-- * If we have a person-name or email or ulink content, then -->
    <!-- * output name and email or ulink content on the same line -->
    <xsl:choose>
      <xsl:when test="not($person-name = '') or .//d:email or d:address/d:otheraddr/d:ulink">
        <xsl:text>.PP&#10;</xsl:text>
        <!-- * Display person name in bold -->
        <xsl:call-template name="bold">
          <xsl:with-param name="node" select="exsl:node-set($person-name)"/>
          <xsl:with-param name="context" select="."/>
        </xsl:call-template>
        <!-- * Display e-mail address(es) and ulink(s) on same line as name -->
        <xsl:apply-templates select=".//d:email|d:address/d:otheraddr/d:ulink" mode="authorsect"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.br&#10;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!-- * Display affiliation(s) on separate lines -->
    <xsl:apply-templates select="d:affiliation" mode="authorsect"/>
    <!-- * Display direct-child addresses on separate lines -->
    <xsl:apply-templates select="d:address" mode="authorsect"/>
    <!-- * Call template for handling various attribution possibilities -->
    <xsl:call-template name="attribution">
      <xsl:with-param name="person-name" select="$person-name"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="d:collab" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:call-template name="bold">
      <xsl:with-param name="node" select="d:collabname"/>
      <xsl:with-param name="context" select="."/>
    </xsl:call-template>
    <!-- * Display e-mail address(es) and ulink(s) on same line as name -->
    <xsl:apply-templates select=".//d:email|d:address/d:otheraddr/d:ulink" mode="authorsect"/>
    <xsl:text>&#10;</xsl:text>
    <!-- * Display affilition(s) on separate lines -->
    <xsl:apply-templates select="d:affiliation" mode="authorsect"/>
  </xsl:template>

  <xsl:template match="d:corpauthor|d:corpcredit|d:orgname|d:publishername" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:call-template name="bold">
      <xsl:with-param name="node" select="."/>
      <xsl:with-param name="context" select="."/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="self::d:publishername">
      <!-- * Display localized "Publisher" gentext -->
      <xsl:call-template name="publisher.attribution"/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:publisher" mode="authorsect">
    <xsl:text>.PP&#10;</xsl:text>
    <xsl:call-template name="bold">
      <xsl:with-param name="node" select="d:publishername"/>
      <xsl:with-param name="context" select="."/>
    </xsl:call-template>
    <!-- * Display e-mail address(es) and ulink(s) on same line as name -->
    <xsl:apply-templates select=".//d:email|d:address/d:otheraddr/d:ulink" mode="authorsect"/>
    <!-- * Display addresses on separate lines -->
    <xsl:apply-templates select="d:address" mode="authorsect"/>
    <!-- * Display localized "Publisher" literal -->
    <xsl:call-template name="publisher.attribution"/>
  </xsl:template>

  <xsl:template name="publisher.attribution">
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.RS</xsl:text> 
    <xsl:if test="not($blurb-indent = '')">
      <xsl:text> </xsl:text>
      <xsl:value-of select="$blurb-indent"/>
    </xsl:if>
    <xsl:text>&#10;</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Publisher'"/>
    </xsl:call-template>
    <xsl:text>.&#10;</xsl:text>
    <xsl:text>.RE&#10;</xsl:text> 
  </xsl:template>

  <xsl:template match="d:email|d:address/d:otheraddr/d:ulink" mode="authorsect">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[descendant-or-self::d:email]
                      or preceding-sibling::d:address/d:otheraddr/d:ulink
                      or ancestor::d:address[preceding-sibling::*[descendant-or-self::d:email]]
                      or ancestor::d:address[preceding-sibling::d:address/d:otheraddr/d:ulink]">
        <!-- * This is not the first instance, so do nothing. -->
      </xsl:when>
      <xsl:otherwise>
        <!-- * This is first instances of an e-mail address or ulink, -->
        <!-- * so put a space before it. -->
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <!-- * Note that the reason for the \& character after the opening -->
    <!-- * angle bracket and before the closing angle bracket is to -->
    <!-- * prevent groff from inserting a linebreak at those points and -->
    <!-- * outputting a hyphen character where the break occurs -->
    <xsl:text>&lt;\&amp;</xsl:text>
    <xsl:choose>
      <xsl:when test="self::d:email">
        <xsl:variable name="contents">
          <xsl:apply-templates/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($contents)"/>
      </xsl:when>
      <xsl:when test="self::d:ulink">
        <xsl:variable name="contents">
          <xsl:apply-templates select="."/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($contents)"/>
      </xsl:when>
    </xsl:choose>
    <xsl:text>\&amp;&gt;</xsl:text>
    <xsl:choose>
      <xsl:when test="not(following-sibling::*[descendant-or-self::d:email]
                      or following-sibling::d:address/d:otheraddr/d:ulink
                      or ancestor::d:address[following-sibling::*[descendant-or-self::d:email]]
                      or ancestor::d:address[following-sibling::d:address/d:otheraddr/d:ulink])">
        <!-- * This is the final instance, so do nothing. -->
      </xsl:when>
      <xsl:otherwise>
        <!-- * Separate multiple e-mail addresses or ulinks with a comma -->
        <xsl:text>, </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:affiliation" mode="authorsect">
    <!-- * Get the string value of the contents of this Affiliation. If the -->
    <!-- * affiliation only contains an Address child whose only content is -->
    <!-- * an email address or ulink, then these contents will end up empty. -->
    <xsl:variable name="contents">
      <xsl:apply-templates mode="authorsect"/>
    </xsl:variable>
    <!-- * If contents are actually empty except for an email address -->
    <!-- * or ulink, then output nothing. -->
    <xsl:if test="$contents != ''">
      <xsl:text>.br&#10;</xsl:text>
      <xsl:for-each select="d:shortaffil|d:jobtitle|d:orgname|d:orgdiv|d:address">
        <!-- * only display output of nodes other than email or ulink -->
        <xsl:apply-templates select="node()[not(self::d:email) and not(self::d:otheraddr/d:ulink)]"/>
        <xsl:choose>
          <xsl:when test="position() = last()"/> <!-- do nothing -->
          <xsl:otherwise>
            <!-- * only add comma if the node has a child node other than -->
            <!-- * an email address or ulink -->
            <xsl:if test="child::node()[not(self::d:email) and not(self::d:otheraddr/d:ulink)]">
              <xsl:text>, </xsl:text>
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
      <xsl:choose>
        <xsl:when test="position() = last()"/> <!-- do nothing -->
        <xsl:otherwise>
          <!-- * put a line break after every Affiliation instance except -->
          <!-- * the last one in the set -->
          <xsl:text>.br&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:address" mode="authorsect">
    <xsl:variable name="contents"
                  select="normalize-space(node()[not(self::d:email)
                          and not(self::d:otheraddr/d:ulink)])"/>
    <!-- * If this contents of this Address do not contain anything except -->
    <!-- * an email address or ulink, then output nothing. -->
    <xsl:if test="$contents != ''">
      <xsl:text>&#10;</xsl:text>
      <xsl:text>.br&#10;</xsl:text>
      <!--* Skip email and ulink descendants of Address (rendered elsewhere) -->
      <xsl:apply-templates select="node()[not(self::d:email) and not(self::d:otheraddr/d:ulink)]"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="attribution">
    <xsl:param name="person-name"/>
    <xsl:param name="refname" select="ancestor::d:refentry/d:refnamediv[1]/d:refname[1]"/>
    <!-- * Determine appropriate attribution for a particular person's role. -->
    <xsl:choose>
      <!-- * if we have a *blurb or contrib, just use that -->
      <xsl:when test="d:contrib|d:personblurb|d:authorblurb">
        <xsl:apply-templates select="d:contrib|d:personblurb|d:authorblurb" mode="authorsect"/>
        <xsl:text>&#10;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- * otherwise we have no attribution information to use... -->
        <xsl:if test="not($person-name = '')">
          <!-- * if we have a person name or organization name -->
          <!-- * ($person-name can actually be an orgname, not just a -->
          <!-- * person name), then report to the user that we are -->
          <!-- * lacking attribution information for that person -->
          <xsl:if test="$refentry.meta.get.quietly = 0">
            <xsl:call-template name="log.message">
              <xsl:with-param name="level">Warn</xsl:with-param>
              <xsl:with-param name="source" select="$refname"/>
              <xsl:with-param name="context-desc">AUTHOR sect.</xsl:with-param>
              <xsl:with-param name="message">
                <xsl:text>no personblurb|contrib for </xsl:text>
                <xsl:value-of select="$person-name"/>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="log.message">
              <xsl:with-param name="level">Note</xsl:with-param>
              <xsl:with-param name="source" select="$refname"/>
              <xsl:with-param name="context-desc">AUTHOR sect.</xsl:with-param>
              <xsl:with-param name="message">
                <xsl:text>see http://www.docbook.org/tdg5/en/html/contrib</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="log.message">
              <xsl:with-param name="level">Note</xsl:with-param>
              <xsl:with-param name="source" select="$refname"/>
              <xsl:with-param name="context-desc">AUTHOR sect.</xsl:with-param>
              <xsl:with-param name="message">
                <xsl:text>see http://www.docbook.org/tdg5/en/html/personblurb</xsl:text>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:if>
        </xsl:if>
        <xsl:choose>
          <!-- * If we have no *blurb or contrib, but this is an Author or -->
          <!-- * Editor, then render the corresponding localized gentext -->
          <xsl:when test="self::d:author">
            <xsl:text>&#10;</xsl:text>
            <xsl:text>.RS</xsl:text> 
            <xsl:if test="not($blurb-indent = '')">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$blurb-indent"/>
            </xsl:if>
            <xsl:text>&#10;</xsl:text>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'Author'"/>
            </xsl:call-template>
            <xsl:text>.&#10;</xsl:text>
            <xsl:text>.RE&#10;</xsl:text> 
          </xsl:when>
          <xsl:when test="self::d:editor">
            <xsl:text>&#10;</xsl:text>
            <xsl:text>.RS</xsl:text> 
            <xsl:if test="not($blurb-indent = '')">
              <xsl:text> </xsl:text>
              <xsl:value-of select="$blurb-indent"/>
            </xsl:if>
            <xsl:text>&#10;</xsl:text>
            <xsl:call-template name="gentext">
              <xsl:with-param name="key" select="'Editor'"/>
            </xsl:call-template>
            <xsl:text>.&#10;</xsl:text>
            <xsl:text>.RE&#10;</xsl:text> 
          </xsl:when>
          <!-- * If we have no *blurb or contrib, but this is an Othercredit, -->
          <!-- * check value of Class attribute and use corresponding gentext. -->
          <xsl:when test="self::d:othercredit">
            <xsl:choose>
              <xsl:when test="@class and @class != 'other'">
                <xsl:text>&#10;</xsl:text>
                <xsl:text>.RS</xsl:text> 
                <xsl:if test="not($blurb-indent = '')">
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="$blurb-indent"/>
                </xsl:if>
                <xsl:text>&#10;</xsl:text>
                <xsl:call-template name="gentext">
                  <xsl:with-param name="key" select="@class"/>
                </xsl:call-template>
                <xsl:text>.&#10;</xsl:text>
                <xsl:text>.RE&#10;</xsl:text> 
              </xsl:when>
              <xsl:otherwise>
                <!-- * We have an Othercredit, but no usable value for the Class -->
                <!-- * attribute, so nothing to show, do nothing -->
              </xsl:otherwise>
            </xsl:choose>
          </xsl:when>
          <xsl:otherwise>
            <!-- * We have no *blurb or contrib or anything else we can use to -->
            <!-- * display appropriate attribution for this person, so do nothing -->
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:personblurb|d:authorblurb" mode="authorsect">
    <xsl:call-template name="mark.up.blurb.or.contrib"/>
    <!-- * yeah, it's possible for a *blurb to have a "title" -->
    <xsl:apply-templates select="d:title"/>
    <xsl:apply-templates select="*[not(self::d:title)]"/>
    <!-- * If this *blurb has a sibling "name" element of some kind, then -->
    <!-- * the mark.up.blurb.or.contrib template will generated an "RS" -->
    <!-- * call that will cause it to be indented; so we need to call -->
    <!-- * "RE" to restore the previous indent level -->
    <xsl:if test="../d:personname|../d:surname|../d:firstname
      |../d:othername|../d:lineage|../d:honorific
      |../d:affiliation|../d:email|../d:address">
      <xsl:text>.RE&#10;</xsl:text> 
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:personblurb/d:title|d:authorblurb/d:title">
    <!-- * always render period after title -->
    <xsl:variable name="contents">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($contents)"/>
    <xsl:text>.</xsl:text>
    <!-- * render space after Title+period if the title is followed -->
    <!-- * by something element content -->
    <xsl:if test="following-sibling::*[name() != '']">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template match="d:contrib" mode="authorsect">
    <xsl:call-template name="mark.up.blurb.or.contrib"/>
    <xsl:variable name="contents">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:value-of select="normalize-space($contents)"/>
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="../d:personname|../d:surname|../d:firstname
      |../d:othername|../d:lineage|../d:honorific
      |../d:affiliation|../d:email|../d:address">
      <xsl:text>.RE&#10;</xsl:text> 
    </xsl:if>
  </xsl:template>

  <xsl:template name="mark.up.blurb.or.contrib">
    <xsl:choose>
      <!-- * If this *blurb has a sibling "name" element of some kind, then -->
      <!-- * we are already outputting the name content, and we need to -->
      <!-- * indent the *blurb content after that. -->
      <xsl:when
          test="../d:personname|../d:surname|../d:firstname
                |../d:othername|../d:lineage|../d:honorific
                |../d:affiliation|../d:email|../d:address">
        <xsl:text>&#10;</xsl:text>
        <xsl:text>.RS</xsl:text> 
        <xsl:if test="not($blurb-indent = '')">
          <xsl:text> </xsl:text>
          <xsl:value-of select="$blurb-indent"/>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <!-- * otherwise, we have no "name" content, so don't indent; -->
        <!-- * instead, decide if we need a .PP or just a .br -->
        <xsl:choose>
          <xsl:when test="not(preceding-sibling::*)">
            <!-- * if this *blurb or contrib has no preceding -->
            <!-- * siblings, then we need to start a new paragraph -->
            <xsl:text>.PP</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <!-- * otherwise, this has no preceding siblings, so -->
            <!-- * just put a linebreak -->
            <xsl:text>.br</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- * ============================================================== -->
  <!-- *     Assemble the COPYRIGHT section -->
  <!-- * ============================================================== -->
  <!-- * The COPYRIGHT section is output only if a copyright or -->
  <!-- * legalnotice is found. It contains the copyright contents -->
  <!-- * followed by the legalnotice contents. -->
  <xsl:template name="copyright.section">
    <xsl:param name="info"/>
    <xsl:choose>
      <xsl:when test="$info//d:copyright|$info//d:legalnotice">
        <xsl:call-template name="make.subheading">
          <xsl:with-param name="title">
            <xsl:call-template name="gentext">
              <xsl:with-param name="key">Copyright</xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text>.br&#10;</xsl:text>
        <!-- * the copyright mode="titlepage.mode" template is -->
        <!-- * imported from the HTML stylesheets -->
        <xsl:for-each select="
          (($info[//d:copyright])[last()]//d:copyright)
          | (($info[//d:legalnotice])[last()]//d:legalnotice)">
          <xsl:choose>
            <xsl:when test="local-name(.) = 'copyright'">
              <xsl:variable name="contents">
                <xsl:apply-templates select="." mode="titlepage.mode"/>
              </xsl:variable>
              <xsl:value-of select="normalize-space($contents)"/>
              <xsl:text>&#10;</xsl:text>
              <xsl:text>.br&#10;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="titlepage.mode"/>
              <xsl:text>&#10;</xsl:text>
              <xsl:text>.sp&#10;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise/> <!-- * do nothing, no copyright or legalnotice found -->
    </xsl:choose>
  </xsl:template>

  <xsl:template match="d:legalnotice">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- * ============================================================== -->

  <!-- * suppress refmeta and all *info (we grab what we need from them -->
  <!-- * elsewhere) -->

  <xsl:template match="d:refmeta"/>

  <xsl:template match="d:info|d:refentryinfo|d:referenceinfo|d:refsynopsisdivinfo
                       |d:refsectioninfo|d:refsect1info|d:refsect2info|d:refsect3info
                       |d:setinfo|d:bookinfo|d:articleinfo|d:chapterinfo|d:sectioninfo
                       |d:sect1info|d:sect2info|d:sect3info|d:sect4info|d:sect5info
                       |d:partinfo|d:prefaceinfo|d:appendixinfo|d:docinfo"/>

  <!-- ============================================================== -->
  
</xsl:stylesheet>
