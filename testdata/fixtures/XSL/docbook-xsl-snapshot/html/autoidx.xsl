<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "../common/entities.ent">
%common.entities;
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		xmlns:exslt="http://exslt.org/common"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                extension-element-prefixes="exslt"
                exclude-result-prefixes="exslt d"
                version="1.0">

<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- The "basic" method derived from Jeni Tennison's work. -->
<!-- The "kosek" method contributed by Jirka Kosek. -->
<!-- The "kimber" method contributed by Eliot Kimber of Innodata Isogen. -->

<xsl:variable name="kimber.imported" select="0"/>
<xsl:variable name="kosek.imported" select="0"/>

<xsl:key name="letter"
         match="d:indexterm"
         use="translate(substring(&primary;, 1, 1),&lowercase;,&uppercase;)"/>

<xsl:key name="primary"
         match="d:indexterm"
         use="&primary;"/>

<xsl:key name="secondary"
         match="d:indexterm"
         use="concat(&primary;, &sep;, &secondary;)"/>

<xsl:key name="tertiary"
         match="d:indexterm"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>

<!-- this key used for automatic links from see and seealso to primary -->
<xsl:key name="primaryonly"
         match="d:indexterm"
         use="normalize-space(d:primary)"/>

<xsl:key name="endofrange"
         match="d:indexterm[@class='endofrange']"
         use="@startref"/>

<xsl:key name="primary-section"
         match="d:indexterm[not(d:secondary) and not(d:see)]"
         use="concat(&primary;, &sep;, &section.id;)"/>

<xsl:key name="secondary-section"
         match="d:indexterm[not(d:tertiary) and not(d:see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &section.id;)"/>

<xsl:key name="tertiary-section"
         match="d:indexterm[not(d:see)]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, &section.id;)"/>

<xsl:key name="see-also"
         match="d:indexterm[d:seealso]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso)"/>

<xsl:key name="see"
         match="d:indexterm[d:see]"
         use="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see)"/>

<xsl:key name="sections" match="*[@id or @xml:id]" use="@id|@xml:id"/>


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

  <!-- subset of $terms that start with other than letters of the current alphabet -->
  <xsl:variable name="others" select="$terms[not(contains(concat(&lowercase;,
                                                 &uppercase;),
                                             substring(&primary;, 1, 1)))]"/>
  <div class="index">
    <xsl:if test="$others">
      <!-- full set of non-letter indexterms in scope whose first character match any of $others -->
      <xsl:variable name="others.in.index" 
                    select="$others[generate-id(.) = generate-id(key('primary', &primary;)[&scope;])]"/>
      <div class="indexdiv">
        <h3>
          <xsl:call-template name="gentext">
            <xsl:with-param name="key" select="'index symbols'"/>
          </xsl:call-template>
        </h3>
        <dl>
          <xsl:apply-templates select="$others.in.index"
                               mode="index-symbol-div">
            <xsl:with-param name="position" select="position()"/>                                
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
        </dl>
      </div>
    </xsl:if>

    <xsl:variable name="alphabetical.in.index"
                  select="$alphabetical[generate-id(.) = generate-id(key('letter',
                                 translate(substring(&primary;, 1, 1),
                                           &lowercase;,&uppercase;))[&scope;])]"/>

    <xsl:apply-templates select="$alphabetical.in.index"
                         mode="index-div-basic">
      <xsl:with-param name="position" select="position()"/>
      <xsl:with-param name="scope" select="$scope"/>
      <xsl:with-param name="role" select="$role"/>
      <xsl:with-param name="type" select="$type"/>
      <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- This template not used if html/autoidx-kosek.xsl is imported -->
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
      <xsl:text>  xsl:import href="html/autoidx-kosek.xsl"</xsl:text>
    </xsl:message>
  </xsl:if>

</xsl:template>

<!-- This template not used if html/autoidx-kimber.xsl is imported -->
<xsl:template name="generate-kimber-index">
  <xsl:param name="scope" select="NOTANODE"/>

  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:if test="not(contains($vendor, 'SAXON '))">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kimber' index method requires the </xsl:text>
      <xsl:text>Saxon version 6 or 8 XSLT processor.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:if test="$kimber.imported = 0">
    <xsl:message terminate="yes">
      <xsl:text>ERROR: the 'kimber' index method requires the&#xA;</xsl:text>
      <xsl:text>kimber index extensions be imported:&#xA;</xsl:text>
      <xsl:text>  xsl:import href="html/autoidx-kimber.xsl"</xsl:text>
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
    <div class="indexdiv">
      <xsl:if test="contains(concat(&lowercase;, &uppercase;), $key)">
        <h3>
          <xsl:value-of select="translate($key, &lowercase;, &uppercase;)"/>
        </h3>
      </xsl:if>
      <dl>
        <xsl:variable name="these.terms" 
                      select="key('letter', $key)
                              [generate-id(.) = generate-id(key('primary', &primary;)
                              [&scope;])]"/>
        
        <xsl:apply-templates select="$these.terms"
                             mode="index-primary">
          <xsl:with-param name="position" select="position()"/>
          <xsl:with-param name="scope" select="$scope"/>
          <xsl:with-param name="role" select="$role"/>
          <xsl:with-param name="type" select="$type"/>
          <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
        </xsl:apply-templates>
      </dl>
    </div>
  </xsl:if>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-symbol-div">
  <xsl:param name="scope" select="/"/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="translate(substring(&primary;, 1, 1),
                                             &lowercase;,&uppercase;)"/>

  <xsl:apply-templates select="key('letter', $key)
                               [generate-id(.) = generate-id(key('primary', &primary;)[&scope;])]"
                       mode="index-primary">
    <xsl:with-param name="position" select="position()"/>
    <xsl:with-param name="scope" select="$scope"/>
    <xsl:with-param name="role" select="$role"/>
    <xsl:with-param name="type" select="$type"/>
    <xsl:sort select="translate(&primary;, &lowercase;, &uppercase;)"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-primary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="&primary;"/>
  <xsl:variable name="refs" select="key('primary', $key)[&scope;]"/>
  <dt>
    <xsl:if test="$autolink.index.see != 0">
      <!-- add internal id attribute to form see and seealso links -->
      <xsl:attribute name="id">
        <xsl:text>ientry-</xsl:text>
        <xsl:call-template name="object.id"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:for-each select="$refs/d:primary">
      <xsl:if test="@id or @xml:id">
        <xsl:choose>
          <xsl:when test="$generate.id.attributes = 0">
            <a name="{(@id|@xml:id)[1]}"/>
          </xsl:when>
          <xsl:otherwise>
            <span>
              <xsl:call-template name="id.attribute"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="d:primary"/>
    <xsl:choose>
      <xsl:when test="$index.links.to.section = 1">
        <xsl:for-each select="$refs[@zone != '' or generate-id() = generate-id(key('primary-section', concat($key, &sep;, &section.id;))[&scope;][1])]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$refs[not(d:see)
                              and not(d:secondary)][&scope;]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(d:secondary)]/*[self::d:see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &sep;, &sep;, d:see))[&scope;][1])]"
                           mode="index-see">
        <xsl:with-param name="position" select="position()"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>
  </dt>
  <xsl:choose>
    <xsl:when test="$refs/d:secondary or $refs[not(d:secondary)]/*[self::d:seealso]">
      <dd>
        <dl>
          <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &sep;, &sep;, d:seealso))[&scope;][1])]"
                               mode="index-seealso">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
          <xsl:variable name="secondaries" 
                        select="$refs[d:secondary and 
                        generate-id() = generate-id(key('secondary', concat($key, &sep;, &secondary;))[&scope;])]"/>
          <xsl:apply-templates select="$secondaries"
                               mode="index-secondary">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:sort select="translate(&secondary;, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
        </dl>
      </dd>
    </xsl:when>
    <!-- HTML5 requires dd for each dt -->
    <xsl:when test="$div.element = 'section'">
      <dd></dd>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-secondary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;)"/>
  <xsl:variable name="refs" select="key('secondary', $key)[&scope;]"/>
  <dt>
    <xsl:for-each select="$refs/d:secondary">
      <xsl:if test="@id or @xml:id">
        <xsl:choose>
          <xsl:when test="$generate.id.attributes = 0">
            <a name="{(@id|@xml:id)[1]}"/>
          </xsl:when>
          <xsl:otherwise>
            <span>
              <xsl:call-template name="id.attribute"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="d:secondary"/>
    <xsl:choose>
      <xsl:when test="$index.links.to.section = 1">
        <xsl:for-each select="$refs[@zone != '' or generate-id() = generate-id(key('secondary-section', concat($key, &sep;, &section.id;))[&scope;])]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$refs[not(d:see)
                                and not(d:tertiary)][&scope;]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs[not(d:tertiary)]/*[self::d:see]">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:see))[&scope;])]"
                           mode="index-see">
        <xsl:with-param name="position" select="position()"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>
  </dt>
  <xsl:choose>
    <xsl:when test="$refs/d:tertiary or $refs[not(d:tertiary)]/*[self::d:seealso]">
      <dd>
        <dl>
          <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &sep;, d:seealso))[&scope;])]"
                               mode="index-seealso">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>

          <xsl:variable name="tertiaries"
                        select="$refs[d:tertiary and 
                        generate-id(.) = generate-id(key('tertiary', concat($key, &sep;, &tertiary;))[&scope;])]"/>

          <xsl:apply-templates select="$tertiaries"
                               mode="index-tertiary">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:sort select="translate(&tertiary;, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
        </dl>
      </dd>
    </xsl:when>
    <!-- HTML5 requires dd for each dt -->
    <xsl:when test="$div.element = 'section'">
      <dd></dd>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:indexterm" mode="index-tertiary">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>

  <xsl:variable name="key" select="concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;)"/>
  <xsl:variable name="refs" select="key('tertiary', $key)[&scope;]"/>
  <dt>
    <xsl:for-each select="$refs/d:tertiary">
      <xsl:if test="@id or @xml:id">
        <xsl:choose>
          <xsl:when test="$generate.id.attributes = 0">
            <a name="{(@id|@xml:id)[1]}"/>
          </xsl:when>
          <xsl:otherwise>
            <span>
              <xsl:call-template name="id.attribute"/>
            </span>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
    <xsl:value-of select="d:tertiary"/>
    <xsl:choose>
      <xsl:when test="$index.links.to.section = 1">
        <xsl:for-each select="$refs[@zone != '' or generate-id() = generate-id(key('tertiary-section', concat($key, &sep;, &section.id;))[&scope;])]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="$refs[not(d:see)][&scope;]">
          <xsl:apply-templates select="." mode="reference">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:if test="$refs/d:see">
      <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:see))[&scope;])]"
                           mode="index-see">
        <xsl:with-param name="position" select="position()"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
        <xsl:sort select="translate(d:see, &lowercase;, &uppercase;)"/>
      </xsl:apply-templates>
    </xsl:if>
  </dt>
  <xsl:choose>
    <xsl:when test="$refs/d:seealso">
      <dd>
        <dl>
          <xsl:apply-templates select="$refs[generate-id() = generate-id(key('see-also', concat(&primary;, &sep;, &secondary;, &sep;, &tertiary;, &sep;, d:seealso))[&scope;])]"
                               mode="index-seealso">
            <xsl:with-param name="position" select="position()"/>
            <xsl:with-param name="scope" select="$scope"/>
            <xsl:with-param name="role" select="$role"/>
            <xsl:with-param name="type" select="$type"/>
            <xsl:sort select="translate(d:seealso, &lowercase;, &uppercase;)"/>
          </xsl:apply-templates>
        </dl>
      </dd>
    </xsl:when>
    <!-- HTML5 requires dd for each dt -->
    <xsl:when test="$div.element = 'section'">
      <dd></dd>
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="d:indexterm" mode="reference">
  <xsl:param name="scope" select="."/>
  <xsl:param name="role" select="''"/>
  <xsl:param name="type" select="''"/>
  <xsl:param name="position"/>
  <xsl:param name="separator" select="''"/>
  
  <xsl:variable name="term.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.term.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="number.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.number.separator'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="range.separator">
    <xsl:call-template name="index.separator">
      <xsl:with-param name="key" select="'index.range.separator'"/>
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
        <xsl:with-param name="position" select="position()"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <a>
        <xsl:apply-templates select="." mode="class.attribute"/>
        <xsl:variable name="title">
          <xsl:choose>
            <xsl:when test="$index.prefer.titleabbrev != 0">
              <xsl:apply-templates select="&section;" mode="titleabbrev.markup"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="&section;" mode="title.markup"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:attribute name="href">
          <xsl:choose>
            <xsl:when test="$index.links.to.section = 1">
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="&section;"/>
                <xsl:with-param name="context" 
                                select="(//d:index[&scope;] | //d:setindex[&scope;])[1]"/>
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="href.target">
                <xsl:with-param name="object" select="."/>
                <xsl:with-param name="context" 
                                select="(//d:index[&scope;] | //d:setindex[&scope;])[1]"/>
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:attribute>

        <xsl:value-of select="$title"/> <!-- text only -->
      </a>

      <xsl:variable name="id" select="(@id|@xml:id)[1]"/>
      <xsl:if test="key('endofrange', $id)[&scope;]">
        <xsl:apply-templates select="key('endofrange', $id)[&scope;][last()]"
                             mode="reference">
          <xsl:with-param name="position" select="position()"/>
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

  <xsl:choose>
    <xsl:when test="contains($zones, ' ')">
      <xsl:variable name="zone" select="substring-before($zones, ' ')"/>
      <xsl:variable name="target" select="key('sections', $zone)"/>

      <a>
        <xsl:apply-templates select="." mode="class.attribute"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target[1]"/>
            <xsl:with-param name="context" select="//d:index[&scope;][1]"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="$target[1]" mode="index-title-content"/>
      </a>
      <xsl:text>, </xsl:text>
      <xsl:call-template name="reference">
        <xsl:with-param name="zones" select="substring-after($zones, ' ')"/>
        <xsl:with-param name="position" select="position()"/>
        <xsl:with-param name="scope" select="$scope"/>
        <xsl:with-param name="role" select="$role"/>
        <xsl:with-param name="type" select="$type"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="zone" select="$zones"/>
      <xsl:variable name="target" select="key('sections', $zone)"/>

      <a>
        <xsl:apply-templates select="." mode="class.attribute"/>
        <xsl:call-template name="id.attribute"/>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="object" select="$target[1]"/>
            <xsl:with-param name="context" select="//d:index[&scope;][1]"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="$target[1]" mode="index-title-content"/>
      </a>
    </xsl:otherwise>
  </xsl:choose>
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
      <xsl:text>#ientry-</xsl:text>
      <xsl:call-template name="object.id">
        <xsl:with-param name="object" select="$seetarget"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

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
    <xsl:when test="$seetarget">
      <a href="{$linkend}">
        <xsl:value-of select="$see"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$see"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>)</xsl:text>
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
        <xsl:text>#ientry-</xsl:text>
        <xsl:call-template name="object.id">
          <xsl:with-param name="object" select="$seealsotarget"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:variable>

    <dt>
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
        <xsl:when test="$seealsotarget">
          <a href="{$linkend}">
            <xsl:value-of select="$seealso"/>
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$seealso"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>)</xsl:text>
    </dt>

    <xsl:if test="$div.element = 'section'">
      <dd></dd>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="index-title-content">
  <xsl:variable name="title">
    <xsl:apply-templates select="&section;" mode="title.markup"/>
  </xsl:variable>

  <xsl:value-of select="$title"/>
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
