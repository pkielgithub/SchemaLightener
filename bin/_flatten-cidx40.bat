:: 
:: flatten-cidx40.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, CIDX version 4.0. 
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
SET logfile=results/output-flatten-cidx40.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_AcceptanceNotification.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_AcceptanceNotification.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CarrierWeights.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CarrierWeights.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CertificateOfAnalysis.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CertificateOfAnalysis.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportCreditRequest.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportCreditRequest.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportCreditResponse.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportCreditResponse.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportRequest.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportRequest.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportRequestChange.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportRequestChange.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportResponse.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CostSupportResponse.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%

echo java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_DeliveryReceipt.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile% 
java -jar saxon9.jar ../SampleData/cidx/Schemas/CIDX_CeS_v4.0_Message_DeliveryReceipt.xsd ../SchemaFlattener.xslt resultBasePath=results/temp-flatten-cidx40/ 2>>%logfile%
 