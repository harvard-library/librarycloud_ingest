package edu.harvard.libcomm.pipeline.enrich;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URL;
import java.util.Date;
import java.nio.file.Files;
import java.nio.file.FileSystem;
import java.nio.file.Path;
import java.nio.file.Paths;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;


import org.apache.commons.io.IOUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.json.*;

import javax.xml.namespace.NamespaceContext;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;

import edu.harvard.libcomm.message.LibCommMessage;
import edu.harvard.libcomm.message.LibCommMessage.Payload;
import edu.harvard.libcomm.pipeline.Config;
import edu.harvard.libcomm.pipeline.IProcessor;
import edu.harvard.libcomm.pipeline.MessageUtils;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.Disabled;

import edu.harvard.libcomm.pipeline.MessageUtils;
import edu.harvard.libcomm.test.TestHelpers;
import edu.harvard.libcomm.test.TestMessageUtils;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
class PublishProcessorTests {
    PublishProcessor p;

    @BeforeAll
    void setup() {
        p = new PublishProcessor();
    }

    @Test
    void expandRepositoryCodes() throws Exception {

        LibCommMessage lcm = TestHelpers.buildLibCommMessage("mods", "publish-processor-tests-sample-1.xml");

        p.processMessage(lcm);
        Document doc = TestHelpers.extractXmlDoc(lcm);

        String repositoryTextChanged = TestHelpers.getXPath("//mods:location[1]/mods:physicalLocation[@type = 'repository']", doc);
        String displayLabelAdded = TestHelpers.getXPath("//mods:location[1]/mods:physicalLocation[@type = 'repository']/@displayLabel", doc);
        String extensionValue = TestHelpers.getXPath("//hvd:HarvardRepositories/hvd:HarvardRepository/text()", doc);
        String valueURI = TestHelpers.getXPath("//mods:location[1]/mods:physicalLocation[@type = 'repository']/@valueURI", doc);

        assertEquals("African and African American Studies Reading Room, Harvard University", repositoryTextChanged);
        assertEquals("Harvard repository", displayLabelAdded);
        assertEquals("Afro-American Studies", extensionValue);
        assertEquals("http://id.loc.gov/rwo/agents/no2018062623", valueURI);

        String repositoryTextUnchanged = TestHelpers.getXPath("//mods:location[2]/mods:physicalLocation[@type = 'repository']", doc);
        assertEquals("xxx", repositoryTextUnchanged);
    }

    @Test
    void mapContentModelToDigitalFormat() throws Exception {
        LibCommMessage lcm = TestHelpers.buildLibCommMessage("mods", "publish-processor-tests-sample-1.xml");

        p.processMessage(lcm);
        Document doc = TestHelpers.extractXmlDoc(lcm);

        String digitalFormat = TestHelpers.getXPath("//digitalFormats:digitalFormat[1]", doc);

        assertEquals("Books and documents", digitalFormat);
    }

    @Test
    void normalizeAccessFlagToAvailableTo() throws Exception {
        LibCommMessage lcm = TestHelpers.buildLibCommMessage("mods", "publish-processor-tests-sample-1.xml");

        p.processMessage(lcm);
        Document doc = TestHelpers.extractXmlDoc(lcm);

        String available1 = TestHelpers.getXPath("//mods:mods[1]/mods:extension/avail:availableTo", doc);
        String available2 = TestHelpers.getXPath("//mods:mods[2]/mods:extension/avail:availableTo", doc);

        assertEquals("Restricted", available1);
        assertEquals("Everyone", available2);
    }

    //LTSCLOUD-618
    @Test
    void libraryCloudProcessingDate() throws Exception {
        LibCommMessage lcm = TestHelpers.buildLibCommMessage("mods", "publish-processor-tests-sample-1.xml");
        Date before = new Date();

        p.processMessage(lcm);
        System.out.println(lcm.getPayload().getData());
        Document doc = TestHelpers.extractXmlDoc(lcm);

        Date after = new Date();

        String processingDateString = TestHelpers.getXPath("//mods:mods[1]/mods:extension/procdate:processingDate", doc);

        TimeZone tz = TimeZone.getTimeZone("UTC");
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm'Z'");
        df.setTimeZone(tz);
        Date processingDate = df.parse(processingDateString);

        //run the before and after dates through to lose the seconds
        assertTrue(processingDate.compareTo(df.parse(df.format(before))) >= 0);
        assertTrue(processingDate.compareTo(df.parse(df.format(after))) <= 0);
    }
}
