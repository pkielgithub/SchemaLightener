:: 
:: lighten-cidx40.bat
:: 
:: This batch file is used to apply the Schema Lightener xslt to multiple source files. In this case, CIDX version 4.0. 
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
SET logfile=results/output-lighten-cidx40.txt
SET errorlogfile=%logfile%.errors.txt

echo START >%logfile%
echo. 2>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CarrierWeights.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CarrierWeightsV40.xml resultBasePath=results/temp-lighten-cidx40/CarrierWeightsV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CarrierWeights.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CarrierWeightsV40.xml resultBasePath=results/temp-lighten-cidx40/CarrierWeightsV40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CertificateOfAnalysis.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CertificateOfAnalysisV40.xml resultBasePath=results/temp-lighten-cidx40/CertificateOfAnalysisV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CertificateOfAnalysis.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CertificateOfAnalysisV40.xml resultBasePath=results/temp-lighten-cidx40/CertificateOfAnalysisV40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CustomerCatalogUpdate(Add)V40.xml resultBasePath=results/temp-lighten-cidx40/CustomerCatalogUpdate(Add)V40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CustomerCatalogUpdate(Add)V40.xml resultBasePath=results/temp-lighten-cidx40/CustomerCatalogUpdate(Add)V40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CustomerCatalogUpdate(Delete)V40.xml resultBasePath=results/temp-lighten-cidx40/CustomerCatalogUpdate(Delete)V40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CustomerCatalogUpdate(Delete)V40.xml resultBasePath=results/temp-lighten-cidx40/CustomerCatalogUpdate(Delete)V40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CustomerCatalogUpdate(Replace)V40.xml resultBasePath=results/temp-lighten-cidx40/CustomerCatalogUpdate(Replace)V40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_CustomerSpecificCatalogUpdate.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/CustomerCatalogUpdate(Replace)V40.xml resultBasePath=results/temp-lighten-cidx40/CustomerCatalogUpdate(Replace)V40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DeliveryReceiptResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DeliveryReceiptResponseV40.xml resultBasePath=results/temp-lighten-cidx40/DeliveryReceiptResponseV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DeliveryReceiptResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DeliveryReceiptResponseV40.xml resultBasePath=results/temp-lighten-cidx40/DeliveryReceiptResponseV40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DeliveryReceipt.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DeliveryReceiptV40.xml resultBasePath=results/temp-lighten-cidx40/DeliveryReceiptV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DeliveryReceipt.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DeliveryReceiptV40.xml resultBasePath=results/temp-lighten-cidx40/DeliveryReceiptV40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DemandForecastResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DemandForecastResponseV40.xml resultBasePath=results/temp-lighten-cidx40/DemandForecastResponseV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DemandForecastResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DemandForecastResponseV40.xml resultBasePath=results/temp-lighten-cidx40/DemandForecastResponseV40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DemandForecast.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DemandForecastV40.xml resultBasePath=results/temp-lighten-cidx40/DemandForecastV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DemandForecast.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DemandForecastV40.xml resultBasePath=results/temp-lighten-cidx40/DemandForecastV40/ 1>>%logfile% 2>>%errorlogfile%

echo java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DemandPlanResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DemandPlanResponseV40.xml resultBasePath=results/temp-lighten-cidx40/DemandPlanResponseV40/ 1>>%logfile% 2>>%errorlogfile% 
java -jar saxon9.jar ../SampleData/cidx/schemas/cidx_CeS_v4.0_Message_DemandPlanResponse.xsd ../SchemaLightener.xslt instanceFilePathAndName=SampleData/cidx/xml/DemandPlanResponseV40.xml resultBasePath=results/temp-lighten-cidx40/DemandPlanResponseV40/ 1>>%logfile% 2>>%errorlogfile%
