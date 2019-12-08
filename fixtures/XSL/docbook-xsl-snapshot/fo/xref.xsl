<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:exsl="http://exslt.org/common"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="exsl xlink d"
                version='1.0'>

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- Use internal variable for olink xlink role for consistency -->
<xsl:variable 
      name="xolink.role">http://docbook.org/xlink/role/olink</xsl:variable>

<!-- ==================================================================== -->

<xsl:template match="d:anchor">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>

  <xsl:variable name="wrapper.name">
    <xsl:call-template name="inline.or.block"/>
  </xsl:variable>

  <xsl:element name="{$wrapper.name}">
    <xsl:attribute name="id">
      <xsl:value-of select="$id"/>
    </xsl:attribute>
  </xsl:element>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:xref" name="xref">
  <xsl:param name="xhref" select="@xlink:href"/>
  <!-- is the @xlink:href a local idref link? -->
  <xsl:param name="xlink.idref">
    <xsl:if test="starts-with($xhref,'#')
                  and (not(contains($xhref,'&#40;'))
                  or starts-with($xhref, '#xpointer&#40;id&#40;'))">
      <xsl:call-template name="xpointer.idref">
        <xsl:with-param name="xpointer" select="$xhref"/>
      </xsl:call-template>
   </xsl:if>
  </xsl:param>
  <xsl:param name="xlink.targets" select="key('id',$xlink.idref)"/>
  <xsl:param name="linkend.targets" select="key('id',@linkend)"/>
  <xsl:param name="target" select="($xlink.targets | $linkend.targets)[1]"/>
  <xsl:param name="refelem" select="local-name($target)"/>
  <xsl:param name="referrer" select="."/>
  <xsl:param name="xrefstyle">
    <xsl:apply-templates select="." mode="xrefstyle">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:param>

  <xsl:variable name="content">
    <fo:inline xsl:use-attribute-sets="xref.properties">
      <xsl:choose>
        <xsl:when test="@endterm">
          <xsl:variable name="etargets" select="key('id',@endterm)"/>
          <xsl:variable name="etarget" select="$etargets[1]"/>
          <xsl:choose>
            <xsl:when test="count($etarget) = 0">
              <xsl:message>
                <xsl:value-of select="count($etargets)"/>
                <xsl:text>Endterm points to nonexistent ID: </xsl:text>
                <xsl:value-of select="@endterm"/>
              </xsl:message>
              <xsl:text>???</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$etarget" mode="endterm"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
  
        <xsl:when test="$target/@xreflabel">
          <xsl:call-template name="xref.xreflabel">
            <xsl:with-param name="target" select="$target"/>
          </xsl:call-template>
        </xsl:when>
  
        <xsl:when test="$target">
          <xsl:if test="not(parent::d:citation)">
            <xsl:apply-templates select="$target" mode="xref-to-prefix">
              <xsl:with-param name="referrer" select="."/>
              <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            </xsl:apply-templates>
          </xsl:if>
  
          <xsl:apply-templates select="$target" mode="xref-to">
            <xsl:with-param name="referrer" select="."/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          </xsl:apply-templates>
  
          <xsl:if test="not(parent::d:citation)">
            <xsl:apply-templates select="$target" mode="xref-to-suffix">
              <xsl:with-param name="referrer" select="."/>
              <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            </xsl:apply-templates>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>ERROR: xref linking to </xsl:text>
            <xsl:value-of select="@linkend|@xlink:href"/>
            <xsl:text> has no generated link text.</xsl:text>
          </xsl:message>
          <xsl:text>???</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </fo:inline>
  </xsl:variable>

  <!-- Convert it into an active link -->
  <xsl:call-template name="simple.xlink">
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>

  <!-- Add standard page reference? -->
  <xsl:choose>
    <xsl:when test="not($target)">
      <!-- page numbers only for local targets -->
    </xsl:when>
    <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:') 
                  and contains($xrefstyle, 'nopage')">
      <!-- negative xrefstyle in instance turns it off -->
    </xsl:when>
    <xsl:when test="starts-with(normalize-space($xrefstyle), 'template:')">
      <!-- if page citation were wanted, it would've been in the template as %p -->
    </xsl:when>
    <!-- positive xrefstyle already handles it -->
    <xsl:when test="not(starts-with(normalize-space($xrefstyle), 'select:') 
                  and (contains($xrefstyle, 'page')
                       or contains($xrefstyle, 'Page')))
                  and ( $insert.xref.page.number = 'yes' 
                     or $insert.xref.page.number = '1')
                  or (local-name($target) = 'para'
                     and $xrefstyle = ''
                     and $insert.xref.page.number.para = 'yes')">
      <xsl:apply-templates select="$target" mode="page.citation">
        <xsl:with-param name="id" select="$target/@id|$target/@xml:id"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<!-- Handled largely like an xref -->
<!-- To be done: add support for begin, end, and units attributes -->
<xsl:template match="d:biblioref" name="biblioref">
  <xsl:variable name="targets" select="key('id',@linkend)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:variable name="referrer" select="."/>
  <xsl:variable name="refelem" select="local-name($target)"/>

  <xsl:variable name="xrefstyle">
    <xsl:apply-templates select="." mode="xrefstyle">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:call-template name="check.id.unique">
    <xsl:with-param name="linkend" select="@linkend"/>
  </xsl:call-template>

  <xsl:choose>
    <xsl:when test="$refelem=''">
      <xsl:message>
        <xsl:text>XRef to nonexistent id: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
      <xsl:text>???</xsl:text>
    </xsl:when>

    <xsl:when test="@endterm">
      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
        <xsl:variable name="etargets" select="key('id',@endterm)"/>
        <xsl:variable name="etarget" select="$etargets[1]"/>
        <xsl:choose>
          <xsl:when test="count($etarget) = 0">
            <xsl:message>
              <xsl:value-of select="count($etargets)"/>
              <xsl:text>Endterm points to nonexistent ID: </xsl:text>
              <xsl:value-of select="@endterm"/>
            </xsl:message>
            <xsl:text>???</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="$etarget" mode="endterm"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:basic-link>
    </xsl:when>

    <xsl:when test="$target/@xreflabel">
      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
        <xsl:call-template name="xref.xreflabel">
          <xsl:with-param name="target" select="$target"/>
        </xsl:call-template>
      </fo:basic-link>
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="not(parent::d:citation)">
        <xsl:apply-templates select="$target" mode="xref-to-prefix">
          <xsl:with-param name="referrer" select="."/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        </xsl:apply-templates>
      </xsl:if>

      <fo:basic-link internal-destination="{@linkend}"
                     xsl:use-attribute-sets="xref.properties">
        <xsl:apply-templates select="$target" mode="xref-to">
          <xsl:with-param name="referrer" select="."/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        </xsl:apply-templates>
      </fo:basic-link>

      <xsl:if test="not(parent::d:citation)">
        <xsl:apply-templates select="$target" mode="xref-to-suffix">
          <xsl:with-param name="referrer" select="."/>
          <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="endterm">
  <!-- Process the children of the endterm element -->
  <xsl:variable name="endterm">
    <xsl:apply-templates select="child::node()"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$exsl.node.set.available != 0">
      <xsl:apply-templates select="exsl:node-set($endterm)" mode="remove-ids"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$endterm"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="remove-ids">
  <xsl:copy>
    <xsl:for-each select="@*">
      <xsl:choose>
        <xsl:when test="local-name(.) != 'id'">
          <xsl:copy/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>removing <xsl:value-of select="name(.)"/></xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:apply-templates mode="remove-ids"/>
  </xsl:copy>
</xsl:template>

<!--- ==================================================================== -->

<xsl:template match="*" mode="xref-to-prefix">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>
</xsl:template>
<xsl:template match="*" mode="xref-to-suffix">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>
</xsl:template>

<xsl:template match="*" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:if test="$verbose != 0">
    <xsl:message>
      <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>"</xsl:text>
    </xsl:message>
    <xsl:text>???</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="d:title" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <!-- if you xref to a title, xref to the parent... -->
  <xsl:choose>
    <!-- FIXME: how reliable is this? -->
    <xsl:when test="contains(local-name(parent::*), 'info')">
      <xsl:apply-templates select="ancestor::*[2]" mode="xref-to">
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="parent::*" mode="xref-to">
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:abstract|d:article|d:authorblurb|d:bibliodiv|d:bibliomset
                     |d:biblioset|d:blockquote|d:calloutlist|d:caution|d:colophon
                     |d:constraintdef|d:formalpara|d:glossdiv|d:important|d:indexdiv
                     |d:itemizedlist|d:legalnotice|d:lot|d:msg|d:msgexplan|d:msgmain
                     |d:msgrel|d:msgset|d:msgsub|d:note|d:orderedlist|d:partintro
                     |d:productionset|d:qandadiv|d:refsynopsisdiv|d:screenshot|d:segmentedlist
                     |d:set|d:setindex|d:sidebar|d:tip|d:toc|d:variablelist|d:warning"
              mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <!-- catch-all for things with (possibly optional) titles -->
  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:author|d:editor|d:othercredit|d:personname" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:call-template name="person.name"/>
</xsl:template>

<xsl:template match="d:authorgroup" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:call-template name="person.name.list"/>
</xsl:template>

<xsl:template match="d:figure|d:example|d:table|d:equation" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:procedure" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:task" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:cmdsynopsis" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="(.//d:command)[1]" mode="xref"/>
</xsl:template>

<xsl:template match="d:funcsynopsis" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="(.//d:function)[1]" mode="xref"/>
</xsl:template>

<xsl:template match="d:dedication|d:acknowledgements|d:preface|d:chapter|d:appendix" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:bibliography" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:biblioentry|d:bibliomixed" mode="xref-to-prefix">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:text>[</xsl:text>
</xsl:template>

<xsl:template match="d:biblioentry|d:bibliomixed" mode="xref-to-suffix">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="d:biblioentry|d:bibliomixed" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <!-- handles both biblioentry and bibliomixed -->
  <xsl:choose>
    <xsl:when test="string(.) = ''">
      <xsl:variable name="bib" select="document($bibliography.collection,.)"/>
      <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
      <xsl:variable name="entry" select="$bib/d:bibliography/
                                         *[@id=$id or @xml:id=$id][1]"/>
      <xsl:choose>
        <xsl:when test="$entry">
          <xsl:choose>
            <xsl:when test="$bibliography.numbered != 0">
              <xsl:number from="d:bibliography" count="d:biblioentry|d:bibliomixed"
                          level="any" format="1"/>
            </xsl:when>
            <xsl:when test="local-name($entry/*[1]) = 'abbrev'">
              <xsl:apply-templates select="$entry/*[1]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="(@id|@xml:id)[1]"/>
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
          <xsl:value-of select="(@id|@xml:id)[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$bibliography.numbered != 0">
          <xsl:number from="d:bibliography" count="d:biblioentry|d:bibliomixed"
                      level="any" format="1"/>
        </xsl:when>
        <xsl:when test="local-name(*[1]) = 'abbrev'">
          <xsl:apply-templates select="*[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="(@id|@xml:id)[1]"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossary" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:glossentry" mode="xref-to">
  <xsl:choose>
    <xsl:when test="$glossentry.show.acronym = 'primary'">
      <xsl:choose>
        <xsl:when test="d:acronym|d:abbrev">
          <xsl:apply-templates select="(d:acronym|d:abbrev)[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="d:glossterm[1]" mode="xref-to"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="d:glossterm[1]" mode="xref-to"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:glossterm|d:firstterm" mode="xref-to">
  <xsl:apply-templates mode="no.anchor.mode"/>
</xsl:template>

<xsl:template match="d:index" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:listitem" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:section|d:simplesect
                     |d:sect1|d:sect2|d:sect3|d:sect4|d:sect5
                     |d:refsect1|d:refsect2|d:refsect3|d:refsection" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
  <!-- What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="d:topic" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:bridgehead" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
  <!-- What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="d:qandaset" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:qandadiv" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:qandaentry" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="d:question[1]" mode="xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:question|d:answer" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:choose>
    <xsl:when test="string-length(d:label) != 0">
      <xsl:apply-templates select="." mode="label.markup"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="." mode="object.xref.markup">
        <xsl:with-param name="purpose" select="'xref'"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:part|d:reference" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:refentry" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:choose>
    <xsl:when test="d:refmeta/d:refentrytitle">
      <xsl:apply-templates select="d:refmeta/d:refentrytitle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="d:refnamediv/d:refname[1]"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="d:refmeta/d:manvolnum"/>
</xsl:template>

<xsl:template match="d:refnamediv" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="d:refname[1]" mode="xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:refname" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates mode="xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:step" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Step'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="number"/>
</xsl:template>

<xsl:template match="d:varlistentry" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="d:term[1]" mode="xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:varlistentry/d:term" mode="xref-to">
  <xsl:param name="verbose" select="1"/>
  <!-- avoids the comma that will be generated if there are several terms -->
  <!-- Use no.anchor.mode to turn off nested xrefs and indexterms
       in link text -->
  <xsl:apply-templates mode="no.anchor.mode"/>
</xsl:template>

<xsl:template match="d:co" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="callout-bug"/>
</xsl:template>

<xsl:template match="d:area|d:areaset" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="callout-bug">
    <xsl:with-param name="conum">
      <xsl:apply-templates select="." mode="conumber"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="d:book" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="object.xref.markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<!-- These are elements for which no link text exists, so an xref to one
     uses the xrefstyle attribute if specified, or if not it falls back
     to the container element's link text -->
<xsl:template match="d:para|d:phrase|d:simpara|d:anchor|d:quote" mode="xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:variable name="context" select="(ancestor::d:simplesect
                                       |ancestor::d:section
                                       |ancestor::d:sect1
                                       |ancestor::d:sect2
                                       |ancestor::d:sect3
                                       |ancestor::d:sect4
                                       |ancestor::d:sect5
                                       |ancestor::d:topic
                                       |ancestor::d:refsection
                                       |ancestor::d:refsect1
                                       |ancestor::d:refsect2
                                       |ancestor::d:refsect3
                                       |ancestor::d:chapter
                                       |ancestor::d:appendix
                                       |ancestor::d:preface
                                       |ancestor::d:partintro
                                       |ancestor::d:dedication
                                       |ancestor::d:acknowledgements
                                       |ancestor::d:colophon
                                       |ancestor::d:bibliography
                                       |ancestor::d:index
                                       |ancestor::d:glossary
                                       |ancestor::d:glossentry
                                       |ancestor::d:listitem
                                       |ancestor::d:varlistentry)[last()]"/>

  <xsl:choose>
    <xsl:when test="$xrefstyle != ''">
      <xsl:apply-templates select="." mode="object.xref.markup">
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:if test="$verbose != 0">
        <xsl:message>
          <xsl:text>WARNING: xref to &lt;</xsl:text>
          <xsl:value-of select="local-name()"/>
          <xsl:text> id="</xsl:text>
          <xsl:value-of select="@id|@xml:id"/>
          <xsl:text>"&gt; has no generated text. Trying its ancestor elements.</xsl:text>
        </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="$context" mode="xref-to">
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
        <xsl:with-param name="referrer" select="$referrer"/>
        <xsl:with-param name="verbose" select="$verbose"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:indexterm" mode="xref-to">
  <xsl:value-of select="d:primary"/>
</xsl:template>

<xsl:template match="d:primary|d:secondary|d:tertiary" mode="xref-to">
  <xsl:value-of select="."/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:link" name="link">
  <xsl:param name="referrer" select="."/>
  <xsl:param name="linkend" select="@linkend"/>
  <xsl:param name="targets" select="key('id',$linkend)"/>
  <xsl:param name="target" select="$targets[1]"/>
  <xsl:param name="xrefstyle">
    <xsl:apply-templates select="." mode="xrefstyle">
      <xsl:with-param name="target" select="$target"/>
      <xsl:with-param name="referrer" select="$referrer"/>
    </xsl:apply-templates>
  </xsl:param>

  <xsl:variable name="content">
    <xsl:choose>
      <xsl:when test="count(child::node()) &gt; 0">
        <!-- If it has content, use it -->
        <xsl:apply-templates/>
      </xsl:when>
      <!-- look for an endterm -->
      <xsl:when test="@endterm">
        <xsl:variable name="etargets" select="key('id',@endterm)"/>
        <xsl:variable name="etarget" select="$etargets[1]"/>
        <xsl:choose>
          <xsl:when test="count($etarget) = 0">
            <xsl:message>
              <xsl:value-of select="count($etargets)"/>
              <xsl:text>Endterm points to nonexistent ID: </xsl:text>
              <xsl:value-of select="@endterm"/>
            </xsl:message>
            <xsl:text>???</xsl:text>
          </xsl:when>
          <xsl:otherwise>
              <xsl:apply-templates select="$etarget" mode="endterm"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <!-- Use the xlink:href if no other text -->
      <xsl:when test="@xlink:href">
	  <fo:inline hyphenate="false">
	    <xsl:call-template name="hyphenate-url">
	      <xsl:with-param name="url" select="@xlink:href"/>
	    </xsl:call-template>
	  </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>
          <xsl:text>Link element has no content and no Endterm. </xsl:text>
          <xsl:text>Nothing to show in the link to </xsl:text>
          <xsl:value-of select="$target"/>
        </xsl:message>
        <xsl:text>???</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="styled.content">
    <xsl:choose>
      <xsl:when test="@xlink:role = $xolink.role">
        <!-- olink styling handled by simple.xlink -->
        <xsl:copy-of select="$content"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline xsl:use-attribute-sets="xref.properties">
          <xsl:copy-of select="$content"/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="simple.xlink">
    <xsl:with-param name="node" select="."/>
    <xsl:with-param name="linkend" select="$linkend"/>
    <xsl:with-param name="content" select="$styled.content"/>
  </xsl:call-template>

  <!-- Add standard page reference? -->
  <xsl:choose>
    <!-- page numbering on link only enabled for @linkend -->
    <xsl:when test="not($linkend)">
    </xsl:when>
    <!-- negative xrefstyle in instance turns it off -->
    <xsl:when test="starts-with(normalize-space($xrefstyle), 'select:') 
                  and contains($xrefstyle, 'nopage')">
    </xsl:when>
    <xsl:when test="(starts-with(normalize-space($xrefstyle), 'select:') 
                  and $insert.link.page.number = 'maybe'  
                  and (contains($xrefstyle, 'page')
                       or contains($xrefstyle, 'Page')))
                  or ( $insert.link.page.number = 'yes' 
                     or $insert.link.page.number = '1')">
      <xsl:apply-templates select="$target" mode="page.citation">
        <xsl:with-param name="id" select="$linkend"/>
        <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:ulink" name="ulink">
  <xsl:param name="url" select="@url"/>

  <xsl:variable name ="ulink.url">
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename" select="$url"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:basic-link xsl:use-attribute-sets="xref.properties"
                 external-destination="{$ulink.url}">
    <xsl:choose>
      <xsl:when test="count(child::node())=0 or (string(.) = $url)">
	<fo:inline hyphenate="false">
	  <xsl:call-template name="hyphenate-url">
	    <xsl:with-param name="url" select="$url"/>
	  </xsl:call-template>
	</fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:basic-link>
  <!-- * Call the template for determining whether the URL for this -->
  <!-- * hyperlink is displayed, and how to display it (either inline or -->
  <!-- * as a numbered footnote). -->
  <xsl:call-template name="hyperlink.url.display">
    <xsl:with-param name="url" select="$url"/>
    <xsl:with-param name="ulink.url" select="$ulink.url"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="hyperlink.url.display">
  <!-- * This template is called for all external hyperlinks (ulinks and -->
  <!-- * for all simple xlinks); it determines whether the URL for the -->
  <!-- * hyperlink is displayed, and how to display it (either inline or -->
  <!-- * as a numbered footnote). -->
  <xsl:param name="url"/>
  <xsl:param name="ulink.url">
    <!-- * ulink.url is just the value of the URL wrapped in 'url(...)' -->
    <xsl:call-template name="fo-external-image">
      <xsl:with-param name="filename" select="$url"/>
    </xsl:call-template>
  </xsl:param>

  <xsl:if test="count(child::node()) != 0
                and string(.) != $url
                and $ulink.show != 0">
    <!-- * Display the URL for this hyperlink only if it is non-empty, -->
    <!-- * and the value of its content is not a URL that is the same as -->
    <!-- * URL it links to, and if ulink.show is non-zero. -->
    <xsl:choose>
      <xsl:when test="$ulink.footnotes != 0 and not(ancestor::d:footnote) and not(ancestor::*[@floatstyle='before'])">
        <!-- * ulink.show and ulink.footnote are both non-zero; that -->
        <!-- * means we display the URL as a footnote (instead of inline) -->
        <fo:footnote>
          <xsl:call-template name="ulink.footnote.number"/>
          <fo:footnote-body xsl:use-attribute-sets="footnote.properties">
            <fo:block>
              <xsl:call-template name="ulink.footnote.number"/>
              <xsl:text> </xsl:text>
              <fo:basic-link external-destination="{$ulink.url}">
                <xsl:value-of select="$url"/>
              </fo:basic-link>
            </fo:block>
          </fo:footnote-body>
        </fo:footnote>
      </xsl:when>
      <xsl:otherwise>
        <!-- * ulink.show is non-zero, but ulink.footnote is not; that -->
        <!-- * means we display the URL inline -->
        <fo:inline hyphenate="false">
          <!-- * put square brackets around the URL -->
          <xsl:text> [</xsl:text>
          <fo:basic-link external-destination="{$ulink.url}">
            <xsl:call-template name="hyphenate-url">
              <xsl:with-param name="url" select="$url"/>
            </xsl:call-template>
          </fo:basic-link>
          <xsl:text>]</xsl:text>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

</xsl:template>

<xsl:template name="ulink.footnote.number">
  <fo:inline xsl:use-attribute-sets="footnote.mark.properties">
    <xsl:choose>
      <xsl:when test="$fop.extensions != 0">
        <xsl:attribute name="vertical-align">super</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:variable name="fnum">
      <!-- * Determine the footnote number to display for this hyperlink, -->
      <!-- * by counting all foonotes, ulinks, and any elements that have -->
      <!-- * an xlink:href attribute that meets the following criteria: -->
      <!-- * -->
      <!-- * - the content of the element is not a URI that is the same -->
      <!-- *   URI as the value of the href attribute -->
      <!-- * - the href attribute is not an internal ID reference (does -->
      <!-- *   not start with a hash sign) -->
      <!-- * - the href is not part of an olink reference (the element -->
      <!-- * - does not have an xlink:role attribute that indicates it is -->
      <!-- *   an olink, and the href does not contain a hash sign) -->
      <!-- * - the element either has no xlink:type attribute or has -->
      <!-- *   an xlink:type attribute whose value is 'simple' -->
      <!-- FIXME: list in @from is probably not complete -->
      <xsl:number level="any" 
                  from="d:chapter|d:appendix|d:preface|d:article|d:refentry|d:bibliography[not(parent::d:article)]"
                  count="d:footnote[not(@label)][not(ancestor::d:tgroup)]
                  |d:ulink[node()][@url != .][not(ancestor::d:footnote)]
                  |*[node()][@xlink:href][not(@xlink:href = .)][not(starts-with(@xlink:href,'#'))]
                    [not(contains(@xlink:href,'#') and @xlink:role = $xolink.role)]
                    [not(@xlink:type) or @xlink:type='simple']
                    [not(ancestor::d:footnote)]"
                  format="1"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="string-length($footnote.number.symbols) &gt;= $fnum">
        <xsl:value-of select="substring($footnote.number.symbols, $fnum, 1)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:number value="$fnum" format="{$footnote.number.format}"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>

<xsl:template name="hyphenate-url">
  <xsl:param name="url" select="''"/>
  <xsl:choose>
    <xsl:when test="$ulink.hyphenate = ''">
      <xsl:value-of select="$url"/>
    </xsl:when>
    <xsl:when test="string-length($url) &gt; 1">
      <xsl:variable name="char" select="substring($url, 1, 1)"/>
      <xsl:value-of select="$char"/>
      <xsl:if test="contains($ulink.hyphenate.chars, $char)">
        <!-- Do not hyphen in-between // -->
        <xsl:if test="not($char = '/' and substring($url,2,1) = '/')">
          <xsl:copy-of select="$ulink.hyphenate"/>
        </xsl:if>
      </xsl:if>
      <!-- recurse to the next character -->
      <xsl:call-template name="hyphenate-url">
        <xsl:with-param name="url" select="substring($url, 2)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$url"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:olink" name="olink">
  <!-- olink content may be passed in from xlink olink -->
  <xsl:param name="content" select="NOTANELEMENT"/>

  <xsl:choose>
    <!-- olinks resolved by stylesheet and target database -->
    <xsl:when test="@targetdoc or @targetptr or
                    (@xlink:role=$xolink.role and
                     contains(@xlink:href, '#') )" >

      <xsl:variable name="targetdoc.att">
        <xsl:choose>
          <xsl:when test="@targetdoc != ''">
            <xsl:value-of select="@targetdoc"/>
          </xsl:when>
          <xsl:when test="@xlink:role=$xolink.role and
                       contains(@xlink:href, '#')" >
            <xsl:value-of select="substring-before(@xlink:href, '#')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="targetptr.att">
        <xsl:choose>
          <xsl:when test="@targetptr != ''">
            <xsl:value-of select="@targetptr"/>
          </xsl:when>
          <xsl:when test="@xlink:role=$xolink.role and
                       contains(@xlink:href, '#')" >
            <xsl:value-of select="substring-after(@xlink:href, '#')"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="olink.lang">
        <xsl:call-template name="l10n.language">
          <xsl:with-param name="xref-context" select="true()"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="target.database.filename">
        <xsl:call-template name="select.target.database">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:variable name="target.database" 
          select="document($target.database.filename, /)"/>
    
      <xsl:if test="$olink.debug != 0">
        <xsl:message>
          <xsl:text>Olink debug: root element of target.database is '</xsl:text>
          <xsl:value-of select="local-name($target.database/*[1])"/>
          <xsl:text>'.</xsl:text>
        </xsl:message>
      </xsl:if>
    
      <xsl:variable name="olink.key">
        <xsl:call-template name="select.olink.key">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>
    
      <xsl:if test="string-length($olink.key) = 0">
        <xsl:call-template name="olink.unresolved">
          <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
          <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
        </xsl:call-template>
      </xsl:if>

      <xsl:variable name="href">
        <xsl:call-template name="make.olink.href">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>

      <!-- Olink that points to internal id can be a link -->
      <xsl:variable name="linkend">
        <xsl:call-template name="olink.as.linkend">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="target.database" select="$target.database"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="hottext">
        <xsl:choose>
          <xsl:when test="string-length($content) != 0">
            <xsl:copy-of select="$content"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="olink.hottext">
              <xsl:with-param name="olink.key" select="$olink.key"/>
              <xsl:with-param name="olink.lang" select="$olink.lang"/>
              <xsl:with-param name="target.database" select="$target.database"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:variable name="olink.docname.citation">
        <xsl:call-template name="olink.document.citation">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:variable name="olink.page.citation">
        <xsl:call-template name="olink.page.citation">
          <xsl:with-param name="olink.key" select="$olink.key"/>
          <xsl:with-param name="target.database" select="$target.database"/>
          <xsl:with-param name="olink.lang" select="$olink.lang"/>
          <xsl:with-param name="linkend" select="$linkend"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:choose>
        <xsl:when test="$linkend != ''">
          <fo:basic-link internal-destination="{$linkend}"
                       xsl:use-attribute-sets="xref.properties">
            <xsl:call-template name="anchor"/>
            <xsl:copy-of select="$hottext"/>
            <xsl:copy-of select="$olink.page.citation"/>
          </fo:basic-link>
        </xsl:when>
        <xsl:when test="$href != ''">
          <xsl:choose>
            <xsl:when test="$fop1.extensions != 0">
              <xsl:variable name="href.mangled">
                <xsl:choose>
                  <xsl:when test="contains($href, '#')">
                    <xsl:value-of select="concat(substring-before($href,'#'), '#dest=', substring-after($href,'#'))"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="$href"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <fo:basic-link external-destination="{$href.mangled}"
                             xsl:use-attribute-sets="olink.properties">
                <xsl:copy-of select="$hottext"/>
              </fo:basic-link>
              <xsl:copy-of select="$olink.page.citation"/>
              <xsl:copy-of select="$olink.docname.citation"/>
            </xsl:when>
            <xsl:when test="$xep.extensions != 0">
              <fo:basic-link external-destination="url({$href})"
                             xsl:use-attribute-sets="olink.properties">
                <xsl:call-template name="anchor"/>
                <xsl:copy-of select="$hottext"/>
              </fo:basic-link>
              <xsl:copy-of select="$olink.page.citation"/>
              <xsl:copy-of select="$olink.docname.citation"/>
            </xsl:when>
            <xsl:when test="$axf.extensions != 0">
              <fo:basic-link external-destination="{$href}"
                             xsl:use-attribute-sets="olink.properties">
                <xsl:copy-of select="$hottext"/>
              </fo:basic-link>
              <xsl:copy-of select="$olink.page.citation"/>
              <xsl:copy-of select="$olink.docname.citation"/>
            </xsl:when>
            <xsl:otherwise>
              <fo:basic-link external-destination="{$href}"
                             xsl:use-attribute-sets="olink.properties">
                <xsl:copy-of select="$hottext"/>
              </fo:basic-link>
              <xsl:copy-of select="$olink.page.citation"/>
              <xsl:copy-of select="$olink.docname.citation"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$hottext"/>
          <xsl:copy-of select="$olink.page.citation"/>
          <xsl:copy-of select="$olink.docname.citation"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- olink never implemented in FO for old olink entity syntax -->
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="insert.olink.docname.markup">
  <xsl:param name="docname" select="''"/>
  
  <fo:inline font-style="italic">
    <xsl:value-of select="$docname"/>
  </fo:inline>

</xsl:template>

<!-- This prevents error message when processing olinks with xrefstyle -->
<xsl:template match="d:olink" mode="object.xref.template"/>


<xsl:template name="olink.as.linkend">
  <xsl:param name="olink.key" select="''"/>
  <xsl:param name="olink.lang" select="''"/>
  <xsl:param name="target.database" select="NotANode"/>

  <xsl:variable name="targetdoc">
    <xsl:value-of select="substring-before($olink.key, '/')"/>
  </xsl:variable>

  <xsl:variable name="targetptr">
    <xsl:value-of 
       select="substring-before(substring-after($olink.key, '/'), '/')"/>
  </xsl:variable>

  <xsl:variable name="target.lang">
    <xsl:variable name="candidate">
      <xsl:for-each select="$target.database" >
        <xsl:value-of 
                  select="key('targetptr-key', $olink.key)[1]/@lang" />
      </xsl:for-each>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$candidate != ''">
        <xsl:value-of select="$candidate"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$olink.lang"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$current.docid = $targetdoc and 
                $olink.lang = $target.lang">
    <xsl:variable name="targets" select="key('id',$targetptr)"/>
    <xsl:variable name="target" select="$targets[1]"/>
    <xsl:if test="$target">
      <xsl:value-of select="$targetptr"/>
    </xsl:if>
  </xsl:if>

</xsl:template>


<!-- ==================================================================== -->

<xsl:template name="title.xref">
  <xsl:param name="target" select="."/>
  <xsl:choose>
    <xsl:when test="local-name($target) = 'figure'
                    or local-name($target) = 'example'
                    or local-name($target) = 'equation'
                    or local-name($target) = 'table'
                    or local-name($target) = 'dedication'
                    or local-name($target) = 'acknowledgements'
                    or local-name($target) = 'preface'
                    or local-name($target) = 'bibliography'
                    or local-name($target) = 'glossary'
                    or local-name($target) = 'index'
                    or local-name($target) = 'setindex'
                    or local-name($target) = 'colophon'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:apply-templates select="$target" mode="title.markup"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic">
        <xsl:apply-templates select="$target" mode="title.markup"/>
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="number.xref">
  <xsl:param name="target" select="."/>
  <xsl:apply-templates select="$target" mode="label.markup"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="xref.xreflabel">
  <!-- called to process an xreflabel...you might use this to make  -->
  <!-- xreflabels come out in the right font for different targets, -->
  <!-- for example. -->
  <xsl:param name="target" select="."/>
  <xsl:value-of select="$target/@xreflabel"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="d:title" mode="xref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="d:command" mode="xref">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="d:function" mode="xref">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="*" mode="page.citation">
  <xsl:param name="id" select="'???'"/>
  <xsl:param name="xrefstyle" select="''"/>

  <fo:basic-link internal-destination="{$id}"
                 xsl:use-attribute-sets="xref.properties">
    <fo:inline keep-together.within-line="always">
      <xsl:call-template name="substitute-markup">
        <xsl:with-param name="template">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="name" select="'page.citation'"/>
            <xsl:with-param name="context" select="'xref'"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </fo:inline>
  </fo:basic-link>
</xsl:template>

<xsl:template match="*" mode="pagenumber.markup">
  <xsl:variable name="id">
    <xsl:call-template name="object.id"/>
  </xsl:variable>
  <fo:page-number-citation ref-id="{$id}"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="insert.title.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref'">
      <xsl:copy-of select="$title"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:chapter|d:appendix" mode="insert.title.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref'">
      <fo:inline font-style="italic">
        <xsl:copy-of select="$title"/>
      </fo:inline>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="insert.subtitle.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="subtitle"/>

  <xsl:copy-of select="$subtitle"/>
</xsl:template>

<xsl:template match="*" mode="insert.label.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="label"/>

  <xsl:copy-of select="$label"/>
</xsl:template>

<xsl:template match="*" mode="insert.pagenumber.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="pagenumber"/>

  <xsl:copy-of select="$pagenumber"/>
</xsl:template>

<xsl:template match="*" mode="insert.direction.markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="direction"/>

  <xsl:copy-of select="$direction"/>
</xsl:template>

<xsl:template match="d:olink" mode="pagenumber.markup">
  <!-- Local olinks can use page-citation -->
  <xsl:variable name="targetdoc.att" select="@targetdoc"/>
  <xsl:variable name="targetptr.att" select="@targetptr"/>

  <xsl:variable name="olink.lang">
    <xsl:call-template name="l10n.language">
      <xsl:with-param name="xref-context" select="true()"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="target.database.filename">
    <xsl:call-template name="select.target.database">
      <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
      <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="target.database" 
      select="document($target.database.filename, /)"/>

  <xsl:if test="$olink.debug != 0">
    <xsl:message>
      <xsl:text>Olink debug: root element of target.database is '</xsl:text>
      <xsl:value-of select="local-name($target.database/*[1])"/>
      <xsl:text>'.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="olink.key">
    <xsl:call-template name="select.olink.key">
      <xsl:with-param name="targetdoc.att" select="$targetdoc.att"/>
      <xsl:with-param name="targetptr.att" select="$targetptr.att"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
      <xsl:with-param name="target.database" select="$target.database"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- Olink that points to internal id can be a link -->
  <xsl:variable name="linkend">
    <xsl:call-template name="olink.as.linkend">
      <xsl:with-param name="olink.key" select="$olink.key"/>
      <xsl:with-param name="olink.lang" select="$olink.lang"/>
      <xsl:with-param name="target.database" select="$target.database"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$linkend != ''">
      <fo:page-number-citation ref-id="{$linkend}"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="olink.error">
        <xsl:with-param name="message">
          <xsl:text>no page number linkend for local olink '</xsl:text>
          <xsl:value-of select="$olink.key"/>
          <xsl:text>'</xsl:text>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
