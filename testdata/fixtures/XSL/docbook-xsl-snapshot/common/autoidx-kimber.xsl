<?xml version="1.0"?>
<!DOCTYPE xsl:stylesheet [
<!ENTITY % common.entities SYSTEM "entities.ent">
%common.entities;
<!-- Documents using the kimber index method must have a lang attribute -->
<!-- Only one of these should be present in the entity -->

<!ENTITY lang 'concat(/*/@lang, /*/@xml:lang)'>
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:d="http://docbook.org/ns/docbook"
		version="1.0"
                xmlns:k="java:com.isogen.saxoni18n.Saxoni18nService"
                exclude-result-prefixes="k d">

<!-- ********************************************************************

     This file is part of the DocBook XSL Stylesheet distribution.
     See ../README or http://cdn.docbook.org/ for copyright
     copyright and other information.

     ******************************************************************** -->

<xsl:param name="kimber.imported">
  <xsl:variable name="vendor" select="system-property('xsl:vendor')"/>
  <xsl:choose>
    <xsl:when test="not(contains($vendor, 'SAXON '))">
      <xsl:message terminate="yes">
        <xsl:text>ERROR: the 'kimber' index method requires the </xsl:text>
        <xsl:text>Saxon version 6 or 8 XSLT processor.</xsl:text>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:param>


<!-- The following key used in the kimber indexing method. -->
<xsl:key name="k-group"
         match="d:indexterm"
         use="k:getIndexGroupKey(&lang;, &primary;)"/>

</xsl:stylesheet>
