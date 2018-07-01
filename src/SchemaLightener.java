import javax.swing.*;
import javax.xml.transform.*;
import java.awt.*;
import java.awt.event.*;
import java.io.File;
import java.io.PrintWriter;
import java.io.StringWriter;

/**
 * GUI interface to the SchemaLightener functions.
 * This application is a UI for the schema lightener and flattener functions only.
 * A GUI is not necessary to use the tool, and can be invoked via command line
 * as indicated in distribution.
 * Three primary functions include Flattening Schemas, Lightening Schemas, and Flattening WSDLs.
 *
 * @author  Paul Kiel, xmlHelpline.com Consulting
 * @version 4.9
 * @since   2016-05-27
 */
public class SchemaLightener extends JPanel implements ActionListener {

    private String defaultPath = new File(".").getAbsolutePath();

    static private final String newline = "\n";
    static private final String hr = "------------------------------" + newline;
    private JButton jbnSelectFlattenWSDL, jbnSelectFlattenSchema, jbnSelectLightenSchema,
            jbnFlattenWSDLDestination, jbnFlattenDestination, jbnLightenDestination,
            jbnSelectLightenInstance, jbnFlattenWSDL, jbnFlatten, jbnLighten ;
    private JTextArea jtaFlattenLog = new JTextArea(500, 100);
    private JTextArea jtaFlattenWSDLLog = new JTextArea(500, 100);
    private JTextArea jtaLightenLog = new JTextArea(500, 100);
    private JFileChooser jfcSelectFlattenWSDL, jfcSelectFlattenSchema, jfcSelectLightenInstance, jfcSelectLightenSchema;
    private JFileChooser jfcFlattenWSDLDestination, jfcFlattenDestination, jfcLightenDestination;
    private String stringFlattenWSDLPath = "";
    private String stringFlattenWSDLDestinationPath = "";
    private String stringFlattenSchemaPath = "";
    private String stringFlattenDestinationPath = "";
    private String stringLightenSchemaPath = "";
    private String stringLightenInstancePath = "";
    private String stringLightenDestinationPath = "";

    private int v = ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED;
    private int h = ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED;
    private Font tabFont = new Font("arial", Font.PLAIN, 18);
    private Font buttonFont = new Font("arial", Font.PLAIN, 14);
    private Color myGold = new Color(238, 210, 0);
    private Dimension spacerSize = new Dimension(0, 5);
//    private Dimension spacerHSize = new Dimension(5, 5);
    private Dimension selectButtonSize = new Dimension(200, 40);
    private Dimension labelSize = new Dimension(250, 20);
//    private Dimension textFieldSize = new Dimension(150, 20);
    static private final String stringXsltLightenSourceFile = "SchemaLightener.xslt";
    static private final String stringXslFlattenSourceFile = "SchemaFlattener.xslt";
    static private final String stringXslFlattenWSDLSourceFile = "WSDLFlattener.xslt";


    public SchemaLightener() {
        setLookAndFeel(); // see this method for more
        //ImageIcon icon = new ImageIcon("java-swing-tutorial.JPG");

        JTabbedPane jtpToolPane = new JTabbedPane();

        JPanel jplInnerLightenPanel = createLightenerPanel();

        jtpToolPane.addTab("Xml Schema Lightener", jplInnerLightenPanel);
        jtpToolPane.setSelectedIndex(0);
        jplInnerLightenPanel.setBackground(Color.GREEN);
        jtaLightenLog.setLineWrap(true);
        jtaLightenLog.setWrapStyleWord(true);
        jtaLightenLog.setBorder(BorderFactory.createLineBorder(Color.BLACK));
        jtaLightenLog.append(
                "Output log:" + newline + hr +
                        "1. Select a schema to lighten." + newline +
                        "2. Select a representative xml instance document." + newline +
                        "3. Select a destination folder where result will be placed." + newline +
                        "4. Use 'Lighten Schema' button to execute." +
                        newline + hr);


        JPanel jplInnerFlattenPanel = createFlattenerPanel();
        jtpToolPane.addTab("Xml Schema Flattener", jplInnerFlattenPanel);
        jplInnerFlattenPanel.setBackground(myGold); // could do light blue
        jtaFlattenLog.setLineWrap(true);
        jtaFlattenLog.setWrapStyleWord(true);
        jtaFlattenLog.setBorder(BorderFactory.createLineBorder(Color.BLACK));
        jtaFlattenLog.append(
                "IMPORTANT NOTE: All xsd:includes are merged, but xsd:imports cannot be merged into the result. This is due to the Xml Schema specification itself and not because of this tool." +
                "  Schemas with different targetNamespaces cannot be put into the same schema file.  Again due to the spec itself."
                        + newline + hr + hr + newline +
                "Output log:" + newline + hr +
                        "1. Select a schema to flatten." + newline +
                        "2. Select a destination folder where result will be placed." + newline +
                        "3. Use 'Flatten Schema' button to execute." +
                        newline + hr);

        JPanel jplInnerFlattenWSDLPanel = createWSDLFlattenerPanel();
        jtpToolPane.addTab("WSDL Flattener", jplInnerFlattenWSDLPanel);
        jplInnerFlattenWSDLPanel.setBackground(Color.CYAN); // could do light blue
        jtaFlattenWSDLLog.setLineWrap(true);
        jtaFlattenWSDLLog.setWrapStyleWord(true);
        jtaFlattenWSDLLog.setBorder(BorderFactory.createLineBorder(Color.BLACK));
        jtaFlattenWSDLLog.append(
                "Output log:" + newline + hr +
                        "1. Select a WSDL to flatten." + newline +
                        "2. Select a destination folder where result will be placed." + newline +
                        "3. Use 'Flatten WSDL' button to execute." +
                        newline + hr);

        // Add the tabbed pane to this panel.
        setLayout(new GridLayout(1, 1));
        add(jtpToolPane);



    }


    /**
     * flattenTransformer creates a transformer for applying an XSLT to an xml document
     * in this case applied to an xml schema.
     * <p>
     * Results will be posted to the panel log.
     *
     * @param  stringXmlSourcePath  the xml schema to be flattened
     * @param  resultBasePath the location for the result
     *
     * Ideally the 3 transformers should be in an extended base method or a single method with parameters.
     * Since they were each added at different points in time, it wasn't originally designed that way.
     * Put that on a "to do" list. :)
     */
    @SuppressWarnings("TryWithIdenticalCatches")
    private void flattenTransformer(String stringXmlSourcePath, String resultBasePath) throws TransformerException  {

//        Transformer transformer = tFactory.newTransformer(
//                new StreamSource(new File(stringXslFlattenSourceFile)));
//        System.setProperty("javax.xml.transform.TransformerFactory",
//                "net.sf.saxon.TransformerFactoryImpl");
//        NOTE: This sometimes defaults to xalan despite setProperty ref to saxon.
//          so instead of setProperty, explicitly call saxon transformer

        TransformerFactory transformerSaxon = TransformerFactory.newInstance(
                "net.sf.saxon.TransformerFactoryImpl", null);

        String sourceBasePath;

        sourceBasePath = "file:///" + stringXmlSourcePath;

        Source sourceXmlSourceDoc = new javax.xml.transform.stream.StreamSource(stringFlattenSchemaPath);
        Source sourceXsltSourceDoc = new javax.xml.transform.stream.StreamSource(stringXslFlattenSourceFile);
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);

        Result result = new javax.xml.transform.stream.StreamResult(sw);

        Transformer trans = transformerSaxon.newTransformer(sourceXsltSourceDoc);

        trans.setParameter("sourcePathAndFileName", sourceBasePath);
        trans.setParameter("resultBasePath", resultBasePath);

        try {

            trans.transform(sourceXmlSourceDoc, result);

        } catch (TransformerConfigurationException tce) {
            jtaFlattenLog.append(
                    "Exception: " + tce + newline + tce.getMessageAndLocation()
                            + newline + hr);
            tce.printStackTrace();
            jtaFlattenLog.append(resultBasePath + hr + "Stack trace:" + newline);
            try {

                tce.printStackTrace(pw);
                jtaFlattenLog.append(sw.toString() + newline + hr);

            } catch (Exception e2) {
                jtaFlattenLog.append(
                        "Cannot write stack trace to log." + newline + hr);
            }
        } catch (TransformerException te) {
            jtaFlattenLog.append(
                    "Exception: " + te + newline + te.getMessageAndLocation()
                            + newline + hr);
            te.printStackTrace();
            jtaFlattenLog.append(resultBasePath + hr + "Stack trace:" + newline);
            try {

                te.printStackTrace(pw);
                jtaFlattenLog.append(sw.toString() + newline + hr);

            } catch (Exception e2) {
                jtaFlattenLog.append(
                        "Cannot write stack trace to log." + newline + hr);
            }
        } finally {
            jtaFlattenLog.append(
                    "xmlsource:" + stringXmlSourcePath +hr +
                    "xslsource:" + stringXslFlattenSourceFile +hr +
                            newline + hr);


        }

        jtaFlattenLog.append(
                "Finished.  See destination folder for results." + newline + hr);

    }


    /**
     * lightenTransformer creates a transformer for applying an XSLT to an xml document
     * in this case applied to an xml schema with the additional input
     * of an xml instance which is used to indicate what to retain in the result
     * <p>
     * Results will be posted to the panel log.
     *
     * @param  stringXmlSourcePath  the xml schema to be flattened
     * @param  resultBasePath the location for the result
     * @param  instanceFileName the xml instance document used to indicate nodes for retention
     */
    @SuppressWarnings("TryWithIdenticalCatches")
    private void lightenTransformer(String stringXmlSourcePath, String resultBasePath, String instanceFileName) throws TransformerException {

        TransformerFactory transformerSaxon = TransformerFactory.newInstance(
                "net.sf.saxon.TransformerFactoryImpl", null);

        String sourceBasePath;

        sourceBasePath = "file:///" + stringXmlSourcePath;

        Source sourceXmlSourceDoc = new javax.xml.transform.stream.StreamSource(stringLightenSchemaPath);
        Source sourceXsltSourceDoc = new javax.xml.transform.stream.StreamSource(stringXsltLightenSourceFile);
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);

        Result result = new javax.xml.transform.stream.StreamResult(sw);

        Transformer trans = transformerSaxon.newTransformer(sourceXsltSourceDoc);

        trans.setParameter("sourcePathAndFileName", sourceBasePath);
        trans.setParameter("instanceFilePathAndName", instanceFileName);
        trans.setParameter("resultBasePath", resultBasePath);

        try {

            trans.transform(sourceXmlSourceDoc, result);

        } catch (TransformerConfigurationException tce) {
            jtaLightenLog.append(
                    "Exception: " + tce + newline + tce.getMessageAndLocation()
                            + newline + hr);
            tce.printStackTrace();
            jtaLightenLog.append(resultBasePath + hr + "Stack trace:" + newline);
            try {

                tce.printStackTrace(pw);
                jtaLightenLog.append(sw.toString() + newline + hr);

            } catch (Exception e2) {
                jtaLightenLog.append(
                        "Cannot write stack trace to log." + newline + hr);
            }

        } catch (TransformerException te) {
            jtaLightenLog.append(
                    "Exception: " + te + newline + te.getMessageAndLocation()
                            + newline + hr);
            te.printStackTrace();
            jtaLightenLog.append(resultBasePath + hr + "Stack trace:" + newline);
            try {

                te.printStackTrace(pw);
                jtaLightenLog.append(sw.toString() + newline + hr);

            } catch (Exception e2) {
                jtaLightenLog.append(
                        "Cannot write stack trace to log." + newline + hr);
            }
        }

        jtaLightenLog.append(
                "Finished.  See destination folder for results." + newline + hr);
    }


    /**
     * flattenWSDLTransformer creates a transformer for applying an XSLT to an xml document
     * in this case applied to a WSDL.
     * <p>
     * Results will be posted to the panel log.
     *
     * @param  stringXmlSourcePath  the xml schema to be flattened
     * @param  resultBasePath the location for the result
     */
    @SuppressWarnings("TryWithIdenticalCatches")
    private void flattenWSDLTransformer(String stringXmlSourcePath, String resultBasePath) throws TransformerException {

        TransformerFactory transformerSaxon = TransformerFactory.newInstance(
                "net.sf.saxon.TransformerFactoryImpl", null);

        String sourceBasePath;

        sourceBasePath = "file:///" + stringXmlSourcePath;

        Source sourceXmlSourceDoc = new javax.xml.transform.stream.StreamSource(stringFlattenWSDLPath);
        Source sourceXsltSourceDoc = new javax.xml.transform.stream.StreamSource(stringXslFlattenWSDLSourceFile);
        StringWriter sw = new StringWriter();
        PrintWriter pw = new PrintWriter(sw);

        Result result = new javax.xml.transform.stream.StreamResult(sw);

        Transformer trans = transformerSaxon.newTransformer(sourceXsltSourceDoc);

        trans.setParameter("sourcePathAndFileName", sourceBasePath);
        trans.setParameter("resultBasePath", resultBasePath);

        try {

            trans.transform(sourceXmlSourceDoc, result);


        } catch (TransformerConfigurationException tce) {
            jtaFlattenWSDLLog.append(
                    "Exception: " + tce + newline + tce.getMessageAndLocation()
                            + newline + hr);
            tce.printStackTrace();
            jtaFlattenWSDLLog.append(resultBasePath + hr + "Stack trace:" + newline);
            try {
                tce.printStackTrace(pw);
                jtaFlattenWSDLLog.append(sw.toString() + newline + hr);

            } catch (Exception e2) {
                jtaFlattenWSDLLog.append(
                        "Cannot write stack trace to log." + newline + hr);
            }
        } catch (TransformerException te) {
            jtaFlattenWSDLLog.append(
                    "Exception: " + te + newline + te.getMessageAndLocation()
                            + newline + hr);
            te.printStackTrace();
            jtaFlattenWSDLLog.append(resultBasePath + hr + "Stack trace:" + newline);
            try {
                te.printStackTrace(pw);
                jtaFlattenWSDLLog.append(sw.toString() + newline + hr);

            } catch (Exception e2) {
                jtaFlattenWSDLLog.append(
                        "Cannot write stack trace to log." + newline + hr);
            }
        }

        jtaFlattenWSDLLog.append(
                "Finished.  See destination folder for results." + newline + hr);

    }


    /**
     * createFlattenerPanel creates a panel for use in the tabbed tool.
     * This panel is for the xml schema flattening function.
     * in this case applied to an xml schema.
     * Ideally the 3 panels should be in an extended base method or a single method with parameters.
     * Since they were each added at different points in time, it wasn't originally designed that way.
     * Put that on a "to do" list. :)
     */
    private JPanel createFlattenerPanel() {

        JPanel jplPanel = new JPanel();

        jplPanel.setLayout(null);

        JLabel jlbDisplay = new JLabel("Flatten Schemas");
        jlbDisplay.setFont(new Font("arial", Font.BOLD, 18));

        jbnFlatten = new JButton("   Flatten schema   ");
        jbnFlatten.addActionListener(this);
        jfcSelectFlattenSchema = new JFileChooser(defaultPath);
        jbnSelectFlattenSchema = new JButton("   Select schema to flatten...   ");
        jfcFlattenDestination = new JFileChooser(defaultPath);
        jfcFlattenDestination.setFileSelectionMode(
                JFileChooser.DIRECTORIES_ONLY);
        jfcFlattenDestination.setFileHidingEnabled(true);
        jfcFlattenDestination.setMultiSelectionEnabled(false);

        jbnFlattenDestination = new JButton(
                "   Select destination folder ...   ");
        jbnFlattenDestination.addActionListener(this);
        jbnSelectFlattenSchema.addActionListener(this);
        jbnSelectFlattenSchema.setBorder(BorderFactory.createRaisedBevelBorder());
        jbnFlattenDestination.setBorder(BorderFactory.createRaisedBevelBorder());
        jbnFlatten.setBorder(BorderFactory.createRaisedBevelBorder());
        jplPanel.setBorder(BorderFactory.createRaisedBevelBorder());

        JLabel jlbFlattenText = new JLabel(
                "Flattening schemas refers to the process of merging all xsd:include schemas into a stand alone version." );
        jlbFlattenText.setFont(new Font("arial", Font.PLAIN, 12));

        JScrollPane jsplFlattenLogScrollPanel = new  JScrollPane(jtaFlattenLog,
                v, h);

        jplPanel.setLayout(new BoxLayout(jplPanel, BoxLayout.PAGE_AXIS));
        jplPanel.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.setBorder(BorderFactory.createEmptyBorder(0, 15, 10, 10));
        jplPanel.add(Box.createRigidArea(spacerSize));

        jlbDisplay.setPreferredSize(labelSize);
        jlbDisplay.setMinimumSize(labelSize);
        jlbDisplay.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(jlbDisplay);
        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(jlbFlattenText);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnSelectFlattenSchema.setAlignmentX(LEFT_ALIGNMENT);
        jbnSelectFlattenSchema.setMinimumSize(selectButtonSize);
        jbnSelectFlattenSchema.setPreferredSize(selectButtonSize);
        jplPanel.add(jbnSelectFlattenSchema);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnFlattenDestination.setAlignmentX(LEFT_ALIGNMENT);
        jbnFlattenDestination.setMinimumSize(selectButtonSize);
        jbnFlattenDestination.setPreferredSize(selectButtonSize);


        JPanel flattenLogPanel = new JPanel(new FlowLayout(FlowLayout.LEFT,0,0));
        flattenLogPanel.setAlignmentX(LEFT_ALIGNMENT);
        flattenLogPanel.setBackground(myGold);
        flattenLogPanel.add(jbnFlattenDestination);


        JPanel flattenCLSPanel = new JPanel(new FlowLayout(FlowLayout.LEFT,0,0));
        flattenCLSPanel.setAlignmentX(LEFT_ALIGNMENT);
        flattenCLSPanel.setBackground(myGold);
        JLabel jlbCLS = new JLabel("<html>&nbsp;&nbsp;(&nbsp;<a href='#'>Clear log</a>&nbsp;)</html>");
        jlbCLS.setFont(new Font("arial", Font.PLAIN ,10));
        jlbCLS.setAlignmentX(RIGHT_ALIGNMENT);
        // jplPanel.add(jlbCLS);

        jlbCLS.addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                jtaFlattenLog.setText("");
            }
        });

        flattenLogPanel.add(jlbCLS);


//        jplPanel.add(jbnFlattenDestination);


        jplPanel.add(flattenLogPanel);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnFlatten.setMinimumSize(new Dimension(120, 40));
        jbnFlatten.setPreferredSize(new Dimension(120, 40));
        jplPanel.add(jbnFlatten);


        jsplFlattenLogScrollPanel.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(jsplFlattenLogScrollPanel, BorderLayout.CENTER);

        // jplPanel.add(jtaFlattenLog);


        return jplPanel;
    }


    /**
     * createWSDLFlattenerPanel creates a panel for use in the tabbed tool.
     * This panel is for the WSDL flattening function.
     * Ideally the 3 panels should be in an extended base method or a single method with parameters.
     * Since they were each added at different points in time, it wasn't originally designed that way.
     * Put that on a "to do" list. :)
     */
    private JPanel createWSDLFlattenerPanel() {

        JPanel jplPanel = new JPanel();

        jplPanel.setLayout(null);

        JLabel jlbDisplay = new JLabel("Flatten WSDLs");
        jlbDisplay.setFont(new Font("arial", Font.BOLD, 18));

        jbnFlattenWSDL = new JButton("   Flatten WSDL   ");
        jbnFlattenWSDL.addActionListener(this);
        jfcSelectFlattenWSDL = new JFileChooser(defaultPath);
        jbnSelectFlattenWSDL = new JButton("   Select WSDL to flatten...   ");
        jfcFlattenWSDLDestination = new JFileChooser(defaultPath);
        jfcFlattenWSDLDestination.setFileSelectionMode(
                JFileChooser.DIRECTORIES_ONLY);
        jfcFlattenWSDLDestination.setFileHidingEnabled(true);
        jfcFlattenWSDLDestination.setMultiSelectionEnabled(false);

        jbnFlattenWSDLDestination = new JButton(
                "   Select destination folder ...   ");
        jbnFlattenWSDLDestination.addActionListener(this);
        jbnSelectFlattenWSDL.addActionListener(this);
        jbnSelectFlattenWSDL.setBorder(BorderFactory.createRaisedBevelBorder());
        jbnFlattenWSDLDestination.setBorder(BorderFactory.createRaisedBevelBorder());
        jbnFlattenWSDL.setBorder(BorderFactory.createRaisedBevelBorder());
        jplPanel.setBorder(BorderFactory.createRaisedBevelBorder());

        JLabel jlbFlattenWSDLText = new JLabel(
                "Flattening WSDL refers to the process of merging all wsdl:include/xsd:include/xsd:import into a stand alone version.");
        jlbFlattenWSDLText.setFont(new Font("arial", Font.PLAIN, 12));

        JScrollPane jsplFlattenWSDLLogScrollPanel = new  JScrollPane(jtaFlattenWSDLLog,
                v, h);

        jplPanel.setLayout(new BoxLayout(jplPanel, BoxLayout.PAGE_AXIS));
        jplPanel.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.setBorder(BorderFactory.createEmptyBorder(0, 15, 10, 10));
        jplPanel.add(Box.createRigidArea(spacerSize));

        jlbDisplay.setPreferredSize(labelSize);
        jlbDisplay.setMinimumSize(labelSize);
        jlbDisplay.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(jlbDisplay);
        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(jlbFlattenWSDLText);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnSelectFlattenWSDL.setAlignmentX(LEFT_ALIGNMENT);
        jbnSelectFlattenWSDL.setMinimumSize(selectButtonSize);
        jbnSelectFlattenWSDL.setPreferredSize(selectButtonSize);
        jplPanel.add(jbnSelectFlattenWSDL);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnFlattenWSDLDestination.setAlignmentX(LEFT_ALIGNMENT);
        jbnFlattenWSDLDestination.setMinimumSize(selectButtonSize);
        jbnFlattenWSDLDestination.setPreferredSize(selectButtonSize);


        JPanel flattenWSDLLogPanel = new JPanel(new FlowLayout(FlowLayout.LEFT,0,0));
        flattenWSDLLogPanel.setAlignmentX(LEFT_ALIGNMENT);
        flattenWSDLLogPanel.setBackground(Color.CYAN);
        flattenWSDLLogPanel.add(jbnFlattenWSDLDestination);


        JPanel flattenWSDLCLSPanel = new JPanel(new FlowLayout(FlowLayout.LEFT,0,0));
        flattenWSDLCLSPanel.setAlignmentX(LEFT_ALIGNMENT);
        flattenWSDLCLSPanel.setBackground(myGold);
        JLabel jlbWSDLCLS = new JLabel("<html>&nbsp;&nbsp;(&nbsp;<a href='#'>Clear log</a>&nbsp;)</html>");
        jlbWSDLCLS.setFont(new Font("arial", Font.PLAIN ,10));
        jlbWSDLCLS.setAlignmentX(RIGHT_ALIGNMENT);


        jlbWSDLCLS.addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                jtaFlattenWSDLLog.setText("");
            }
        });

        flattenWSDLLogPanel.add(jlbWSDLCLS);


//        jplPanel.add(jbnFlattenDestination);


        jplPanel.add(flattenWSDLLogPanel);



        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnFlattenWSDL.setMinimumSize(new Dimension(120, 40));
        jbnFlattenWSDL.setPreferredSize(new Dimension(120, 40));
        jplPanel.add(jbnFlattenWSDL);


        jsplFlattenWSDLLogScrollPanel.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(Box.createRigidArea(spacerSize));
        jplPanel.add(jsplFlattenWSDLLogScrollPanel, BorderLayout.CENTER);

        // jplPanel.add(jtaFlattenLog);


        return jplPanel;
    }


    /**
     * createLightenerPanel creates a panel for use in the tabbed tool.
     * This panel is for the xml schema lightening function.
     * Ideally the 3 panels should be in an extended base method or a single method with parameters.
     * Since they were each added at different points in time, it wasn't originally designed that way.
     * Put that on a "to do" list. :)
     */
    private JPanel createLightenerPanel() {

        JPanel jplPanel = new JPanel();

        jplPanel.setLayout(null);
        JLabel jlbDisplay = new JLabel("Lighten Schemas");

        jlbDisplay.setFont(new Font("arial", Font.BOLD, 18));

        // log = new JTextArea(500,100);

        jbnLighten = new JButton("   Lighten schema   ");

        jbnLighten.addActionListener(this);

        jfcSelectLightenSchema = new JFileChooser(defaultPath);
        jbnSelectLightenSchema = new JButton("   Select schema to lighten...   ");

        jfcSelectLightenInstance = new JFileChooser(defaultPath);
        jbnSelectLightenInstance = new JButton("   Select xml instance...   ");

        jfcLightenDestination = new JFileChooser(defaultPath);

        jfcLightenDestination.setFileSelectionMode(
                JFileChooser.DIRECTORIES_ONLY);
        jfcLightenDestination.setFileHidingEnabled(true);
        jfcLightenDestination.setMultiSelectionEnabled(false);

        jbnLightenDestination = new JButton(
                "   Select destination folder ...   ");

        jbnLightenDestination.setBorder(BorderFactory.createRaisedBevelBorder());
        jbnLightenDestination.addActionListener(this);

        jbnSelectLightenSchema.addActionListener(this);
        jbnSelectLightenInstance.addActionListener(this);

        jbnSelectLightenSchema.setBorder(BorderFactory.createRaisedBevelBorder());
        jbnSelectLightenInstance.setBorder(
                BorderFactory.createRaisedBevelBorder());

        jbnLighten.setBorder(BorderFactory.createRaisedBevelBorder());
        jplPanel.setBorder(BorderFactory.createRaisedBevelBorder());

        JLabel jLabel2 = new JLabel("Login2");
        JScrollPane jsplLogScrollPanel = new  JScrollPane();

        jsplLogScrollPanel.add(jLabel2);

        JLabel jlbLightenText = new JLabel(
                "Lightening schemas refers to the process of removing unused global elements and types.");

        jlbLightenText.setFont(new Font("arial", Font.PLAIN, 12));

        JScrollPane jsplLightenLogScrollPanel = new  JScrollPane(jtaLightenLog,
                v, h);

        jplPanel.setLayout(new BoxLayout(jplPanel, BoxLayout.PAGE_AXIS));


        jplPanel.setBorder(BorderFactory.createEmptyBorder(0, 15, 10, 10));

        jplPanel.add(Box.createRigidArea(spacerSize));

        jlbDisplay.setPreferredSize(labelSize);
        jlbDisplay.setMinimumSize(labelSize);
        jlbDisplay.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(jlbDisplay);
        jplPanel.add(jlbLightenText);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnSelectLightenSchema.setAlignmentX(LEFT_ALIGNMENT);
        jbnSelectLightenSchema.setMinimumSize(selectButtonSize);
        jbnSelectLightenSchema.setPreferredSize(selectButtonSize);
        jplPanel.add(jbnSelectLightenSchema);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnSelectLightenInstance.setMinimumSize(selectButtonSize);
        jbnSelectLightenInstance.setPreferredSize(selectButtonSize);
        jbnSelectLightenInstance.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(jbnSelectLightenInstance);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnLightenDestination.setAlignmentX(LEFT_ALIGNMENT);
        jbnLightenDestination.setMinimumSize(selectButtonSize);
        jbnLightenDestination.setPreferredSize(selectButtonSize);
        jplPanel.add(jbnLightenDestination);



        JPanel lightenLogPanel = new JPanel(new FlowLayout(FlowLayout.LEFT,0,0));
        lightenLogPanel.setAlignmentX(LEFT_ALIGNMENT);
        lightenLogPanel.setBackground(Color.GREEN);
        lightenLogPanel.add(jbnLightenDestination);



        JPanel lightenCLSPanel = new JPanel(new FlowLayout(FlowLayout.LEFT,0,0));
        lightenCLSPanel.setAlignmentX(LEFT_ALIGNMENT);
        lightenCLSPanel.setBackground(myGold);
        JLabel jlbLightenCLS = new JLabel("<html>&nbsp;&nbsp;(&nbsp;<a href='#'>Clear log</a>&nbsp;)</html>");
        jlbLightenCLS.setFont(new Font("arial", Font.PLAIN ,10));
        jlbLightenCLS.setAlignmentX(RIGHT_ALIGNMENT);

        jlbLightenCLS.addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                jtaLightenLog.setText("");
            }
        });

        lightenLogPanel.add(jlbLightenCLS);

        jplPanel.add(lightenLogPanel);


        jplPanel.add(Box.createRigidArea(spacerSize));
        jbnLighten.setMinimumSize(selectButtonSize);
        jbnLighten.setPreferredSize(selectButtonSize);
        jbnLighten.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(jbnLighten);

        jplPanel.add(Box.createRigidArea(spacerSize));
        jsplLightenLogScrollPanel.setAlignmentX(LEFT_ALIGNMENT);
        jplPanel.add(jsplLightenLogScrollPanel);

        // jplPanel.add(jtaLightenLog);

        return jplPanel;
    }


    /**
     * main
     *
     */
    public static void main(final String[] args) {
        JFrame frame = new JFrame("Xml Schema Lightener: making schemas simpler");

        frame.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                System.exit(0);
            }
        });
        final JPanel spacerE = new JPanel(new BorderLayout());
        final JPanel spacerS = new JPanel(new BorderLayout());
        final JPanel spacerW = new JPanel(new BorderLayout());
        final JPanel spacerN = new JPanel(new BorderLayout());

        spacerE.add(new JLabel("     "), BorderLayout.EAST);
        frame.getContentPane().add(spacerE, BorderLayout.EAST);
        spacerS.add(new JLabel("     "), BorderLayout.SOUTH);
        frame.getContentPane().add(spacerS, BorderLayout.SOUTH);
        spacerW.add(new JLabel("     "), BorderLayout.WEST);
        frame.getContentPane().add(spacerW, BorderLayout.WEST);
        spacerN.add(new JLabel("     "), BorderLayout.NORTH);
        frame.getContentPane().add(spacerN, BorderLayout.NORTH);

        frame.getContentPane().add(new SchemaLightener(), BorderLayout.CENTER);
        frame.setSize(800, 600);
        frame.setVisible(true);

    }


    /**
     * actionPerformed handles user input events
     * <p>
     * Results will be posted to the panel log.
     *
     * @param  e event
     *
     * to do : migrate from if/elseif list to multiple listeners
     * */
    public void actionPerformed(ActionEvent e) {
        if (e.getSource() == jbnSelectFlattenSchema) {
            //
            //
            // Handle jbnSelectFlattenSchema action.
            //
            //
            int returnVal = jfcSelectFlattenSchema.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = jfcSelectFlattenSchema.getSelectedFile();

                stringFlattenSchemaPath = file.getAbsolutePath();
                stringFlattenSchemaPath = stringFlattenSchemaPath.replaceAll("\\\\",
                        "/");

                jtaFlattenLog.append(
                        "Selected schema: " + newline + stringFlattenSchemaPath
                                + "." + newline + hr);

            } else {
                jtaFlattenLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringFlattenSchemaPath = "";
            }
            jtaFlattenLog.setCaretPosition(
                    jtaFlattenLog.getDocument().getLength());
            // end if (e.getSource() == jbnSelectFlattenSchema)
        } else if (e.getSource() == jbnFlattenDestination) {
            //
            //
            // Handle jbnFlattenDestination action.
            //
            //
            //
            int returnVal = jfcFlattenDestination.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {

                File file2 = jfcFlattenDestination.getSelectedFile();

                stringFlattenDestinationPath = file2.getAbsolutePath();
                stringFlattenDestinationPath = "file:///"
                        + stringFlattenDestinationPath.replaceAll("\\\\", "/")
                        + "/";

                jtaFlattenLog.append(
                        "Selected destination: " + newline
                                + stringFlattenDestinationPath + "." + newline + hr);

            } else {
                jtaFlattenLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringFlattenDestinationPath = "";
            }
            jtaFlattenLog.setCaretPosition(
                    jtaFlattenLog.getDocument().getLength());
            // end if (e.getSource() == jbnFlattenDestination)
        } else if (e.getSource() == jbnFlatten) {
            //
            //
            // Handle jbnFlatten action.
            //
            //
            //
            // set the TransformFactory to use the Saxon TransformerFactoryImpl method
            jtaFlattenLog.append("Processing ..." + newline);

            String xml = stringFlattenSchemaPath; // input xml
            // xml = xml.replaceAll("\\\\", "/");

            String dest = stringFlattenDestinationPath;
            // dest = xml.replaceAll("\\\\", "/");


            if (stringFlattenSchemaPath.equals("")) {
                // File or directory does not exist
                jtaFlattenLog.append("Source schema not selected.  Choose one and try again." + newline + hr);
            } else {
                // File or directory does exist
                if (stringFlattenDestinationPath.equals("")) {
                    // File or directory does not exist
                    jtaFlattenLog.append("Destination folder not selected.  Choose one and try again." + newline + hr);
                } else {
                    // File or directory does exist
                    // attempt the transformation
                    try {
                        flattenTransformer(xml, dest);
                    } catch (Exception ex) {
                        jtaFlattenLog.append("EXCEPTION: " + ex + newline + hr);
                        //handleException(ex);
                    } // end try

                }  // end second if exists
            } // end first if exists

            // end if (e.getSource() == jbnFlatten)
        } else if (e.getSource() == jbnSelectLightenSchema) {
            //
            //
            // Handle jbnSelectLightenSchema action.
            //
            //
            //
            int returnVal = jfcSelectLightenSchema.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = jfcSelectLightenSchema.getSelectedFile();

                stringLightenSchemaPath = file.getAbsolutePath();
                stringLightenSchemaPath = stringLightenSchemaPath.replaceAll("\\\\",
                        "/");

                jtaLightenLog.append(
                        "Selected schema: " + newline + stringLightenSchemaPath
                                + "." + newline + hr);
            } else {
                jtaLightenLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringLightenSchemaPath = "";
            }
            jtaLightenLog.setCaretPosition(
                    jtaLightenLog.getDocument().getLength());
            // end if (e.getSource() == jbnSelectFlattenSchema)
        } else if (e.getSource() == jbnSelectLightenInstance) {
            //
            //
            // Handle jbnSelectLightenInstance action.
            //
            //
            //
            int returnVal = jfcSelectLightenInstance.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = jfcSelectLightenInstance.getSelectedFile();

                stringLightenInstancePath = file.getAbsolutePath();
                stringLightenInstancePath = stringLightenInstancePath.replaceAll(
                        "\\\\", "/");

                jtaLightenLog.append(
                        "Selected instance: " + newline
                                + stringLightenInstancePath + "." + newline + hr);
            } else {
                jtaLightenLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringLightenInstancePath = "";
            }
            jtaLightenLog.setCaretPosition(
                    jtaLightenLog.getDocument().getLength());
            // end if (e.getSource() == jbnSelectLightenInstance)

        } else if (e.getSource() == jbnLightenDestination) {
            //
            //
            // Handle jbnLightenDestination action.
            //
            //
            //
            int returnVal = jfcLightenDestination.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {

                File file2 = jfcLightenDestination.getSelectedFile();

                stringLightenDestinationPath = file2.getAbsolutePath();
                stringLightenDestinationPath = "file:///"
                        + stringLightenDestinationPath.replaceAll("\\\\", "/")
                        + "/";

                // This is where a real application would open the file.
                jtaLightenLog.append(
                        "Selected destination: " + newline
                                + stringLightenDestinationPath + "." + newline + hr);
            } else {
                jtaLightenLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringLightenDestinationPath = "";
            }
            jtaLightenLog.setCaretPosition(
                    jtaLightenLog.getDocument().getLength());
            // end if (e.getSource() == jbnLightenDestination)

        } else if (e.getSource() == jbnLighten) {
            //
            //
            // Handle jbnLighten action.
            //
            //
            //
            // set the TransformFactory to use the Saxon TransformerFactoryImpl method
            jtaLightenLog.append("Processing ..." + newline);

            String xml = stringLightenSchemaPath; // input xml

            String dest = stringLightenDestinationPath;
            String instanceFileName = stringLightenInstancePath; // input xml


            if (stringLightenSchemaPath.equals("")) {
                // File or directory does not exist
                jtaLightenLog.append("Source schema not selected.  Choose one and try again." + newline + hr);
            } else {
                // File or directory does exist
                if (stringLightenInstancePath.equals("")) {
                    // File or directory does not exist
                    jtaLightenLog.append("Xml instance file not selected.  Choose one and try again." + newline + hr);
                } else {
                    // File or directory does exist
                    if (stringLightenDestinationPath.equals("")) {
                        // File or directory does not exist
                        jtaLightenLog.append("Destination folder not selected.  Choose one and try again." + newline + hr);
                    } else {
                        // File or directory does exist
                        // attempt the transformation
                        try {
                            lightenTransformer(xml, dest, instanceFileName);
                        } catch (Exception ex) {
                            jtaLightenLog.append("EXCEPTION: " + ex + newline + hr);
                            //handleException(ex);
                        } // end try

                    }  // end third if exists

                }  // end second if exists
            } // end first if exists

            //       }// end if (e.getSource() == jbnLighten)

        } else if (e.getSource() == jbnSelectFlattenWSDL) {
            //
            //
            // Handle jbnSelectFlattenWSDL action.
            //
            //
            int returnVal = jfcSelectFlattenWSDL.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {
                File file = jfcSelectFlattenWSDL.getSelectedFile();

                stringFlattenWSDLPath = file.getAbsolutePath();
                stringFlattenWSDLPath = stringFlattenWSDLPath.replaceAll("\\\\",
                        "/");

                // This is where a real application would open the file.
                jtaFlattenWSDLLog.append(
                        "Selected WSDL: " + newline + stringFlattenWSDLPath
                                + "." + newline + hr);

            } else {
                jtaFlattenWSDLLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringFlattenWSDLPath = "";
            }
            jtaFlattenWSDLLog.setCaretPosition(
                    jtaFlattenWSDLLog.getDocument().getLength());
            // end if (e.getSource() == jbnSelectFlattenWSDL)
        } else if (e.getSource() == jbnFlattenWSDLDestination) {
            //
            //
            // Handle jbnFlattenWSDLDestination action.
            //
            //
            //
            int returnVal = jfcFlattenWSDLDestination.showOpenDialog(
                    SchemaLightener.this);

            if (returnVal == JFileChooser.APPROVE_OPTION) {

                File file2 = jfcFlattenWSDLDestination.getSelectedFile();

                stringFlattenWSDLDestinationPath = file2.getAbsolutePath();
                stringFlattenWSDLDestinationPath = "file:///"
                        + stringFlattenWSDLDestinationPath.replaceAll("\\\\", "/")
                        + "/";

                // This is where a real application would open the file.
                jtaFlattenWSDLLog.append(
                        "Selected destination: " + newline
                                + stringFlattenWSDLDestinationPath + "." + newline + hr);

            } else {
                jtaFlattenWSDLLog.append(
                        "Select command cancelled by user." + newline + hr);
                stringFlattenWSDLDestinationPath = "";
            }
            jtaFlattenWSDLLog.setCaretPosition(
                    jtaFlattenWSDLLog.getDocument().getLength());
            // end if (e.getSource() == jbnFlattenDestination)
        } else if (e.getSource() == jbnFlattenWSDL) {
            //
            //
            // Handle jbnFlattenWSDL action.
            //
            //
            //
            // set the TransformFactory to use the Saxon TransformerFactoryImpl method
            jtaFlattenWSDLLog.append("Processing ..." + newline);

            String xml = stringFlattenWSDLPath; // input xml
            // xml = xml.replaceAll("\\\\", "/");

            String dest = stringFlattenWSDLDestinationPath;
            // dest = xml.replaceAll("\\\\", "/");


            if (stringFlattenWSDLPath.equals("")) {
                // File or directory does not exist
                jtaFlattenWSDLLog.append("Source WSDL not selected.  Choose one and try again." + newline + hr);
            } else {
                // File or directory does exist
                if (stringFlattenWSDLDestinationPath.equals("")) {
                    // File or directory does not exist
                    jtaFlattenWSDLLog.append("Destination folder not selected.  Choose one and try again." + newline + hr);
                } else {
                    // File or directory does exist
                    // attempt the transformation
                    try {
                        flattenWSDLTransformer(xml, dest);
                    } catch (Exception ex) {
                        jtaFlattenWSDLLog.append("EXCEPTION: " + ex + newline + hr);
                        //handleException(ex);
                    } // end try

                }  // end second if exists
            } // end first if exists

            // end if (e.getSource() == jbnFlatten)
        }



    } // end actionPerformed


    /**
     * setLookAndFeel sets look and feel for entire app
     * */
    private void setLookAndFeel() {
        try {
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

            UIManager.put("TabbedPane.font", tabFont);
            UIManager.put("Button.font", buttonFont);

            SwingUtilities.updateComponentTreeUI(this);
        } catch (Exception e) {
            System.err.println("Could not use Look and Feel:" + e);
        }
    }
    
} // end class

