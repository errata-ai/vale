<?xml version="1.0" encoding="ASCII"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:d="http://docbook.org/ns/docbook"
		xmlns:ng="http://docbook.org/docbook-ng"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:exsl="http://exslt.org/common"
		xmlns:exslt="http://exslt.org/common"
		xmlns="http://www.w3.org/1999/xhtml"
		exslt:dummy="dummy"
		ng:dummy="dummy"
		db:dummy="dummy"
		extension-element-prefixes="exslt"
		exclude-result-prefixes="db ng exsl exslt exslt d"
		version="1.0">


<!-- ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://cdn.docbook.org/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->

<xsl:import href="xhtml-profile-docbook.xsl"/>

<xsl:include href="html5-element-mods.xsl"/>

<xsl:output method="xml" encoding="UTF-8" indent="no"/>

</xsl:stylesheet>
