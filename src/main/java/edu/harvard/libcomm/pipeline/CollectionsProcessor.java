package edu.harvard.libcomm.pipeline;

import java.io.IOException;
import java.io.FileNotFoundException;
import java.net.URI;
import java.util.Date;

import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.json.XML;

import edu.harvard.libcomm.message.LibCommMessage;
import edu.harvard.libcomm.message.LibCommMessage.Payload;

public class CollectionsProcessor implements IProcessor {
	protected Logger log = Logger.getLogger(CollectionsProcessor.class); 	
	
	public void processMessage(LibCommMessage libCommMessage) throws Exception {	
	
		String data = null;
		String recids = "0";

		try {
			recids = MessageUtils.transformPayloadData(libCommMessage,"src/main/resources/recids-comma-separated.xsl",null);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

		URI uri = new URI(Config.getInstance().COLLECTIONS_URL + "/collections/items/" + recids + ".xml");
		String collectionsXml;
		try {
			Date start = new Date();
			collectionsXml = IOUtils.toString(uri.toURL().openStream(), "UTF-8");
			Date end = new Date();
			log.trace("CollectionsProcessor query time: " + (end.getTime() - start.getTime()));
			log.trace("CollectionsProcessor query : " +  uri.toURL());
		} catch (FileNotFoundException e) {
			// If none of the items are in a collection, we'll get a 404
			return;
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		}
		
		log.trace("CollectionsProcessor result:" + collectionsXml);
		
		try {
			data = MessageUtils.transformPayloadData(libCommMessage,"src/main/resources/addcollections.xsl",collectionsXml);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Payload payload = new Payload();
		payload.setData(data);
        libCommMessage.setPayload(payload);
        
	}
}
