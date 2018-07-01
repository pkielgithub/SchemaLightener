<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************

XSLT name:    directories.xslt

Version:  4.9

Date: 2016-01-18

Purpose:  Templates common to SchemaLightener set of tools, used for managing directories.

**********************************************************************
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions"
	exclude-result-prefixes="fn " xmlns="" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">

	<!--  ***********************************  
findNewContextBasePath
Template deals with finding the current context base path for assets.
***********************************-->
	<xsl:template name="findNewContextBasePath">
		<!-- this gets current context path minus filename so it can be basis of relative includes -->
		<xsl:param name="contextBasePath"/>
		<xsl:choose>
			<xsl:when test="contains($contextBasePath,'http://')">http://<xsl:call-template
					name="findNewContextBasePath">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="substring-after($contextBasePath,'http://')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($contextBasePath,'/')">
				<xsl:value-of select="substring-before($contextBasePath,'/')"/>/<xsl:call-template
					name="findNewContextBasePath">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="substring-after($contextBasePath,'/')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<!-- the rest is the filename, so we're done -->
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ******************************** 
		chop1Directory   
		Takes a directory path and removes one directory from the right hand side.
		******************************** -->
	<xsl:template name="chop1Directory">
		<xsl:param name="contextBasePath"/>
		<xsl:variable name="length">
			<xsl:value-of select="string-length($contextBasePath)"/>
		</xsl:variable>
		<xsl:variable name="contextBasePath2">
			<xsl:choose>
				<xsl:when test="ends-with($contextBasePath,'/')">
					<xsl:value-of select="substring($contextBasePath,1,$length - 1)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$contextBasePath"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="tokenized" select="tokenize($contextBasePath2,'/')[last()]"/>
		<!-- OAGi -->
		<xsl:variable name="tokenizedConcat" select="concat('/',$tokenized)"/>
		<!-- /OAGi -->
		<xsl:variable name="tokenizedConcatLength">
			<xsl:value-of select="string-length($tokenizedConcat)"/>
			<!-- 5 -->
		</xsl:variable>
		<xsl:variable name="contextBasePath2Length">
			<xsl:value-of select="string-length($contextBasePath2)"/>
		</xsl:variable>
		<!--		
			<xsl:value-of select="substring-before($contextBasePath2,concat('/',$tokenized))"/>/</xsl:template>
		-->
		<xsl:value-of
			select="substring($contextBasePath2,1,$contextBasePath2Length - $tokenizedConcatLength)"
		/>/</xsl:template>

	<!-- ******************************** 
		chopNDirectories   
		When combined with chop1Directory, removes any unnecessary directories from the right hand side of a path.
		Should be rewritten using 2.0 techniques.  "to do".
		******************************** -->
	<xsl:template name="chopNDirectories">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="location"/>
		<xsl:variable name="locationTranslated">
			<xsl:value-of select="translate($location,'\','/')"/>
		</xsl:variable>
		<xsl:variable name="theRest">
			<xsl:choose>
				<xsl:when test="contains($locationTranslated,'../')">
					<xsl:value-of select="substring-after($locationTranslated,'../')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$locationTranslated"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="newContextBasePath">
			<xsl:choose>
				<xsl:when test="contains($locationTranslated,'../')">
					<xsl:call-template name="chop1Directory">
						<xsl:with-param name="contextBasePath">
							<xsl:value-of select="$contextBasePath"/>
						</xsl:with-param>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$contextBasePath"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains($location,'http://')">http://<xsl:call-template
					name="chop1Directory">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="substring-after($location,'http://')"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($locationTranslated,'../')">
				<xsl:call-template name="chopNDirectories">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="$newContextBasePath"/>
					</xsl:with-param>
					<xsl:with-param name="location">
						<xsl:value-of select="$theRest"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$newContextBasePath"/>
				<xsl:value-of select="$theRest"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- ******************************** 
		match="comment()"   
		******************************** -->

</xsl:stylesheet>
