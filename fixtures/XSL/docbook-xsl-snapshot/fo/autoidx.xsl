<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "../common/entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
                xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="exslt d"
                version="1.0">

<!-- ********************************************************************

     This file is part of the DocBook XSL Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/ for copyright
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- The "basic" method derived from Jeni Tennison's work. -->
<!-- The "kosek" method contributed by Jirka Kosek. -->
<!-- The "kimber" method contributed by Eliot Kimber of Innodata Isogen. -->

<!-- Importing module for kimber or kosek method overrides one of these -->
<xsl:param name="kimber.imported" select="0"/>
<xsl:param name="kosek.imported" select="0"/>

<!-- These keys used primary in all methods -->
<xsl:key name="letter"
         match="d:indexterm"
         use="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="primary"
         match="d:indexterm"
         use="&primary;"/>

<xsl:key name="primaryonly"
         match="d:indexterm"
         use="normalize-space(d:primary)"/>

<xsl:key name="secondary"
         match="d:indexterm"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:key name="tertiary"
         match="d:indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>

<xsl:key name="endofrange"
         match="d:indexterm[@class='endofrange']"
         use="@startref"/>

<xsl:key name="see-also"
         match="d:indexterm[d:seealso]"
         use="concat(&primary;, &sep;, 
                     &secondary;, &sep;, 
                     &tertiary;, &sep;, d:seealso)"/>

<xsl:key name="see"
         match="d:indexterm[d:see]"
         use="concat(&primary;, &sep;, 
                     &secondary;, &sep;, 
                     &tertiary;, &sep;, d:see)"/>


<xsl:template name="generate-index">
  <!-- these are all the elements that can contain an index element -->
  <xsl:param name="scope" select="(ancestor::d:book 
                                 | ancestor::d:appendix 
                                 | ancestor::d:article 
                                 | ancestor::d:chapter 
                                 | ancestor::d:part 
                                 | ancestor::d:preface 
                                 | ancestor::d:sect1 
                                 | ancestor::d:sect2 
                                 | ancestor::d:sect3 
                                 | ancestor::d:sect4 
                                 | ancestor::d:sect5 
                                 | ancestor::d:section 
                                 | ancestor::d:set
                                 | ancestor::d:topic 
                                 |/)[last()]"/>

  <xsl:choose>
    <xsl:when test="$index.method = 'kosek'">
      <xsl:call-template name="generate-kosek-index">
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$index.method = 'kimber'">
      <xsl:call-template name="generate-kimber-index">
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="generate-basic-index">
        <xsl:with-param name="scope" select="$scope"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:template name="generate-basic-index">
  <xsl:param name="scope" select="NOTANODE"/>

  <xsl:variable name="role">
    <xsl:if test="$index.on.role != 0">
      <xsl:value-of select="@role"/>
    </xsl:if>
  </xsl:variable>

  <xsl:variable name="type">
    <xsl:if test="$index.on.type != 0">
      <xsl:value-of select="@type"/>
    </xsl:if>
  </xsl:variable>

  <!-- set of indexterms within scope, one for each unique primary first character -->
  <!-- The scope takes into account the context of the index
       element, and @type or @role -->
  <xsl:variable name="terms"
                select="//d:indexterm
                        [generate-id(.) = generate-id(key('letter',
                          translate(substring(&primary;, 1, 1),
                             &lowercase;,
                             &uppercase;))
                          [&scope;])
                          and not(@class = 'endofrange')]"/>

  <!-- subset of $terms that start with letters of the current alphabet -->
  <xsl:variable name="alphabetical"
                select="$terms[contains(concat(&lowercase;, &uppercase;),
                                        substring(&primary;, 1, 1))]"/>

  <xsl:variable name="others" select="$terms[not(contains(
                                        concat(&lowercase;,
                                        &uppercase;),
                                        substring(&primary;, 1, 1)))]"/>
  <fo:block>
    <xsl:if test="$others">
      <xsl:call-template name="indexdiv.title">
        <xsl:with-param name="titlecontent">
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'index symbols'"/>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>

      <xsl:variable name="others.in.index" 
                    select="$others[generate-id(.) = generate-id(key('primary', &primary;)[&scope;])]"/>

      <fo:block>
        <xsl:apply-templates select="$others.in.index"
                             mode="index-symbol-div">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="translate(&primary;, &lowercase;, 
                            &uppercase;)"/>
        </xsl:apply-templates>
      </fo:block>
    </xsl:if>

    <xsl:variable name="alphabetical.in.index"
                  select="$alphabetical[generate-id(.) = generate-id(key('letter',
                                 translate(substring(&primary;, 1, 1),
                                           &lowercase;,&uppercase;))[&scope;])]"/>

    <xsl:apply-templates select="$alphabetical.in.index"
                         mode="index-div-basic">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<!-- This template not used if fo/autoidx-kosek.xsl is imported -->
<xsl:template name="generate-kosek-index">
  <xsl:param name="scope" select="NOTANODE"/>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:if test="contains($vendor, 'libxslt')">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method does not </xsl:text>
      <xsl:text>work with the xsltproc XSLT processor.</xsl:text>
    </xsl:message>
  </xsl:if>


  <xsl:if test="$exsl.node.set.available = 0">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method requires the </xsl:text>
      <xsl:text>exslt:node-set() function. Use a processor that </xsl:text>
      <xsl:text>has it, or use a different index method.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="$kosek.imported = 0">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kosek' index method requires the&#xA;</xsl:text>
      <xsl:text>kosek index extensions be imported:&#xA;</xsl:text>
      <xsl:text>  xsl:import href="fo/autoidx-kosek.xsl"</xsl:text>
    </xsl:message>
  </xsl:if>

</xsl:template>


<!-- This template not used if fo/autoidx-kimber.xsl is imported -->
<xsl:template name="generate-kimber-index">
  <xsl:param name="scope" select="NOTANODE"/>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:if test="not(contains($vendor, 'SAXON '))">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kimber' index method requires the </xsl:text>
      <xsl:text>Saxon version 6 or 9 XSLT processor.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="$kimber.imported = 0">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kimber' index method requires the&#xA;</xsl:text>
      <xsl:text>kimber index extensions be imported:&#xA;</xsl:text>
      <xsl:text>  xsl:import href="fo/autoidx-kimber.xsl"</xsl:text>
    </xsl:message>
  </xsl:if>

</xsl:template>

<xsl:template match="d:indexterm" mode="index-div-basic">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key"
                select="translate(substring(&primary;, 1, 1),
                         &lowercase;,&uppercase;)"/>

  <xsl:if test="key('letter', $key)
                [generate-id(.) = generate-id(key('primary', &primary;)[&scope;])]">
    <fo:block>
      <xsl:if test="contains(concat(&lowercase;, &uppercase;), $key)">
        <xsl:call-template name="indexdiv.title">
          <xsl:with-param name="titlecontent">
            <xsl:value-of select="translate($key, &lowercase;, &uppercase;)"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <fo:block xsl:use-attribute-sets="index.entry.properties">
        <xsl:variable name="these.terms" 
                      select="key('letter', $key)
                              [generate-id(.) = generate-id(key('primary', &primary;)
                              [&scope;])]"/>
        
        <xsl:apply-templates select="$these.terms"
                             mode="index-primary">
          <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </fo:block>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-symbol-div">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key"
                select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

  <fo:block xsl:use-attribute-sets="index.entry.properties">
    <xsl:apply-templates select="key('letter', $key)
                               [generate-id(.) = generate-id(key('primary', &primary;)[&scope;])]"
                         mode="index-primary">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </fo:block>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-primary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$autolink.index.see != 0">
      <xsl:choose>
        <xsl:when test="$fop1.extensions != 0 and count(//d:index|//d:setindex) &gt; 1">
          <!-- more than one index can generate duplicate ids
               which cause FOP to fail -->
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="id">
            <xsl:text>ientry-</xsl:text>
            <xsl:call-template name="object.id"/>
          </xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>

    <xsl:for-each select="$refs/d:primary">
      <xsl:if test="@id or @xml:id">
        <fo:inline id="{(@id|@xml:id)[1]}"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="d:primary"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions != 0">
        <xsl:if test="$refs[not(d:see) and not(d:secondary)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(d:see) and not(d:secondary)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties"
                ref-key="{$primary.significant}"/>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(d:see) and not(d:secondary)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties"
                ref-key="{$primary}"/>
            </xsl:if>
          </rx:page-index>        
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(d:see)
                                and not(d:secondary)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(d:secondary)]/*[self::d:see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:with-param name="role" select="$role"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/d:secondary or $refs[not(d:secondary)]/*[self::d:seealso]">
    <fo:block start-indent="1pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                           mode="index-seealso">
         <xsl:with-param name="scope" select="$scope"/>
         <xsl:with-param name="role" select="$role"/>
         <xsl:with-param name="type" select="$type"/>
         <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[d:secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[&scope;][1]) = 1]"
                           mode="index-secondary">
       <xsl:with-param name="scope" select="$scope"/>
       <xsl:with-param name="role" select="$role"/>
       <xsl:with-param name="type" select="$type"/>
       <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-secondary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>

    <xsl:for-each select="$refs/d:secondary">
      <xsl:if test="@id or @xml:id">
        <fo:inline id="{(@id|@xml:id)[1]}"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="d:secondary"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions != 0">
        <xsl:if test="$refs[not(d:see) and not(d:tertiary)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="secondary" select="&secondary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(d:see) and not(d:tertiary)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary.significant"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(d:see) and not(d:tertiary)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
          </rx:page-index>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(d:see)
                                and not(d:tertiary)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(d:tertiary)]/*[self::d:see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/d:tertiary or $refs[not(d:tertiary)]/*[self::d:seealso]">
    <fo:block start-indent="2pc">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                           mode="index-seealso">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
      <xsl:apply-templates select="$refs[d:tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[&scope;][1]) = 1]"
                           mode="index-tertiary">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="translate(&tertiary;, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-tertiary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[&scope;]"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <fo:block>
    <xsl:if test="$axf.extensions != 0">
      <xsl:attribute name="axf:suppress-duplicate-page-number">true</xsl:attribute>
    </xsl:if>

    <xsl:for-each select="$refs/d:tertiary">
      <xsl:if test="@id or @xml:id">
        <fo:inline id="{(@id|@xml:id)[1]}"/>
      </xsl:if>
    </xsl:for-each>

    <xsl:value-of select="d:tertiary"/>

    <xsl:choose>
      <xsl:when test="$xep.extensions != 0">
        <xsl:if test="$refs[not(d:see)]">
          <xsl:copy-of select="$term.separator"/>
          <xsl:variable name="primary" select="&primary;"/>
          <xsl:variable name="secondary" select="&secondary;"/>
          <xsl:variable name="tertiary" select="&tertiary;"/>
          <xsl:variable name="primary.significant" select="concat(&primary;, $significant.flag)"/>
          <rx:page-index list-separator="{$number.separator}"
                         range-separator="{$range.separator}">
            <xsl:if test="$refs[@significance='preferred'][not(d:see)]">
              <rx:index-item xsl:use-attribute-sets="index.preferred.page.properties xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary.significant"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$tertiary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
            <xsl:if test="$refs[not(@significance) or @significance!='preferred'][not(d:see)]">
              <rx:index-item xsl:use-attribute-sets="xep.index.item.properties">
                <xsl:attribute name="ref-key">
                  <xsl:value-of select="$primary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$secondary"/>
                  <xsl:text>, </xsl:text>
                  <xsl:value-of select="$tertiary"/>
                </xsl:attribute>
              </rx:index-item>
            </xsl:if>
          </rx:page-index>
        </xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="page-number-citations">
          <xsl:for-each select="$refs[not(d:see)]">
            <xsl:apply-templates select="." mode="reference">
              <xsl:with-param name="scope" select="$scope"/>
              <xsl:with-param name="role" select="$role"/>
              <xsl:with-param name="type" select="$type"/>
              <xsl:with-param name="position" select="position()"/>
            </xsl:apply-templates>
          </xsl:for-each>
        </xsl:variable>

        <xsl:copy-of select="$page-number-citations"/>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs/d:see">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>

  </fo:block>

  <xsl:if test="$refs/d:seealso">
    <fo:block>
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso))[&scope;][1])]"
                           mode="index-seealso">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </fo:block>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="position" select="0"/>
  <xsl:param name="separator" select="''"/>

  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$separator != ''">
      <xsl:value-of select="$separator"/>
    </xsl:when>
    <xsl:when test="$position = 1">
      <xsl:value-of select="$term.separator"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$number.separator"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="ancestor::*[contains(local-name(),'info') and not(starts-with(local-name(),'info'))]">
      <xsl:call-template name="info.reference">
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}"
                     xsl:use-attribute-sets="index.page.number.properties">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>

      <xsl:if test="key('endofrange', $id)[&scope;]">
        <xsl:apply-templates select="key('endofrange', $id)[&scope;][last()]"
                             mode="reference">
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:with-param name="separator" select="$range.separator"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="zones"/>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('id', $zone)"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
           <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}"
                     xsl:use-attribute-sets="index.page.number.properties">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>

      <xsl:copy-of select="$number.separator"/>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('id', $zone)"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <fo:basic-link internal-destination="{$id}"
                     xsl:use-attribute-sets="index.page.number.properties">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="info.reference">
  <!-- This is not perfect. It doesn't treat indexterm inside info element as a range covering whole parent of info.
       It also not work when there is no ID generated for parent element. But it works in the most common cases. -->
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="target" select="(ancestor::d:appendix|ancestor::d:article|ancestor::d:bibliography|ancestor::d:book|
                                       ancestor::d:chapter|ancestor::d:glossary|ancestor::d:part|ancestor::d:preface|
                                       ancestor::d:refentry|ancestor::d:reference|ancestor::d:refsect1|ancestor::d:refsect2|
                                       ancestor::d:refsect3|ancestor::d:refsection|ancestor::d:refsynopsisdiv|
                                       ancestor::d:sect1|ancestor::d:sect2|ancestor::d:sect3|ancestor::d:sect4|ancestor::d:sect5|
                                       ancestor::d:section|ancestor::d:setindex|ancestor::d:set|ancestor::d:sidebar|ancestor::d:mediaobject)[&scope;]"/>
  
  <xsl:variable name="id">
    <xsl:call-template name="object.id">
      <xsl:with-param name="object" select="$target[position() = last()]"/>
    </xsl:call-template>
  </xsl:variable>
  
  <fo:basic-link internal-destination="{$id}"
                 xsl:use-attribute-sets="index.page.number.properties">
    <fo:page-number-citation ref-id="{$id}"/>
  </fo:basic-link>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-see">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="see" select="normalize-space(d:see)"/>

  <!-- can only link to primary, which should appear before comma
  in see "primary, secondary" entry -->
  <xsl:variable name="seeprimary">
    <xsl:choose>
      <xsl:when test="contains($see, ',')">
        <xsl:value-of select="substring-before($see, ',')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$see"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable> 

  <xsl:variable name="seetarget" select="key('primaryonly', $seeprimary)[1]"/>

  <xsl:variable name="linkend">
    <xsl:if test="$seetarget">
      <xsl:text>ientry-</xsl:text>
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$seetarget"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>
  
  <fo:inline>
    <xsl:text> (</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'see'"/>
    </xsl:call-template>
    <xsl:text> </xsl:text>
    <xsl:choose>
      <!-- manual links have precedence -->
      <xsl:when test="d:see/@linkend or d:see/@xlink:href">
        <xsl:call-template name="simple.xlink">
          <xsl:with-param name="node" select="d:see"/>
          <xsl:with-param name="content" select="$see"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$autolink.index.see = 0">
         <xsl:value-of select="$see"/>
      </xsl:when>
      <xsl:when test="$fop1.extensions != 0 and count(//d:index|//d:setindex) &gt; 1">
         <xsl:value-of select="$see"/>
      </xsl:when>
      <xsl:when test="$seetarget">
        <fo:basic-link internal-destination="{$linkend}"
                       xsl:use-attribute-sets="xref.properties">
          <xsl:value-of select="$see"/>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$see"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>)</xsl:text>
  </fo:inline>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-seealso">
   <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:for-each select="d:seealso">
    <xsl:sort select="translate(., &lowercase;, &uppercase;)"/>

    <xsl:variable name="seealso" select="normalize-space(.)"/>

    <!-- can only link to primary, which should appear before comma
    in seealso "primary, secondary" entry -->
    <xsl:variable name="seealsoprimary">
      <xsl:choose>
        <xsl:when test="contains($seealso, ',')">
          <xsl:value-of select="substring-before($seealso, ',')"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$seealso"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable> 

    <xsl:variable name="seealsotarget" select="key('primaryonly', $seealsoprimary)[1]"/>

    <xsl:variable name="linkend">
      <xsl:if test="$seealsotarget">
        <xsl:text>ientry-</xsl:text>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$seealsotarget"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <fo:block>
      <xsl:text>(</xsl:text>
      <xsl:call-template name="gentext">
        <xsl:with-param name="key" select="'seealso'"/>
      </xsl:call-template>
      <xsl:text> </xsl:text>
      <xsl:choose>
        <!-- manual links have precedence -->
        <xsl:when test="@linkend or @xlink:href">
          <xsl:call-template name="simple.xlink">
            <xsl:with-param name="node" select="."/>
            <xsl:with-param name="content" select="$seealso"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$autolink.index.see = 0">
          <xsl:value-of select="$seealso"/>
        </xsl:when>
        <xsl:when test="$fop1.extensions != 0 and count(//d:index|//d:setindex) &gt; 1">
           <xsl:value-of select="$seealso"/>
        </xsl:when>
        <xsl:when test="$seealsotarget">
          <fo:basic-link internal-destination="{$linkend}"
                         xsl:use-attribute-sets="xref.properties">
            <xsl:value-of select="$seealso"/>
          </fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$seealso"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>)</xsl:text>
    </fo:block>

  </xsl:for-each>

</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="generate-index-markup">
  <xsl:param name="scope" select="(ancestor::d:book|/)[last()]"/>
  <xsl:param name="role" select="@role"/>
  <xsl:param name="type" select="@type"/>

  <xsl:variable name="terms" select="$scope//d:indexterm[count(.|key('letter',
                                     translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;))[&scope;][1]) = 1]"/>
  <xsl:variable name="alphabetical"
                select="$terms[contains(concat(&lowercase;, &uppercase;),
                                        substring(&primary;, 1, 1))]"/>
  <xsl:variable name="others" select="$terms[not(contains(concat(&lowercase;,
                                                 &uppercase;),
                                             substring(&primary;, 1, 1)))]"/>

  <xsl:text>&lt;index&gt;&#10;</xsl:text>
  <xsl:if test="$others">
    <xsl:text>&#10;&lt;indexdiv&gt;&#10;</xsl:text>
    <xsl:text>&lt;title&gt;</xsl:text>
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'index symbols'"/>
    </xsl:call-template>
    <xsl:text>&lt;/title&gt;&#10;</xsl:text>
    <xsl:apply-templates select="$others[count(.|key('primary',
                                 &primary;)[&scope;][1]) = 1]"
                         mode="index-symbol-div-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:text>&lt;/indexdiv&gt;&#10;</xsl:text>
  </xsl:if>

  <xsl:apply-templates select="$alphabetical[count(.|key('letter',
                               translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;))[&scope;][1]) = 1]"
                       mode="index-div-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
  <xsl:text>&lt;/index&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="index-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="local-name(.)"/>
  <xsl:text>&gt;&#10;</xsl:text>
  <xsl:apply-templates mode="index-markup">
    <xsl:with-param name="scope" select="$scope"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="type" select="$type"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-div-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>
  <xsl:text>&#10;&lt;indexdiv&gt;&#10;</xsl:text>
  <xsl:text>&lt;title&gt;</xsl:text>
  <xsl:value-of select="translate($key, &lowercase;, &uppercase;)"/>
  <xsl:text>&lt;/title&gt;&#10;</xsl:text>

  <xsl:apply-templates select="key('letter', $key)[&scope;][count(.|key('primary', &primary;)[&scope;][1]) = 1]"
                       mode="index-primary-markup">
    <xsl:with-param name="scope" select="$scope"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="type" select="$type"/>
    <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
  <xsl:text>&lt;/indexdiv&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-symbol-div-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

  <xsl:apply-templates select="key('letter', $key)[&scope;][count(.|key('primary', &primary;)[&scope;][1]) = 1]"
                       mode="index-primary-markup">
    <xsl:with-param name="scope" select="$scope"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="type" select="$type"/>
    <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-primary-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>
  <xsl:variable name="pages" select="$refs[not(d:see) and not(d:seealso)]"/>

  <xsl:text>&#10;&lt;indexentry&gt;&#10;</xsl:text>
  <xsl:text>&lt;primaryie&gt;</xsl:text>
  <xsl:text>&lt;phrase&gt;</xsl:text>
  <xsl:call-template name="escape-text">
    <xsl:with-param name="text" select="string(d:primary)"/>
  </xsl:call-template>
  <xsl:text>&lt;/phrase&gt;</xsl:text>
  <xsl:if test="$pages">,</xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:for-each select="$pages">
    <xsl:apply-templates select="." mode="reference-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
  </xsl:for-each>

  <xsl:text>&lt;/primaryie&gt;&#10;</xsl:text>

  <xsl:if test="$refs/d:secondary or $refs[not(d:secondary)]/*[self::d:see or self::d:seealso]">
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, d:see))[&scope;][1])]"
                         mode="index-see-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                         mode="index-seealso-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>

    <xsl:apply-templates select="$refs[d:secondary and count(.|key('secondary', concat($key, &sep;, &secondary;))[&scope;][1]) = 1]"
                         mode="index-secondary-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </xsl:if>
  <xsl:text>&lt;/indexentry&gt;&#10;</xsl:text>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-secondary-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>
  <xsl:variable name="pages" select="$refs[not(d:see) and not(d:seealso)]"/>

  <xsl:text>&lt;secondaryie&gt;</xsl:text>
  <xsl:text>&lt;phrase&gt;</xsl:text>
  <xsl:call-template name="escape-text">
    <xsl:with-param name="text" select="string(d:secondary)"/>
  </xsl:call-template>
  <xsl:text>&lt;/phrase&gt;</xsl:text>
  <xsl:if test="$pages">,</xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:for-each select="$pages">
    <xsl:apply-templates select="." mode="reference-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
  </xsl:for-each>

  <xsl:text>&lt;/secondaryie&gt;&#10;</xsl:text>

  <xsl:if test="$refs/d:tertiary or $refs[not(d:tertiary)]/*[self::d:see or self::d:seealso]">
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:see))[&scope;][1])]"
                         mode="index-see-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                         mode="index-seealso-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$refs[d:tertiary and count(.|key('tertiary', concat($key, &sep;, &tertiary;))[&scope;][1]) = 1]"
                         mode="index-tertiary-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&tertiary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-tertiary-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[&scope;]"/>
  <xsl:variable name="pages" select="$refs[not(d:see) and not(d:seealso)]"/>

  <xsl:text>&lt;tertiaryie&gt;</xsl:text>
  <xsl:text>&lt;phrase&gt;</xsl:text>
  <xsl:call-template name="escape-text">
    <xsl:with-param name="text" select="string(d:tertiary)"/>
  </xsl:call-template>
  <xsl:text>&lt;/phrase&gt;</xsl:text>
  <xsl:if test="$pages">,</xsl:if>
  <xsl:text>&#10;</xsl:text>

  <xsl:for-each select="$pages">
    <xsl:apply-templates select="." mode="reference-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
  </xsl:for-each>

  <xsl:text>&lt;/tertiaryie&gt;&#10;</xsl:text>

  <xsl:variable name="see" select="$refs/d:see | $refs/d:seealso"/>
  <xsl:if test="$see">
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see))[&scope;][1])]"
                         mode="index-see-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
    <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso))[&scope;][1])]"
                         mode="index-seealso-markup">
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="reference-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:choose>
    <xsl:when test="@zone and string(@zone)">
      <xsl:call-template name="reference-markup">
        <xsl:with-param name="zones" select="normalize-space(@zone)"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="id">
        <xsl:call-template name="object.id"/>
      </xsl:variable>


      <xsl:choose>
        <xsl:when test="@startref and @class='endofrange'">
          <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
          <xsl:text>&lt;link linkend="</xsl:text>
          <xsl:value-of select="@startref"/>
          <xsl:text>"&gt;</xsl:text>
          <fo:basic-link internal-destination="{@startref}"
                     xsl:use-attribute-sets="index.page.number.properties">
            <fo:page-number-citation ref-id="{@startref}"/>
            <xsl:text>-</xsl:text>
            <fo:page-number-citation ref-id="{$id}"/>
          </fo:basic-link>
          <xsl:text>&lt;/link&gt;</xsl:text>
          <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
          <xsl:if test="$id">
            <xsl:text>&lt;link linkend="</xsl:text>
            <xsl:value-of select="$id"/>
            <xsl:text>"&gt;</xsl:text>
          </xsl:if>
          <fo:basic-link internal-destination="{$id}"
                     xsl:use-attribute-sets="index.page.number.properties">
            <fo:page-number-citation ref-id="{$id}"/>
          </fo:basic-link>
          <xsl:if test="$id">
            <xsl:text>&lt;/link&gt;</xsl:text>
          </xsl:if>
          <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="reference-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="zones"/>
  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
      <xsl:if test="$target[1]/@id or $target[1]/@xml:id">
        <xsl:text>&lt;link linkend="</xsl:text>
        <xsl:value-of select="$id"/>
        <xsl:text>"&gt;</xsl:text>
      </xsl:if>
      <fo:basic-link internal-destination="{$id}"
                     xsl:use-attribute-sets="index.page.number.properties">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
      <xsl:if test="$target[1]/@id or $target[1]/@xml:id">
        <xsl:text>&lt;/link&gt;</xsl:text>
      </xsl:if>
      <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>

      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('id', $zone)[&scope;]"/>

      <xsl:variable name="id">
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$target[1]"/>
        </xsl:call-template>
      </xsl:variable>

      <xsl:text>&lt;phrase role="pageno"&gt;</xsl:text>
      <xsl:if test="$target[1]/@id or d:target[1]/@xml:id">
        <xsl:text>&lt;link linkend="</xsl:text>
        <xsl:value-of select="$id"/>
        <xsl:text>"&gt;</xsl:text>
      </xsl:if>
      <fo:basic-link internal-destination="{$id}"
                     xsl:use-attribute-sets="index.page.number.properties">
        <fo:page-number-citation ref-id="{$id}"/>
      </fo:basic-link>
      <xsl:if test="$target[1]/@id or d:target[1]/@xml:id">
        <xsl:text>&lt;/link&gt;</xsl:text>
      </xsl:if>
      <xsl:text>&lt;/phrase&gt;&#10;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-see-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <fo:block>
    <xsl:text>&lt;seeie&gt;</xsl:text>
    <xsl:text>&lt;phrase&gt;</xsl:text>
    <xsl:call-template name="escape-text">
      <xsl:with-param name="text" select="string(d:see)"/>
    </xsl:call-template>
    <xsl:text>&lt;/phrase&gt;</xsl:text>
    <xsl:text>&lt;/seeie&gt;&#10;</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-seealso-markup">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <fo:block>
    <xsl:text>&lt;seealsoie&gt;</xsl:text>
    <xsl:text>&lt;phrase&gt;</xsl:text>
    <xsl:call-template name="escape-text">
      <xsl:with-param name="text" select="string(d:seealso)"/>
    </xsl:call-template>
    <xsl:text>&lt;/phrase&gt;</xsl:text>
    <xsl:text>&lt;/seealsoie&gt;&#10;</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template name="escape-text">
  <xsl:param name="text" select="''"/>

  <xsl:variable name="ltpos" select="substring-before($text, '&lt;')"/>
  <xsl:variable name="amppos" select="substring-before($text, '&amp;')"/>

  <xsl:choose>
    <xsl:when test="contains($text,'&lt;') and contains($text, '&amp;')
                    and string-length($ltpos) &lt; string-length($amppos)">
      <xsl:value-of select="$ltpos"/>
      <xsl:text>&amp;lt;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&lt;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text,'&lt;') and contains($text, '&amp;')
                    and string-length($amppos) &lt; string-length($ltpos)">
      <xsl:value-of select="$amppos"/>
      <xsl:text>&amp;amp;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&amp;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&lt;')">
      <xsl:value-of select="$ltpos"/>
      <xsl:text>&amp;lt;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&lt;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:when test="contains($text, '&amp;')">
      <xsl:value-of select="$amppos"/>
      <xsl:text>&amp;amp;</xsl:text>
      <xsl:call-template name="escape-text">
        <xsl:with-param name="text" select="substring-after($text, '&amp;')"/>
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="index.separator">
  <xsl:param name="key" select="''"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:choose>
    <xsl:when test="$key = 'index.term.separator'">
      <xsl:choose>
        <!-- Use the override if not blank -->
        <xsl:when test="$index.term.separator != ''">
          <xsl:copy-of select="$index.term.separator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="context">index</xsl:with-param>
            <xsl:with-param name="name">term-separator</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$key = 'index.number.separator'">
      <xsl:choose>
        <!-- Use the override if not blank -->
        <xsl:when test="$index.number.separator != ''">
          <xsl:copy-of select="$index.number.separator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="context">index</xsl:with-param>
            <xsl:with-param name="name">number-separator</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$key = 'index.range.separator'">
      <xsl:choose>
        <!-- Use the override if not blank -->
        <xsl:when test="$index.range.separator != ''">
          <xsl:copy-of select="$index.range.separator"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="lang" select="$lang"/>
            <xsl:with-param name="context">index</xsl:with-param>
            <xsl:with-param name="name">range-separator</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
