<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:exsl="http://exslt.org/common"
                exclude-result-prefixes="doc exsl d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<!-- cross reference target collection  -->

<doc:mode mode="collect.targets" xmlns="">
<refpurpose>Collects information for potential cross reference targets</refpurpose>
<refdescription id="collect.targets-desc">
<para>Processing the root element in the
<literal role="mode">collect.targets</literal> mode produces 
a set of target database elements that can be used by
the olink mechanism to resolve external cross references.
The collection process is controlled by the <literal>
collect.xref.targets</literal> parameter, which can be
<literal>yes</literal> to collect targets and process
the document for output, <literal>only</literal> to
only collect the targets, and <literal>no</literal>
(default) to not collect the targets and only process the document.
</para>
<para>
A <literal>targets.filename</literal> parameter must be
specified to receive the output if 
<literal>collect.xref.targets</literal> is
set to <literal>yes</literal> so as to
redirect the target data to a file separate from the
document output.
</para>
</refdescription>
</doc:mode>

<!-- ============================================================ -->

<xsl:template match="*" mode="collect.targets">
  <xsl:choose>
    <xsl:when test="$collect.xref.targets = 'yes' and $targets.filename = ''">
      <xsl:message>
        Must specify a $targets.filename parameter when
        $collect.xref.targets is set to 'yes'.
        The xref targets were not collected.
      </xsl:message>
    </xsl:when> 
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$targets.filename">
          <xsl:call-template name="write.chunk">
            <xsl:with-param name="filename" select="$targets.filename"/>
            <xsl:with-param name="method" select="'xml'"/>
            <xsl:with-param name="encoding" select="'utf-8'"/>
            <xsl:with-param name="omit-xml-declaration" select="'yes'"/>
            <xsl:with-param name="doctype-public" select="''"/>
            <xsl:with-param name="doctype-system" select="''"/>
            <xsl:with-param name="indent" select="'no'"/>
            <xsl:with-param name="quiet" select="0"/>
            <xsl:with-param name="content">
              <xsl:apply-templates select="." mode="olink.mode"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- Else write to standard output -->
          <xsl:apply-templates select="." mode="olink.mode"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="olink.href.target">
  <xsl:param name="nd" select="."/>

  <xsl:value-of select="$olink.base.uri"/>
  <xsl:call-template name="href.target">
    <xsl:with-param name="object" select="$nd"/>
    <xsl:with-param name="context" select="NOTANODE"/>
  </xsl:call-template>
</xsl:template>

<!-- Templates for extracting cross reference information
     from a document for use in an xref database.
-->

<xsl:template name="attrs">
  <xsl:param name="nd" select="."/>

  <xsl:attribute name="element">
    <xsl:value-of select="local-name(.)"/>
  </xsl:attribute>

  <xsl:attribute name="href">
    <xsl:call-template name="olink.href.target">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
  </xsl:attribute>

  <xsl:variable name="num">
    <xsl:apply-templates select="$nd" mode="label.markup">
      <xsl:with-param name="verbose" select="0"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="$num">
    <xsl:attribute name="number">
      <xsl:value-of select="$num"/>
    </xsl:attribute>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$nd/@id">
      <xsl:attribute name="targetptr">
        <xsl:value-of select="$nd/@id"/>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$nd/@xml:id">
      <xsl:attribute name="targetptr">
        <xsl:value-of select="$nd/@xml:id"/>
      </xsl:attribute>
    </xsl:when>
  </xsl:choose>

  <xsl:if test="$nd/@lang">
    <xsl:attribute name="lang">
      <xsl:value-of select="$nd/@lang"/>
    </xsl:attribute>
  </xsl:if>

</xsl:template>

<xsl:template name="div">
  <xsl:param name="nd" select="."/>

  <div>
    <xsl:call-template name="attrs">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
    <ttl>
      <xsl:apply-templates select="$nd" mode="title.markup">
        <xsl:with-param name="verbose" select="0"/>
      </xsl:apply-templates>
    </ttl>
    <xreftext>
      <xsl:choose>
        <xsl:when test="$nd/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$nd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$nd" mode="xref-to">
            <xsl:with-param name="verbose" select="0"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xreftext>
    <xsl:apply-templates mode="olink.mode"/>
  </div>
</xsl:template>

<xsl:template name="obj">
  <xsl:param name="nd" select="."/>

  <obj>
    <xsl:call-template name="attrs">
      <xsl:with-param name="nd" select="$nd"/>
    </xsl:call-template>
    <ttl>
      <xsl:apply-templates select="$nd" mode="title.markup">
        <xsl:with-param name="verbose" select="0"/>
      </xsl:apply-templates>
    </ttl>
    <xreftext>
      <xsl:choose>
        <xsl:when test="$nd/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$nd"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$nd" mode="xref-to">
            <xsl:with-param name="verbose" select="0"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
    </xreftext>
  </obj>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()"
              mode="olink.mode">
  <!-- nop -->
</xsl:template>

<!--
<xsl:template match="*" mode="olink.mode">
</xsl:template>
-->

<xsl:template match="d:set" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:book" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:preface|d:chapter|d:appendix" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:part|d:reference" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:article" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:topic" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:bibliography|d:bibliodiv" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:biblioentry|d:bibliomixed" mode="olink.mode">
  <xsl:call-template name="obj"/>
</xsl:template>

<xsl:template match="d:refentry" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:section|d:sect1|d:sect2|d:sect3|d:sect4|d:sect5" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:refsection|d:refsect1|d:refsect2|d:refsect3" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<xsl:template match="d:figure|d:example|d:table" mode="olink.mode">
  <xsl:call-template name="obj"/>
  <xsl:apply-templates mode="olink.mode"/>
</xsl:template>

<xsl:template match="d:equation[d:title or d:info/d:title]" mode="olink.mode">
  <xsl:call-template name="obj"/>
</xsl:template>

<xsl:template match="d:qandaset|d:qandaentry" mode="olink.mode">
  <xsl:call-template name="div"/>
</xsl:template>

<!-- handle an glossary collection -->
<xsl:template match="d:glossary[@role='auto']" mode="olink.mode" priority="2">
  <xsl:variable name="collection" select="document($glossary.collection, .)"/>
  <xsl:if test="$glossary.collection = ''">
    <xsl:message>
      <xsl:text>Warning: processing automatic glossary </xsl:text>
      <xsl:text>without a glossary.collection file.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="not($collection) and $glossary.collection != ''">
    <xsl:message>
      <xsl:text>Warning: processing automatic glossary but unable to </xsl:text>
      <xsl:text>open glossary.collection file '</xsl:text>
      <xsl:value-of select="$glossary.collection"/>
      <xsl:text>'</xsl:text>
    </xsl:message>
  </xsl:if>


  <xsl:if test="$exsl.node.set.available != 0">
    <xsl:variable name="auto.glossary">
      <xsl:apply-templates select="." mode="assemble.auto.glossary"/>
    </xsl:variable>
    <xsl:variable name="auto.glossary.nodeset" select="exsl:node-set($auto.glossary)"/>
    <xsl:apply-templates select="$auto.glossary.nodeset/*" mode="olink.mode"/>
  </xsl:if>

</xsl:template>

<!-- construct a glossary in memory -->
<xsl:template match="d:glossary" mode="assemble.auto.glossary">
  <xsl:copy>
    <xsl:copy-of select="@*[not(local-name() = 'role')]"/>
    <xsl:apply-templates select="node()" mode="assemble.auto.glossary"/>
    <xsl:call-template name="select.glossentries"/>
  </xsl:copy>
</xsl:template>

<xsl:template name="select.glossentries">
  <xsl:param name="collection" select="document($glossary.collection, .)"/>
  <xsl:param name="terms" select="//d:glossterm[not(parent::d:glossdef)]|//d:firstterm"/>

  <xsl:for-each select="$collection//d:glossentry">
    <xsl:variable name="cterm" select="d:glossterm"/>
    <xsl:if test="$terms[@baseform = $cterm or . = $cterm]">
      <xsl:copy-of select="."/>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="d:glossentry" mode="assemble.auto.glossary">
  <!-- skip the dummy entries -->
</xsl:template>

<xsl:template match="*" mode="assemble.auto.glossary">
  <!-- pass through any titles and intro stuff -->
  <xsl:copy-of select="."/>
</xsl:template>

<xsl:template match="*" mode="olink.mode">
  <xsl:if test="@id or @xml:id">
    <xsl:call-template name="obj"/>
  </xsl:if> 
  <xsl:apply-templates mode="olink.mode"/>
</xsl:template>

</xsl:stylesheet>
