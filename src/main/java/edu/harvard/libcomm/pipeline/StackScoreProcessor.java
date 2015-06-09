package edu.harvard.libcomm.pipeline;

import java.io.IOException;
import java.net.URI;
import java.util.Date;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.json.JSONTokener;
import org.json.XML;

import edu.harvard.libcomm.message.LibCommMessage;
import edu.harvard.libcomm.message.LibCommMessage.Payload;

public class StackScoreProcessor implements IProcessor {
	protected Logger log = Logger.getLogger(StackScoreProcessor.class); 	
	
	public void processMessage(LibCommMessage libCommMessage) throws Exception {	
	
		String data = null;
		String recids = "0";
		
		try {
			recids = MessageUtils.transformPayloadData(libCommMessage,"src/main/resources/recids.xsl",null);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}

		URI uri = new URI(Config.getInstance().ITEM_URL + "?filter=collection:hollis_catalog&filter=id_inst:(" + recids + ")&fields=shelfrank,id_inst&limit=250");
		JSONTokener tokener;
		try {
			tokener = new JSONTokener(uri.toURL().openStream());
		} catch (IOException e) {
			e.printStackTrace();
			throw e;
		}
		
		JSONObject stackscoreJson = new JSONObject(tokener);
		String stackscoreXml = XML.toString(stackscoreJson);
		stackscoreXml = "<stackscore>" + stackscoreXml + "</stackscore>";
		log.trace("StackScoreProcessor result:" + stackscoreXml);
		
		try {
			data = MessageUtils.transformPayloadData(libCommMessage,"src/main/resources/addstackscore.xsl",stackscoreXml);
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		}
		
		Payload payload = new Payload();
		payload.setData(data);
        libCommMessage.setPayload(payload);
        
	}

}