:: 
:: lighten-oag92.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, OAGIS version 9.2. 
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
SET logfile=results/output-lighten-oagis92.txt
SET errorlogfile=%logfile%.errors.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeAllocateResource/AcknowledgeAllocateResource.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeAllocateResource.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeAllocateResource/ rootElement="AcknowledgeAllocateResource" 1>>%logfile% 2>>%errorlogfile%  
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeAllocateResource/AcknowledgeAllocateResource.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeAllocateResource.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeAllocateResource/ rootElement="AcknowledgeAllocateResource" 1>>%logfile% 2>>%errorlogfile% 


echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeConfirmWIP/AcknowledgeConfirmWIP.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeConfirmWIP.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeConfirmWIP/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeConfirmWIP/AcknowledgeConfirmWIP.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeConfirmWIP.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeConfirmWIP/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCreditTransfer/AcknowledgeCreditTransfer.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCreditTransfer.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCreditTransfer/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCreditTransfer/AcknowledgeCreditTransfer.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCreditTransfer.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCreditTransfer/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeDebitTransfer/AcknowledgeDebitTransfer.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeDebitTransfer.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeDebitTransfer/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeDebitTransfer/AcknowledgeDebitTransfer.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeDebitTransfer.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeDebitTransfer/ 1>>%logfile% 2>>%errorlogfile%


echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCostingActivity/AcknowledgeCostingActivity.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCostingActivity.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCostingActivity/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCostingActivity/AcknowledgeCostingActivity.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCostingActivity.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCostingActivity/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCredit/AcknowledgeCredit.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCredit.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCredit/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCredit/AcknowledgeCredit.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCredit.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCredit/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCreditStatus/AcknowledgeCreditStatus.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCreditStatus.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCreditStatus/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCreditStatus/AcknowledgeCreditStatus.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCreditStatus.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCreditStatus/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCreditTransferIST/AcknowledgeCreditTransferIST.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCreditTransferIST.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCreditTransferIST/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeCreditTransferIST/AcknowledgeCreditTransferIST.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeCreditTransferIST.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeCreditTransferIST/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeDebitTransferIST/AcknowledgeDebitTransferIST.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeDebitTransferIST.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeDebitTransferIST/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeDebitTransferIST/AcknowledgeDebitTransferIST.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeDebitTransferIST.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeDebitTransferIST/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeDispatchList/AcknowledgeDispatchList.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeDispatchList.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeDispatchList/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/oagis/9.2/Release/BODs/Standalone/AcknowledgeDispatchList/AcknowledgeDispatchList.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/oagis/9.2/Release/References/GeneratedBODInstances/AcknowledgeDispatchList.xml resultBasePath=results/temp-lighten-oag92/AcknowledgeDispatchList/ 1>>%logfile% 2>>%errorlogfile%

