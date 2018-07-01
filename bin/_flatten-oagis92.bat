:: 
:: flatten-oagis92.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, OAGIS version 9.2. 
:: 
:: syntax:
:: 
::echo java -jar saxon9.jar [-o output file (optional)] [source XSD path] [stylesheet] resultBasePath=[result path]  
::java -jar saxon9.jar [-o output file (optional)] [source XSD path] [stylesheet] resultBasePath=[result path] 
::
::
:: Parameters:
:: resultBasePath - full or relative path to directory where result should be placed. Make sure permissions are set to allow this.
::
:: Notes on parameters and XSLT processors:
:: 1. Some XSLT processors require file:/// to precede a full drive or network path, e.g.
:: 
:: <xsl:param name=instanceFilePathAndName>file:///c:/xmlschemas/SamplePostalAddress.xml</xsl:param>
:: 
:: 2. Some XSLT processors will not work well with back slashes \ and so forward slashes / are recommended.
:: 3. Some XSLT processors may need a trailing forward slash / to correctly create the result folder, as in:
:: 
:: <xsl:param name=resultBasePath>file:///c:/xmlschemas/lightened/result/</xsl:param>
::
:: The trailing forward slash is therefore recommended.
::
SET logfile=results/output-flatten-oagis92.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeAllocateResource.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeAllocateResource.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeConfirmWIP.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeConfirmWIP.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCostingActivity.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCostingActivity.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCredit.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCredit.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCreditStatus.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCreditStatus.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCreditTransfer.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCreditTransfer.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCreditTransferIST.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeCreditTransferIST.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeDebitTransfer.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeDebitTransfer.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeDebitTransferIST.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeDebitTransferIST.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeDispatchList.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Developer/AcknowledgeDispatchList.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-oag92/ 2>>%logfile%
