:: 
:: lighten-acord29.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, ACORD version 2.9. 
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
SET logfile=results/output-lighten-acord29.txt
SET errorlogfile=%logfile%.errors.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request1.xml resultBasePath=results/temp-lighten-acord29/Acord103Request1/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request1.xml resultBasePath=results/temp-lighten-acord29/Acord103Request1/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request2.xml resultBasePath=results/temp-lighten-acord29/Acord103Request2/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request2.xml resultBasePath=results/temp-lighten-acord29/Acord103Request2/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request3.xml resultBasePath=results/temp-lighten-acord29/Acord103Request3/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request3.xml resultBasePath=results/temp-lighten-acord29/Acord103Request3/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request4.xml resultBasePath=results/temp-lighten-acord29/Acord103Request4/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request4.xml resultBasePath=results/temp-lighten-acord29/Acord103Request4/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request5.xml resultBasePath=results/temp-lighten-acord29/Acord103Request5/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request5.xml resultBasePath=results/temp-lighten-acord29/Acord103Request5/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request6.xml resultBasePath=results/temp-lighten-acord29/Acord103Request6/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request6.xml resultBasePath=results/temp-lighten-acord29/Acord103Request6/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request7.xml resultBasePath=results/temp-lighten-acord29/Acord103Request7/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request7.xml resultBasePath=results/temp-lighten-acord29/Acord103Request7/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request8.xml resultBasePath=results/temp-lighten-acord29/Acord103Request8/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request8.xml resultBasePath=results/temp-lighten-acord29/Acord103Request8/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request9.xml resultBasePath=results/temp-lighten-acord29/Acord103Request9/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request9.xml resultBasePath=results/temp-lighten-acord29/Acord103Request9/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request10.xml resultBasePath=results/temp-lighten-acord29/Acord103Request10/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/acord/schemas/TXLife2.9.00.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/acord/xml/Acord103Request10.xml resultBasePath=results/temp-lighten-acord29/Acord103Request10/ 1>>%logfile% 2>>%errorlogfile%
