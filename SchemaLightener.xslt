<?xml version="1.0" encoding="UTF-8"?>
<!--
**********************************************************************

XSLT name:    SchemaLightener.xslt

Version:  4.9

Date: 2016-01-18

Purpose:  This stylesheet makes a copy of an Xml Schema with unused componenets omitted, 
based on a representative xml instance.  

Notes:  This stylesheet grew out of an original requirement for Xslt 1.0 technology only.  
It has since been significantly improved using Xslt 2.0 and will continue to develop beyond 
the initial 1.0 requirement.  


**********************************************************************
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
	<xsl:output indent="yes" method="xml" encoding="utf-8" omit-xml-declaration="no"
		exclude-result-prefixes="xsi" media-type="text/xml"/>
	<xsl:include href="directories.xslt"/>
	<xsl:include href="common.xslt"/>

	<!--
Parameters:
  
instanceFilePathAndName:  This is the name and path of the Xml instance that contains 
the elements and attributes that should be retained in the resulting Xml Schema.  It should
include a full path so the Xslt can load it via the document() function.  

resultBasePath:  This is the path to a folder where the results of the transformation will be placed.  
Make sure permissions are set at this location so the transformation can be created properly.

Notes on parameters and XSLT processors:
1.  Some XSLT processors require "file:///" to precede a full drive or network path, e.g.

	<xsl:param name="instanceFilePathAndName">file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>

2.  Some XSLT processors will not work well with back slashes "\" and so forward slashes "/" are recommended.
3.  Some XSLT processors may need a trailing forward slash "/" to correctly create the result folder, as in:

	<xsl:param name="resultBasePath">file:///c:/xmlschemas/lightened/result/</xsl:param>

The trailing forward slash is therefore recommended.

Notes:

2009-06-27
- Added recursion check, so recursive includes/imports are not a problem. (see $schemaLocationStringRecursionCheck)
- Corrected bug fix in calculating the result path common to all schemas (for correct placement of files so paths work)
2016-01-18
- minor updates

Known Issues:
- recursive type where the elements that use them are not recursive.
For example below.  Notice the JobCategory ***************** below.  2 local elements refering to same type.
the latter is recursively written

Need to find a way around this limitation.

	<xsd:complexType name="PositionHistoryType">
		<xsd:sequence>
			<xsd:element name="Title" type="xsd:string" minOccurs="0"/>
			<xsd:element name="OrgName" type="PositionOrgNameType"/>
			<xsd:element name="OrgInfo" type="PositionOrgInfoType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="OrgIndustry" type="PositionOrgIndustryType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="OrgSize" type="xsd:string" minOccurs="0"/>
			<xsd:element name="Description" type="xsd:string"/>
			<xsd:element name="StartDate" type="FlexibleDatesType"/>
			<xsd:element name="EndDate" type="FlexibleDatesType" minOccurs="0"/>
			<xsd:element name="Compensation" type="PositionCompensationType" minOccurs="0"/>
			<xsd:element name="Comments" type="xsd:string" minOccurs="0"/>
			<xsd:element name="Verification" type="VerificationType" minOccurs="0"/>
			<xsd:element name="JobLevelInfo" type="JobLevelInfoType" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element name="JobCategory" type="OccupationalCategoryType" minOccurs="0" maxOccurs="unbounded"/>   *************************************
			<xsd:element ref="Competency" minOccurs="0" maxOccurs="unbounded"/>
			<xsd:element ref="UserArea" minOccurs="0"/>
		</xsd:sequence>
		<xsd:attribute name="positionType" type="PositionTypexStringPatternExtensionType"/>
		<xsd:attribute name="currentEmployer" type="xsd:boolean" use="optional"/>
	</xsd:complexType>

<xsd:complexType name="OccupationalCategoryType">   *************************************
		<xsd:sequence>
			<xsd:element name="TaxonomyName" minOccurs="0">
				<xsd:complexType>
					<xsd:simpleContent>
						<xsd:extension base="xsd:string">
							<xsd:attribute name="version" type="xsd:string" use="optional"/>
						</xsd:extension>
					</xsd:simpleContent>
				</xsd:complexType>
			</xsd:element>
			<xsd:element name="CategoryCode" type="xsd:string" minOccurs="0"/>
			<xsd:element name="CategoryDescription" type="xsd:string" minOccurs="0"/>
			<xsd:element name="Comments" type="xsd:string" minOccurs="0"/>
			<xsd:element name="JobCategory" type="OccupationalCategoryType" minOccurs="0"/>   *************************************
		</xsd:sequence>
	</xsd:complexType>


-->
	<xsl:param name="instanceFilePathAndName"/>
	<xsl:param name="resultBasePath"/>
	<xsl:param name="trace" select="'false'"/>
	
	<xsl:variable name="sourcePathAndFileName" select="document-uri(.)"/>
	<xsl:variable name="sourcePathAndFileNameTranslated"
		select="translate($sourcePathAndFileName,'\','/')"/>
	<xsl:variable name="resultBasePathTranslated" select="translate($resultBasePath,'\','/')"/>
	<xsl:variable name="rootFileName">
		<xsl:value-of select="tokenize($sourcePathAndFileNameTranslated,'/')[last()]"/>
	</xsl:variable>
	<xsl:variable name="sourceBasePath">
		<xsl:value-of select="substring-before($sourcePathAndFileNameTranslated,$rootFileName)"/>
	</xsl:variable>
	<xsl:variable name="resultPathAndFileName">
		<xsl:value-of select="$resultBasePathTranslated"/>
		<xsl:value-of select="$rootFileName"/>
	</xsl:variable>
	<xsl:variable name="schemaFiles">
		<xsl:call-template name="schemaFileRelationMapping">
			<xsl:with-param name="sourcePathAndFileName" tunnel="yes">
				<xsl:value-of select="$sourcePathAndFileName"/>
			</xsl:with-param>
			<xsl:with-param name="resultPathAndFileName" tunnel="yes">
				<xsl:value-of select="$resultPathAndFileName"/>
			</xsl:with-param>
			<xsl:with-param name="schemas" select="xsd:schema" tunnel="yes"/>
		</xsl:call-template>
	</xsl:variable>
	<xsl:variable name="commonSourceBasePath">
		<!-- this is the source base path part that is common to all files.   anything after this
string is to be duplicated in the result so that the paths match
-->
		<xsl:choose>
			<xsl:when test="count($schemaFiles//file)=1">
				<!-- if there is only one file, then we don't need to calculate a commonSourceBasePath  -->
			</xsl:when>
			<xsl:otherwise>
				<!-- multiple files, so calculate commonSourceBasePath -->
				<xsl:variable name="tokenizedSample"
					select="tokenize($schemaFiles/file/name[1],'/')"/>
				<xsl:variable name="tokenizednumbers">
					<xsl:for-each select="$schemaFiles//file/name">
						<xsl:variable name="thistokenizedSample" select="tokenize(.,'/')"/>
						<xsl:for-each select="$thistokenizedSample">
							<!-- compare each token to main and if the don't match, indicate index number-->
							<xsl:variable name="index">
								<xsl:value-of select="position()"/>
							</xsl:variable>
							<!--
Returns -1 if comp1 is less than comp2, 0 if comp1 is equal to comp2, or 1 if comp1 is greater than comp2
-->
							<xsl:if
								test="compare($tokenizedSample[number($index)],.)=-1 or compare($tokenizedSample[number($index)],.)=1">
								<xsl:value-of select="number($index)"/>~</xsl:if>
						</xsl:for-each>
					</xsl:for-each>
				</xsl:variable>
				<xsl:variable name="finaltokenizednumbers" select="tokenize($tokenizednumbers,'~')"/>
				<xsl:variable name="lowestcommonindex">
					<xsl:for-each-group select="$finaltokenizednumbers" group-by=".">
						<xsl:sort order="ascending" select="." data-type="number"/>
						<xsl:value-of select="."/>~</xsl:for-each-group>
				</xsl:variable>
				<!-- when comparing numbers, don't use index-of($tokenizedSample,.)
but instead use position() because the former can return multiple numbers if some directory names are repeated
-->
				<xsl:for-each select="$tokenizedSample">
					<xsl:choose>
						<xsl:when test="starts-with($lowestcommonindex,'~')">
							<xsl:if
								test="position()&lt;(number(substring-before(substring-after($lowestcommonindex,'~'),'~')))">
								<xsl:value-of select="."/>/</xsl:if>
						</xsl:when>
						<xsl:otherwise>
							<xsl:if
								test="position()&lt;(number(substring-before($lowestcommonindex,'~')))">
								<xsl:value-of select="."/>/</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:variable name="schemas">
		<master>
			<xsl:for-each-group select="$schemaFiles//file" group-by="name">
				<xsl:copy-of select="document(name)/xsd:schema"/>
			</xsl:for-each-group>
		</master>
	</xsl:variable>
	<xsl:variable name="instance" select="document($instanceFilePathAndName)"/>
	<xsl:variable name="instanceElements" select="$instance//*"/>
	<xsl:variable name="instanceComponentNames">
		<instanceComponentNames>
			<xsl:for-each-group select="$instanceElements" group-by="name()">
				<xsl:variable name="name">
					<xsl:value-of select="name(.)"/>
				</xsl:variable>
				<xsl:variable name="qname">
					<xsl:value-of select="resolve-QName(name(.),.)"/>
				</xsl:variable>
				<e resolvename="{resolve-QName(name(.),.)}"
					uri="{namespace-uri-from-QName(resolve-QName(name(.),.))}"
					localname="{local-name(.)}"
					qname="{namespace-uri-from-QName(resolve-QName(name(.),.))}:{local-name(.)}">
					<xsl:for-each-group
						select="$instance//*[string(resolve-QName(name(.),.))=$qname]/@*"
						group-by="name()">
						<a name="{name()}"/>
					</xsl:for-each-group>

				</e>

				<xsl:variable name="localname">
					<xsl:value-of select="local-name(.)"/>
				</xsl:variable>
				<!-- if this element is the source of a substitutionGroup, and the target element is not already in the result,
					then get the base element it is substituting 
					i.e. <xsd:element name="LoadSupport" type="LoadSupportType" substitutionGroup="oa:ShippingMaterial"/>
				-->
				<xsl:for-each-group
					select="$schemas//xsd:element/@substitutionGroup[contains(.,$localname)]"
					group-by=".">
					<xsl:variable name="subName">
						<xsl:value-of select="."/>
					</xsl:variable>

					<xsl:variable name="sname">
						<xsl:value-of select="."/>
					</xsl:variable>
					<xsl:variable name="sqname">
						<xsl:value-of select="."/>
					</xsl:variable>
					<xsl:variable name="localname">
						<xsl:choose>
							<xsl:when test="contains(.,':')">
								<xsl:value-of select="substring-after(.,':')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="."/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<e resolvename="{$sqname}" uri="{namespace-uri-from-QName(resolve-QName(.,..))}"
						localname="{$localname}"
						qname="{namespace-uri-from-QName(resolve-QName(.,..))}:{$localname}">
						<xsl:for-each-group
							select="$instance//*[string(resolve-QName(name(.),.))=$qname]/@*"
							group-by="name()">
							<a name="{name()}"/>
						</xsl:for-each-group>

					</e>


				</xsl:for-each-group>

			</xsl:for-each-group>

		</instanceComponentNames>

	</xsl:variable>
	<xsl:variable name="instanceTypeNames">
		<xsl:variable name="instanceTypeNames1">
			<xsl:for-each-group select="$instanceComponentNames//e" group-by="@qname">
				<xsl:variable name="localname">
					<xsl:value-of select="@localname"/>
				</xsl:variable>
				<xsl:variable name="uri">
					<xsl:value-of select="@uri"/>
				</xsl:variable>

				<xsl:call-template name="recursionTunnel">
					<xsl:with-param name="typeNameRecursionCheck" tunnel="yes"/>
					<xsl:with-param name="localname">
						<xsl:value-of select="$localname"/>
					</xsl:with-param>
					<xsl:with-param name="uri">
						<xsl:value-of select="$uri"/>
					</xsl:with-param>
				</xsl:call-template>

			</xsl:for-each-group>
			<xsl:for-each-group select="$instanceComponentNames//e/a" group-by="@name">
				<xsl:variable name="thiselement" select="@name"/>
				<xsl:apply-templates select="$schemas//xsd:attribute[@name=$thiselement]"
					mode="instanceTypeNames"/>
			</xsl:for-each-group>

			<xsl:for-each-group select="$instance//*/@xsi:type" group-by=".">
				<xsl:apply-templates select="." mode="instanceTypeNames"/>
			</xsl:for-each-group>

		</xsl:variable>
		<!-- weed out dupes -->
		<instanceTypeNames>
			<xsl:choose>
				<xsl:when test="$trace='true'">
					<!-- debug: show them all -->
					<xsl:for-each select="$instanceTypeNames1">
						<xsl:copy-of select="."/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<!-- debug: this weeds out dupes so its faster -->
					<xsl:for-each-group select="$instanceTypeNames1//t" group-by="@qname">
						<xsl:copy-of select="."/>
					</xsl:for-each-group>
				</xsl:otherwise>
			</xsl:choose>


		</instanceTypeNames>
	</xsl:variable>

	<xsl:template name="recursionTunnel">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:param name="localname"/>
		<xsl:param name="uri"/>

		<xsl:for-each select="$schemas//xsd:element[@name=$localname]
		">
			<xsl:variable name="thisuri">
				<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
			</xsl:variable>
			<xsl:if test="$uri=$thisuri">

				<xsl:apply-templates select="." mode="instanceTypeNames">
					<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
						<xsl:value-of select="typeNameRecursionCheck"/>
					</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>
	<!--  
		***********************************  
		***********************************
	-->
	<xsl:template match="xsd:complexType/@name | xsd:simpleType/@name" mode="instanceTypeNames">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:variable name="name">
			<xsl:value-of select="name(.)"/>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(.,':')">
					<xsl:value-of select="substring-after(.,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="qname">
			<xsl:value-of select="resolve-QName(.,..)"/>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-attributeNode"/>
		</xsl:variable>
		<t counter="100" resolvename="{resolve-QName(.,..)}" uri="{$uri}" localname="{$localname}"
			prefix="{substring-before(.,':')}" qname="{$uri}:{$localname}" doc="{document-uri(.)}"
				>$typeNameRecursionCheck:<xsl:value-of select="$typeNameRecursionCheck"/></t>
	</xsl:template>

	<xsl:template match="@type | @xsi:type" mode="instanceTypeNames">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:variable name="name">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(.,':')">
					<xsl:value-of select="substring-after(.,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-attributeNode"/>
		</xsl:variable>

		<xsl:for-each
			select="$schemas//xsd:simpleType[@name=$localname] 
			| $schemas//xsd:complexType[@name=$localname]">
			<xsl:variable name="thisuri">
				<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
			</xsl:variable>

			<xsl:if test="$uri=$thisuri">
				<xsl:apply-templates select="." mode="instanceTypeNames">
					<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
						<xsl:value-of select="$typeNameRecursionCheck"/>~<xsl:value-of
							select="$thisuri"/>:<xsl:value-of select="@name"/>~</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

	<xsl:template match="@memberTypes" mode="instanceTypeNames">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:variable name="thiselement" select=".."/>

		<xsl:variable name="tokenizedmembertypes" select="tokenize(normalize-space(.),' ')"/>
		<xsl:for-each-group select="$tokenizedmembertypes" group-by=".">
			<xsl:variable name="name">
				<xsl:value-of select="."/>
			</xsl:variable>
			<xsl:variable name="localname">
				<xsl:choose>
					<xsl:when test="contains(.,':')">
						<xsl:value-of select="substring-after(.,':')"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="."/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:variable name="qname">
				<xsl:value-of select="resolve-QName(.,$thiselement)"/>
			</xsl:variable>
			<xsl:variable name="uri">
				<xsl:call-template name="get-uri-thiselement">
					<xsl:with-param name="arg1qname" select="."/>
					<xsl:with-param name="arg2element" select="$thiselement"/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="this" select="."/>
			<xsl:for-each
				select="$schemas//xsd:simpleType[@name=$localname] | $schemas//xsd:complexType[@name=$localname]">

				<xsl:variable name="thisuri">
					<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
				</xsl:variable>

				<xsl:if test="$uri=$thisuri">
					<xsl:apply-templates select="." mode="instanceTypeNames">
						<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
							<xsl:value-of select="$typeNameRecursionCheck"/>~<xsl:value-of
								select="$thisuri"/>:<xsl:value-of select="@name"/>~</xsl:with-param>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each-group>
	</xsl:template>

	<xsl:template match="xsd:list/@itemType" mode="instanceTypeNames">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:variable name="name">
			<xsl:value-of select="name(.)"/>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(.,':')">
					<xsl:value-of select="substring-after(.,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="qname">
			<xsl:value-of select="resolve-QName(.,..)"/>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-attributeNode"/>
		</xsl:variable>
		<xsl:for-each
			select="$schemas//xsd:simpleType[@name=$localname] | $schemas//xsd:complexType[@name=$localname]">

			<xsl:variable name="thisuri">
				<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
			</xsl:variable>

			<xsl:if test="$uri=$thisuri">
				<xsl:apply-templates select="." mode="instanceTypeNames">
					<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
						<xsl:value-of select="$typeNameRecursionCheck"/>~<xsl:value-of
							select="$thisuri"/>:<xsl:value-of select="@name"/>~</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

	<xsl:template match="@base" mode="instanceTypeNames">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:variable name="thiselement" select=".."/>
		<xsl:variable name="name">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(.,':')">
					<xsl:value-of select="substring-after(.,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="qname">
			<xsl:value-of select="resolve-QName(.,..)"/>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-thiselement">
				<xsl:with-param name="arg1qname" select="."/>
				<xsl:with-param name="arg2element" select="$thiselement"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:for-each
			select="$schemas//xsd:simpleType[@name=$localname] | $schemas//xsd:complexType[@name=$localname]">

			<xsl:variable name="thisuri">
				<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
			</xsl:variable>

			<xsl:if test="$uri=$thisuri">
				<xsl:apply-templates select="." mode="instanceTypeNames">
					<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
						<xsl:value-of select="$typeNameRecursionCheck"/>~<xsl:value-of
							select="$thisuri"/>:<xsl:value-of select="@name"/>~</xsl:with-param>
				</xsl:apply-templates>
			</xsl:if>
		</xsl:for-each>

	</xsl:template>

	<xsl:template match="@*" mode="instanceTypeNames"/>

	<xsl:template match="*" mode="instanceTypeNames">
		<xsl:param name="typeNameRecursionCheck" tunnel="yes"/>
		<xsl:variable name="name" select="@name"/>
		<xsl:apply-templates select="@*" mode="instanceTypeNames">
			<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
				<xsl:value-of select="$typeNameRecursionCheck"/>
				<xsl:value-of select="@name"/>
			</xsl:with-param>
		</xsl:apply-templates>
		<!-- One recursion problem with nested types but non.nested elements
			can occur which would need something like this below.  See known issues at top.
			[$name != @type]
		<xsl:apply-templates select="*[$name != @type]" mode="instanceTypeNames">
		-->
		<xsl:apply-templates select="*" mode="instanceTypeNames">
			<xsl:with-param name="typeNameRecursionCheck" tunnel="yes">
				<xsl:value-of select="$typeNameRecursionCheck"/>
				<xsl:value-of select="@name"/>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="text()" mode="instanceTypeNames"/>

	<!-- ******************************** 
  /       root                                 
 ******************************** -->
	<xsl:template match="/">
		
		<xsl:for-each-group select="$schemaFiles//file" group-by="name">
			<xsl:variable name="relativename">
				<xsl:choose>
					<xsl:when test="count($schemaFiles//file)=1">
						<!-- only one file, so correct commonSourceBasePath setting -->
						<xsl:for-each-group select="$schemaFiles//file" group-by="name">
							<xsl:value-of select="tokenize(name,'/')[last()]"/>
						</xsl:for-each-group>
					</xsl:when>
					<xsl:otherwise>
						<!-- multiple files, so proceed as needed -->
						<xsl:value-of select="substring-after(name,$commonSourceBasePath)"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:result-document href="{$resultBasePath}{$relativename}">
				<xsl:apply-templates select="document(name)/xsd:schema"/>
			</xsl:result-document>
		</xsl:for-each-group>

	</xsl:template>

	<!--  
***********************************  
schema element template
***********************************
-->
	<xsl:template match="xsd:schema">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates select="xsd:annotation"/>
			<xsl:apply-templates select="xsd:import"/>
			<xsl:apply-templates select="xsd:include"/>
			<xsl:apply-templates select="xsd:element">
				<xsl:sort select="@name" order="ascending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="xsd:simpleType">
				<xsl:sort select="@name" order="ascending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="xsd:complexType">
				<xsl:sort select="@name" order="ascending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="xsd:group">
				<xsl:sort select="@name" order="ascending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="xsd:attributeGroup">
				<xsl:sort select="@name" order="ascending"/>
			</xsl:apply-templates>
			<xsl:apply-templates select="xsd:attribute">
				<xsl:sort select="@name" order="ascending"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<!--  
***********************************  
attributes template
***********************************
-->
	<xsl:template match="@*">
		<xsl:copy-of select="."/>
	</xsl:template>

	<!--  
***********************************  
everything else template
***********************************
-->
	<xsl:template match="* | text()">
		<xsl:copy>
			<xsl:apply-templates select="@*"/>
			<xsl:apply-templates/>
		</xsl:copy>
	</xsl:template>

	<!--  
***********************************  
xsd:attribute
***********************************
-->
	<xsl:template match="xsd:attribute">
		<xsl:variable name="isThereAnElementINeed">
			<xsl:for-each select="@name | @ref">
				<xsl:variable name="localname">
					<xsl:choose>
						<xsl:when test="contains(.,':')">
							<xsl:value-of select="substring-after(.,':')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:if test="$instanceComponentNames/instanceComponentNames/e/a[@name=$localname]"
					>yes</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="$isThereAnElementINeed!=''">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!--  
***********************************  
xsd:group[@name]
***********************************
-->
	<xsl:template match="xsd:group[@name]">
		<xsl:variable name="isThereAnElementINeed">
			<xsl:for-each select=".//xsd:element/@name | .//xsd:element/@ref">
				<xsl:variable name="localname">
					<xsl:choose>
						<xsl:when test="contains(.,':')">
							<xsl:value-of select="substring-after(.,':')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="uri">
					<xsl:call-template name="get-uri-attributeNode"/>
				</xsl:variable>
				<xsl:if
					test="$instanceComponentNames/instanceComponentNames/e[@localname=$localname][$uri = @uri]"
					>yes</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="$isThereAnElementINeed!=''">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!--  
***********************************  
xsd:group[@ref]
***********************************
-->
	<xsl:template match="xsd:group[@ref]">
		<xsl:variable name="name">
			<xsl:choose>
				<xsl:when test="contains(@ref,':')">
					<xsl:value-of select="substring-after(@ref,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@ref"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="isThereAnElementINeed">
			<xsl:for-each
				select="$schemas//xsd:schema/xsd:group[@name=$name]//xsd:element[@name or @ref]">
				<xsl:variable name="name">
					<xsl:value-of select="@name"/>
					<xsl:value-of select="@ref"/>
				</xsl:variable>
				<xsl:variable name="uriref">
					<xsl:call-template name="get-uri-elementNodeWithRefAttribute"/>
				</xsl:variable>
				<xsl:variable name="uriname">
					<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
				</xsl:variable>
				<xsl:if
					test="$instanceComponentNames/instanceComponentNames/e[@localname=$name][$uriref = @uri or $uriname = @uri]"
					>yes</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="$isThereAnElementINeed!=''">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!--  
***********************************  
choice template
***********************************
-->
	<xsl:template match="xsd:choice">
		<xsl:variable name="choicecontents">
			<xsl:for-each
				select=".//xsd:element/@ref | .//xsd:element/@name | .//xsd:attribute/@ref | .//xsd:attribute/@name">
				<xsl:variable name="localname">
					<xsl:choose>
						<xsl:when test="contains(.,':')">
							<xsl:value-of select="substring-after(.,':')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="uri">
					<xsl:call-template name="get-uri-attributeNode"/>
				</xsl:variable>
				<xsl:if
					test="$instanceComponentNames/instanceComponentNames/e[@localname=$localname][$uri = @uri]"
					>yes</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		<xsl:if test="not($choicecontents='')">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<!--  
***********************************  
named element template
***********************************
-->
	<xsl:template match="xsd:element[@name] | xsd:attribute[@name]">
		<xsl:variable name="name">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(.,':')">
					<xsl:value-of select="substring-after(.,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="."/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if
			test="$instanceComponentNames/instanceComponentNames/e[@localname=$name][$uri = @uri]
			| $instanceComponentNames/instanceComponentNames/e/a[@name=$name]">
			<xsl:choose>
				<xsl:when
					test="(parent::*[local-name()='schema'] or parent::*[local-name()='import'])">
					<xsl:copy>
						<xsl:apply-templates select="@*"/>
						<xsl:apply-templates/>
					</xsl:copy>
				</xsl:when>
				<xsl:when test="local-name()='attribute'">
					<xsl:copy>
						<xsl:apply-templates select="@*[not(name()='use')]"/>
						<xsl:apply-templates/>
					</xsl:copy>
				</xsl:when>
				<xsl:otherwise>
					<xsd:element>
						<xsl:for-each select="@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:apply-templates select="*"/>
					</xsd:element>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<!-- if this element is the target in a substitutionGroup, then get the base element it is derived from -->
		<xsl:if test="//xsd:schema/xsd:element[@substitutionGroup=$name]">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>

		<xsl:if test="@substitutionGroup">
			<!-- 
			<xsd:element name="PurchaseOrderHeader" 
			type="PurchaseOrderHeaderType" 
			substitutionGroup="oa:PurchaseOrderHeader"/>
			-->
			<!--
			<xsl:variable name="sGroupuri">
				<xsl:call-template name="get-uri">
					<xsl:with-param name="arg1qname" select="."/>
					<xsl:with-param name="arg2element" select=".."/>
				</xsl:call-template>
			</xsl:variable>
			<xsl:variable name="thisid" select="generate-id(.)"/>
			<xsl:for-each select="//xsd:schema/xsd:element[contains(@name,$localname)]">
				<xsl:variable name="thisnewid" select="generate-id(.)"/>
				<xsl:variable name="thisuri">
					<xsl:call-template name="get-uri">
						<xsl:with-param name="arg1qname" select="@name"/>
						<xsl:with-param name="arg2element" select="."/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:if test="$sGroupuri=$thisuri and $thisid!=$thisnewid">
					<xsl:apply-templates select="."/>
				</xsl:if>
			</xsl:for-each>
			-->
		</xsl:if>

	</xsl:template>

	<!--  
***********************************  
named types template
***********************************
-->
	<xsl:template match="xsd:simpleType[@name] | xsd:complexType[@name]">
		<xsl:variable name="name">
			<xsl:value-of select="@name"/>
		</xsl:variable>
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(@name,':')">
					<xsl:value-of select="substring-after(@name,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="qname">
			<xsl:value-of select="resolve-QName(@name,.)"/>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-elementNodeWithNameAttribute"/>
		</xsl:variable>

		<xsl:if
			test="$instanceTypeNames/instanceTypeNames/t[@localname=$name][$uri = @uri]
			| $instanceTypeNames/instanceTypeNames/t[@localname=$name and @localname!='' and $uri = @uri]">
			<xsl:copy>
				<xsl:apply-templates select="@*"/>
				<xsl:apply-templates/>
			</xsl:copy>
		</xsl:if>


	</xsl:template>

	<!--  
***********************************  
ref element
***********************************
-->
	<xsl:template match="xsd:element[@ref]">
		<xsl:variable name="localname">
			<xsl:choose>
				<xsl:when test="contains(@ref,':')">
					<xsl:value-of select="substring-after(@ref,':')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@ref"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="uri">
			<xsl:call-template name="get-uri-elementNodeWithRefAttribute"/>
		</xsl:variable>
		<xsl:if
			test="$instanceComponentNames/instanceComponentNames/e[@localname=$localname][@uri=$uri]">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:template>

	<!--  
***********************************  
schemaFileRelationMapping
***********************************
-->
	<xsl:template name="schemaFileRelationMapping">
		<xsl:param name="sourcePathAndFileName" tunnel="yes"/>
		<xsl:param name="resultPathAndFileName" tunnel="yes"/>
		<xsl:param name="instanceTypeNames" tunnel="yes"/>
		<xsl:param name="schemas" tunnel="yes"/>
		<xsl:param name="schemaLocationStringRecursionCheck"/>

		<xsl:variable name="schemaFileRelationMapping">
			<xsl:apply-templates select="$schemas" mode="fileRelationMapping">
				<xsl:with-param name="contextBasePath">
					<xsl:value-of select="$sourceBasePath"/>
				</xsl:with-param>
				<xsl:with-param name="contextPathAndFileName">
					<xsl:value-of select="$sourcePathAndFileName"/>
				</xsl:with-param>
				<xsl:with-param name="schemaLocationStringRecursionCheck">
					<xsl:value-of select="$schemaLocationStringRecursionCheck"/>
				</xsl:with-param>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:copy-of select="$schemaFileRelationMapping/*"/>
	</xsl:template>

	<!-- ******************************** 
  match="xsd:schema" mode="fileRelationMapping"   
 ******************************** -->
	<xsl:template match="xsd:schema" mode="fileRelationMapping">
		<xsl:param name="contextBasePath"/>
		<xsl:param name="contextPathAndFileName"/>
		<xsl:param name="schemaLocationStringRecursionCheck"/>
		<xsl:variable name="nsdefault">
			<xsl:for-each-group select="namespace::node()" group-by="name(.)">
				<xsl:if test="name(.)=''">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="nstargetNamespace">
			<xsl:value-of select="@targetNamespace"/>
		</xsl:variable>
		<xsl:variable name="ns">
			<xsl:choose>
				<xsl:when test="$nsdefault!=''">
					<xsl:value-of select="$nsdefault"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$nstargetNamespace"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<file type="root" ns="{$ns}" match="xsd:schema" mode="fileRelationMapping">
			<name>
				<xsl:value-of select="$contextPathAndFileName"/>
			</name>
			<relativename>
				<xsl:value-of select="substring-after($contextPathAndFileName,$contextBasePath)"/>
			</relativename>
			<xsl:for-each select="xsd:include | xsd:import">
				<xsl:call-template name="fileRelationMappingIncludes">
					<xsl:with-param name="contextBasePath">
						<xsl:value-of select="$contextBasePath"/>
					</xsl:with-param>
					<xsl:with-param name="contextPathAndFileName">
						<xsl:value-of select="$contextPathAndFileName"/>
					</xsl:with-param>
					<xsl:with-param name="schemaLocationStringRecursionCheck">
						<xsl:value-of select="$schemaLocationStringRecursionCheck"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
		</file>
	</xsl:template>

	<xsl:template name="get-uri-elementNodeWithNameAttribute">
		<xsl:call-template name="get-uri">
			<xsl:with-param name="arg1qname" select="@name"/>
			<xsl:with-param name="arg2element" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="get-uri-elementNodeWithRefAttribute">
		<xsl:call-template name="get-uri">
			<xsl:with-param name="arg1qname" select="@ref"/>
			<xsl:with-param name="arg2element" select="."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="get-uri-attributeNode">
		<xsl:call-template name="get-uri">
			<xsl:with-param name="arg1qname" select="."/>
			<xsl:with-param name="arg2element" select=".."/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="get-uri-thiselement">
		<xsl:param name="arg1qname"/>
		<xsl:param name="arg2element"/>
		<xsl:choose>
			<xsl:when test="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))=''">
				<xsl:choose>
					<xsl:when test="ancestor::xsd:schema[1]/@targetNamespace">
						<xsl:value-of select="ancestor::xsd:schema[1]/@targetNamespace"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$schemaFiles/file/@ns"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="get-uri">
		<xsl:param name="arg1qname"/>
		<xsl:param name="arg2element"/>
		<!--
	this method checks targetNamespace first.
	use case digital sig schema where there is a different default ns from the target ns.
	
	
	-->
		<xsl:choose>
			<xsl:when test="contains($arg1qname,':')">
				<xsl:value-of
					select="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))"/>
			</xsl:when>
			<xsl:when test="ancestor::xsd:schema[1]/@targetNamespace">
				<xsl:value-of select="ancestor::xsd:schema[1]/@targetNamespace"/>
			</xsl:when>
			<xsl:when test="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))=''">
				<xsl:value-of select="$schemaFiles/file/@ns"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--
		this version works fine but not with dsig schema
		where default ns != targetNS

	-->
	<!-- get-uri-nsuri good for oag and all nontwist schemas bad for twist -->
	<xsl:template name="get-uri-nsuri">
		<xsl:param name="arg1qname"/>
		<xsl:param name="arg2element"/>
		<xsl:choose>
			<xsl:when test="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))=''">
				<xsl:choose>
					<xsl:when test="ancestor::xsd:schema[1]/@targetNamespace">
						<xsl:value-of select="ancestor::xsd:schema[1]/@targetNamespace"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$schemaFiles/file/@ns"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="namespace-uri-from-QName(resolve-QName($arg1qname,$arg2element))"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
