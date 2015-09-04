package edu.harvard.libcomm.pipeline.marc;

import java.io.ByteArrayOutputStream;
import java.io.UnsupportedEncodingException;
import java.util.Iterator;
import java.util.NoSuchElementException;

import javax.xml.bind.JAXBException;

import org.marc4j.MarcReader;
import org.marc4j.MarcXmlWriter;
import org.marc4j.marc.Record;

import edu.harvard.libcomm.message.LibCommMessage;
import edu.harvard.libcomm.message.LibCommMessage.Payload;
import edu.harvard.libcomm.pipeline.MessageUtils;

/**
 * Iterate over the MarcReader provided, generating LibraryCloud
 * messages which contain the MarcXML in a payload. Multiple
 * Marc records are included in a single message. Once the size of the 
 * payload goes above chunkSize, start a new message.
 */
public class MarcFileIterator implements Iterator<String> {

    private MarcReader marcReader;

    private long chunkSize;
    public MarcFileIterator(MarcReader marcReader, long chunkSize) {
        this.marcReader = marcReader;
        this.chunkSize = chunkSize;
    }

    @Override
    public boolean hasNext() {                
        return marcReader.hasNext();
    }

    @Override
    public String next() {
        ByteArrayOutputStream output = new ByteArrayOutputStream();
        MarcXmlWriter writer = new MarcXmlWriter(output, true);
        int count = 0;
        boolean newChunk = false;
        int totalSize = 0;
        while (marcReader.hasNext() && newChunk == false) {
            try {
                Record record = marcReader.next();
                writer.setIndent(false);
                writer.write(record);
                count++;           
                totalSize += output.toString().length();
                newChunk = totalSize > this.chunkSize ? true:false;
                totalSize = 0;
            } catch (org.marc4j.MarcException ex) {
                ex.printStackTrace();
            }
        }   
        if (count > 0) {
        	writer.close();
            LibCommMessage message = new LibCommMessage();
            message.setCommand("NORMALIZE");
            Payload payload = new Payload();
            payload.setSource("aleph");
            payload.setFormat("mods");
			try {
				String data = filterContent(output.toString("UTF-8"));
				payload.setData(data);
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}

            message.setPayload(payload);
            try {
				return MessageUtils.marshalMessage(message);
			} catch (JAXBException e) {
				e.printStackTrace();
				return null;
			}
        } else {
            throw new NoSuchElementException();
        }
    }

    @Override
    public void remove() {
        throw new UnsupportedOperationException();
    }
    
    private String filterContent(String content) {
    	content = content.replace("<collection>", "<collection " + "xmlns=\"http://www.loc.gov/MARC21/slim\"" + ">");
    	content = content.replace("&#x2;","");
    	content = content.replace("&#x1f;","");
        return content.replaceAll("[^\\u0009\\u000a\\u000d\\u0020-\\uD7FF\\uE000-\\uFFFD]", "");
    }
}
