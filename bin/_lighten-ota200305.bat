:: 
:: lighten-ota200305.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, OTA version 2003-05. 
:: 
:: syntax:
:: 
::echo java -jar saxon9.jar [source XSD path] [stylesheet] instanceFilePathAndName=[xml instance path] resultBasePath=[result path]  
::java -jar saxon9.jar [source XSD path] [stylesheet] instanceFilePathAndName=[xml instance path] resultBasePath=[result path] 
::
::
:: Parameters:
:: instanceFilePathAndName - full or relative path to representative xml instance document.
:: resultBasePath - full or relative path to directory where result should be placed. Make sure permissions are set to allow this.
::
:: Notes on parameters and XSLT processors:
:: 1. Some XSLT processors require "file:///" to precede a full drive or network path, e.g.
:: 
:: 	<xsl:param name="instanceFilePathAndName">file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>
:: 
:: 2. Some XSLT processors will not work well with back slashes "\" and so forward slashes "/" are recommended.
:: 3. Some XSLT processors may need a trailing forward slash "/" to correctly create the result folder, as in:
:: 
:: 	<xsl:param name="resultBasePath">file:///c:/xmlschemas/lightened/result/</xsl:param>
::
:: The trailing forward slash is therefore recommended.
::
SET logfile=results/output-lighten-ota200305.txt
SET errorlogfile=%logfile%.errors.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirAvailRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirAvailRQ.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirAvailRQ/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirAvailRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirAvailRQ.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirAvailRQ/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirAvailRS.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirAvailRS.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirAvailRS/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirAvailRS.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirAvailRS.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirAvailRS/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ2.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ2/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ2.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ2/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ3.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ3/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ3.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ3/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ4.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ4/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ4.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ4/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ5.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ5/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ5.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ5/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ6.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ6/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ6.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ6/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ7.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ7/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ7.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ7/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ8.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ8/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/ota/schemas/FS_OTA_AirBookModifyRQ.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/ota/xml/OTA_AirBookModifyRQ8.xml resultBasePath=results/temp-lighten-ota200305/OTA_AirBookModifyRQ8/ 1>>%logfile% 2>>%errorlogfile%
