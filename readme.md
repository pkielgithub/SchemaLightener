# Xml SchemaLightener

One tool, 3 functions.  1.  Schema Lightener  2. Schema Flattener  3.  WSDL Flattener

The Xml SchemaLightener is a tool designed to help you prune unnecessary elements, attributes and data types from your Xml Schema. Sometimes referred to as "LiteBODs", "Schema subsets", "constrained Schemas", or "pruned Schemas." This tool helps you create a simplified Xml Schema that conforms to an original. In a literal sense, the Xml SchemaLightener is an XSLT stylesheet that is applied to your Schema.

The Xml SchemaLightener also has 2 additional functions to help with similar problems.  The Xml Schema Flattener will flatten your schemas to they are in the fewest (or perhaps even a single) schema file.  This makes deployment easier.  

Finally there is the WSDL Flattener, which does for WSDL what the flattener does for schemas.  Namely, merge all included dependecies into a single WSDL.  (In fact, all schemas used in the WSDL are also merged into the result file.)

## Getting Started

The heart of the tool is a set of XSLTs that do the transformations in all 3 functions.  Each XSLT can be applied in several ways.  First, they can be applied via command like (i.e. batch or shell).  Parameters are noted in the XSLTs that indicate how to populate them.
Secondly, the tool comes with a GUI.  The GUI is a java app that allows for very simply point and click invocation of the functions.
See XSLT extension files in distribution.

If simplicity is what you're interested in, you can simply use "start.bat" to invoke the GUI that is used on top of the XSLTs.

### Definitions

#### Lighten:
```The process of removing components that are never used from an Xml Schema. Any global component can be removed such as elements, attributes, types, attributeGroups, and groups. The lightening process retains the syntax and data model of the original Schema, but with unused components removed. The result is a valid Xml Schema which mirrors the original Xml Schema's data model, but with selected components omitted. In this manner, a very large Xml Schema data model can be reduced to a usable size while still conforming to the original.```

#### Flatten:
```The process of consolidating all dependencies of an Xml Schema into a single file. In short, all xsd:include files are merged into a single Schema. The SchemaFlattener will merge all xsd:includes together in a selected Schema. In addition, it will do the same for each xsd:import dependency. NOTE: Xml Schema does not allow files from different namespaces to be merged together. This means files connected via xsd:import cannot be merged. These import relationships are retained and put into the result. Each file's xsd:includes however are merged. This has the effect of consolidating a group of Xml Schemas into the fewest possible files. If there are no xsd:imports, then it will result in a single, stand alone Schema.```

### Requirements

```Using the stylesheets: an XSLT 2.0 processor.  Saxon is included in the distribution.```

```Operating system: The SchemaLightener XSLTs and UI have been tested on Windows Vista, XP, and Linux.```

```For the Graphical User Interface (GUI): java runtime jre 1.6 or greater```


### How does it work?
An XSLT stylesheet is applied to the original Xml Schema. It takes as input an Xml instance which is valid against that Schema. The instance contains the subset desired in the result. The XSLT prunes the Schema, removing elements, attributes and data types that are not needed to validate the given Xml instance. 

When you Include all the data that you want in the instance, the Lightener creates a Schema that only validate nodes in that instance.


### Why would I need it?
Consider these scenarios.
You have an Xml Schema and want to implement a subset (a selected portion) of the data points. You want a runtime version that can be used for validation.

You want to create a view of a Schema directed at a particular audience containing a portion of data points pertinent to them.

You have an internal data model and want to communicate to a trading partner only the data points necessary for a particular B2B (Business to Business) integration.

You are implementing an Xml Schema acquired from somewhere else (i.e. from a trading partner, or from a standards consortium such as OAGi, HR-Xml, etc.) and want to implement only the data points relevant to your business context.
In any of these scenarios, you require a simplified Xml Schema to be consistent with the original. Specifically, you want an Xml instance that is valid against the subset to also validate against the original. But how can this be done? Previously, there were only 2 principle solutions for this; First, edit the original schema. This works but is tedious and risks hand editing errors. Second, you could implement Schematron technology. This also works, but may not always be possible (see How does this relate to Schematron?).

The Xml SchemaLightener helps you create a subset / LiteBOD / pruned Schema from any original Schema. The image below illustrates how this tool fits into an Xml management context.


### Does it have a GUI?
A Graphical User Interface (GUI) is included for all three tools. The GUI allows you to simply point and click. Select a Schema, select an Xml instance, select a destination folder, and then push a button. It's that simple!


## How much of a benefit do I get?

Earlier iterations of the tool have been measured in terms of how much reduction in code is achieved.  Details are located here:
http://www.xmlhelpline.com/tools/SchemaLightener.php#howmuch

## Has it been rigorously tested?

In anticipation of putting the tool on Github, in 2018 a full regression testing was completed.  A file summarizing the validation results of schemas tested is included in "regressiontesting_schemas_validationinfo.txt".  In essense over 15,000 files were created and tested.

Earlier testing was done during its development. The Xml SchemaLightener was extensively tested against thousands of schemas.  Details are located here:
http://www.xmlhelpline.com/tools/SchemaLightener.php#tested



## What's included

The core of the SchemaLightener which is 3 main XSLT stylesheets. This can be used with any XSLT 2.0 processor.  The 3 functions correlate to tthe 3 main XSLTs.
SchemaLightener.xslt, SchemaFlattener.xslt, and WSDLFlattener.xslt.

For your convenience, it comes bundled with Saxon, an XSLT processor created by Michael Kay. An open source version of Saxon is included in this product. http://saxon.sourceforge.net. See Saxon notices in this package for legal notes on its usage.

A user interface (UI). The UI can invoke both the Flattener and Lightener XSLT stylesheets. It also provides full logging with stack trace. It is cross-platform java and has been tested on Windows and Ubuntu Llinux. 

The complete source code for the user interface (UI). Written in java, a simple swing application.

Sample data. Selected Xml Schemas and Xml instances from numerous standards consortia are included.

Batch files that invoke the Lightener and Flattener across many files. (While the UI allows you to apply the stylesheets one at a time, the batch files combined with the XSLT processor allow you to create as many results as needed.) The batch files included use Saxon to process the sample data.

Now you also get the WSDLFlattener too. It does for WSDL what the SchemaFlattener does for Schemas.

## Authors

* **Paul Kiel** - *Initial work* - [Paul Kiel](https://github.com/pkielgithub)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

