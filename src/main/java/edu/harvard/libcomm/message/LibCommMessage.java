//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v2.2.4-2 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2014.09.12 at 03:13:26 PM EDT 
//


package edu.harvard.libcomm.message;

import java.util.ArrayList;
import java.util.List;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;


/**
 * <p>Java class for anonymous complex type.
 * 
 * <p>The following schema fragment specifies the expected content contained within this class.
 * 
 * <pre>
 * &lt;complexType>
 *   &lt;complexContent>
 *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *       &lt;sequence>
 *         &lt;element name="command">
 *           &lt;simpleType>
 *             &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *               &lt;enumeration value="INGEST"/>
 *               &lt;enumeration value="NORMALIZE"/>
 *               &lt;enumeration value="ENRICH"/>
 *               &lt;enumeration value="PUBLISH"/>
 *               &lt;enumeration value="DELETE"/>
 *               &lt;enumeration value="REPLAY"/>
 *               &lt;enumeration value="LOG"/>
 *             &lt;/restriction>
 *           &lt;/simpleType>
 *         &lt;/element>
 *         &lt;element name="payload">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="source" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                   &lt;element name="format" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                   &lt;element name="filepath" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
 *                   &lt;element name="data" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="watchers">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="watcher" maxOccurs="unbounded">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="notification">
 *                               &lt;simpleType>
 *                                 &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
 *                                   &lt;enumeration value="trace"/>
 *                                   &lt;enumeration value="success"/>
 *                                   &lt;enumeration value="error"/>
 *                                   &lt;enumeration value="warn"/>
 *                                 &lt;/restriction>
 *                               &lt;/simpleType>
 *                             &lt;/element>
 *                           &lt;/sequence>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *         &lt;element name="initiator" type="{http://www.w3.org/2001/XMLSchema}anyType"/>
 *         &lt;element name="history">
 *           &lt;complexType>
 *             &lt;complexContent>
 *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                 &lt;sequence>
 *                   &lt;element name="event" maxOccurs="unbounded">
 *                     &lt;complexType>
 *                       &lt;complexContent>
 *                         &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
 *                           &lt;sequence>
 *                             &lt;element name="messagetype" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="messageid" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="sendingservice" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                             &lt;element name="time" type="{http://www.w3.org/2001/XMLSchema}string"/>
 *                           &lt;/sequence>
 *                         &lt;/restriction>
 *                       &lt;/complexContent>
 *                     &lt;/complexType>
 *                   &lt;/element>
 *                 &lt;/sequence>
 *               &lt;/restriction>
 *             &lt;/complexContent>
 *           &lt;/complexType>
 *         &lt;/element>
 *       &lt;/sequence>
 *     &lt;/restriction>
 *   &lt;/complexContent>
 * &lt;/complexType>
 * </pre>
 * 
 * 
 */
@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name = "", propOrder = {
    "command",
    "payload",
    "watchers",
    "initiator",
    "history"
})
@XmlRootElement(name = "lib_comm_message")
public class LibCommMessage {

    @XmlElement(required = true)
    protected String command;
    @XmlElement(required = true)
    protected LibCommMessage.Payload payload;
    @XmlElement(required = true)
    protected LibCommMessage.Watchers watchers;
    @XmlElement(required = true)
    protected Object initiator;
    @XmlElement(required = true)
    protected LibCommMessage.History history;

    /**
     * Gets the value of the command property.
     *
     * @return
     *     possible object is
     *     {@link String }
     *
     */
    public String getCommand() {
        return command;
    }

    /**
     * Sets the value of the command property.
     *
     * @param value
     *     allowed object is
     *     {@link String }
     *
     */
    public void setCommand(String value) {
        this.command = value;
    }

    /**
     * Gets the value of the payload property.
     * 
     * @return
     *     possible object is
     *     {@link LibCommMessage.Payload }
     *     
     */
    public LibCommMessage.Payload getPayload() {
        return payload;
    }

    /**
     * Sets the value of the payload property.
     * 
     * @param value
     *     allowed object is
     *     {@link LibCommMessage.Payload }
     *     
     */
    public void setPayload(LibCommMessage.Payload value) {
        this.payload = value;
    }

    /**
     * Gets the value of the watchers property.
     * 
     * @return
     *     possible object is
     *     {@link LibCommMessage.Watchers }
     *     
     */
    public LibCommMessage.Watchers getWatchers() {
        return watchers;
    }

    /**
     * Sets the value of the watchers property.
     * 
     * @param value
     *     allowed object is
     *     {@link LibCommMessage.Watchers }
     *     
     */
    public void setWatchers(LibCommMessage.Watchers value) {
        this.watchers = value;
    }

    /**
     * Gets the value of the initiator property.
     * 
     * @return
     *     possible object is
     *     {@link Object }
     *     
     */
    public Object getInitiator() {
        return initiator;
    }

    /**
     * Sets the value of the initiator property.
     * 
     * @param value
     *     allowed object is
     *     {@link Object }
     *     
     */
    public void setInitiator(Object value) {
        this.initiator = value;
    }

    /**
     * Gets the value of the history property.
     * 
     * @return
     *     possible object is
     *     {@link LibCommMessage.History }
     *     
     */
    public LibCommMessage.History getHistory() {
        return history;
    }

    /**
     * Sets the value of the history property.
     * 
     * @param value
     *     allowed object is
     *     {@link LibCommMessage.History }
     *     
     */
    public void setHistory(LibCommMessage.History value) {
        this.history = value;
    }


    /**
     * <p>Java class for anonymous complex type.
     * 
     * <p>The following schema fragment specifies the expected content contained within this class.
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;sequence>
     *         &lt;element name="event" maxOccurs="unbounded">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="messagetype" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="messageid" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="sendingservice" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="time" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                 &lt;/sequence>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *       &lt;/sequence>
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "event"
    })
    public static class History {

        @XmlElement(required = true)
        protected List<LibCommMessage.History.Event> event;

        /**
         * Gets the value of the event property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the event property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getEvent().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link LibCommMessage.History.Event }
         * 
         * 
         */
        public List<LibCommMessage.History.Event> getEvent() {
            if (event == null) {
                event = new ArrayList<LibCommMessage.History.Event>();
            }
            return this.event;
        }


        /**
         * <p>Java class for anonymous complex type.
         * 
         * <p>The following schema fragment specifies the expected content contained within this class.
         * 
         * <pre>
         * &lt;complexType>
         *   &lt;complexContent>
         *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
         *       &lt;sequence>
         *         &lt;element name="messagetype" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="messageid" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="sendingservice" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="time" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *       &lt;/sequence>
         *     &lt;/restriction>
         *   &lt;/complexContent>
         * &lt;/complexType>
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "messagetype",
            "messageid",
            "sendingservice",
            "time"
        })
        public static class Event {

            @XmlElement(required = true)
            protected String messagetype;
            @XmlElement(required = true)
            protected String messageid;
            @XmlElement(required = true)
            protected String sendingservice;
            @XmlElement(required = true)
            protected String time;

            /**
             * Gets the value of the messagetype property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMessagetype() {
                return messagetype;
            }

            /**
             * Sets the value of the messagetype property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMessagetype(String value) {
                this.messagetype = value;
            }

            /**
             * Gets the value of the messageid property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getMessageid() {
                return messageid;
            }

            /**
             * Sets the value of the messageid property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setMessageid(String value) {
                this.messageid = value;
            }

            /**
             * Gets the value of the sendingservice property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getSendingservice() {
                return sendingservice;
            }

            /**
             * Sets the value of the sendingservice property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setSendingservice(String value) {
                this.sendingservice = value;
            }

            /**
             * Gets the value of the time property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getTime() {
                return time;
            }

            /**
             * Sets the value of the time property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setTime(String value) {
                this.time = value;
            }

        }

    }


    /**
     * <p>Java class for anonymous complex type.
     * 
     * <p>The following schema fragment specifies the expected content contained within this class.
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;sequence>
     *         &lt;element name="source" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *         &lt;element name="format" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *         &lt;element name="filepath" type="{http://www.w3.org/2001/XMLSchema}string" minOccurs="0"/>
     *         &lt;element name="data" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *       &lt;/sequence>
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "source",
        "format",
        "filepath",
        "data"
    })
    public static class Payload {

        @XmlElement(required = true)
        protected String source;
        @XmlElement(required = true)
        protected String format;
        protected String filepath;
        @XmlElement(required = true)
        protected String data;

        /**
         * Gets the value of the source property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getSource() {
            return source;
        }

        /**
         * Sets the value of the source property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setSource(String value) {
            this.source = value;
        }

        /**
         * Gets the value of the format property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getFormat() {
            return format;
        }

        /**
         * Sets the value of the format property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setFormat(String value) {
            this.format = value;
        }

        /**
         * Gets the value of the filepath property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getFilepath() {
            return filepath;
        }

        /**
         * Sets the value of the filepath property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setFilepath(String value) {
            this.filepath = value;
        }

        /**
         * Gets the value of the data property.
         * 
         * @return
         *     possible object is
         *     {@link String }
         *     
         */
        public String getData() {
            return data;
        }

        /**
         * Sets the value of the data property.
         * 
         * @param value
         *     allowed object is
         *     {@link String }
         *     
         */
        public void setData(String value) {
            this.data = value;
        }

    }


    /**
     * <p>Java class for anonymous complex type.
     * 
     * <p>The following schema fragment specifies the expected content contained within this class.
     * 
     * <pre>
     * &lt;complexType>
     *   &lt;complexContent>
     *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *       &lt;sequence>
     *         &lt;element name="watcher" maxOccurs="unbounded">
     *           &lt;complexType>
     *             &lt;complexContent>
     *               &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
     *                 &lt;sequence>
     *                   &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}string"/>
     *                   &lt;element name="notification">
     *                     &lt;simpleType>
     *                       &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
     *                         &lt;enumeration value="trace"/>
     *                         &lt;enumeration value="success"/>
     *                         &lt;enumeration value="error"/>
     *                         &lt;enumeration value="warn"/>
     *                       &lt;/restriction>
     *                     &lt;/simpleType>
     *                   &lt;/element>
     *                 &lt;/sequence>
     *               &lt;/restriction>
     *             &lt;/complexContent>
     *           &lt;/complexType>
     *         &lt;/element>
     *       &lt;/sequence>
     *     &lt;/restriction>
     *   &lt;/complexContent>
     * &lt;/complexType>
     * </pre>
     * 
     * 
     */
    @XmlAccessorType(XmlAccessType.FIELD)
    @XmlType(name = "", propOrder = {
        "watcher"
    })
    public static class Watchers {

        @XmlElement(required = true)
        protected List<LibCommMessage.Watchers.Watcher> watcher;

        /**
         * Gets the value of the watcher property.
         * 
         * <p>
         * This accessor method returns a reference to the live list,
         * not a snapshot. Therefore any modification you make to the
         * returned list will be present inside the JAXB object.
         * This is why there is not a <CODE>set</CODE> method for the watcher property.
         * 
         * <p>
         * For example, to add a new item, do as follows:
         * <pre>
         *    getWatcher().add(newItem);
         * </pre>
         * 
         * 
         * <p>
         * Objects of the following type(s) are allowed in the list
         * {@link LibCommMessage.Watchers.Watcher }
         * 
         * 
         */
        public List<LibCommMessage.Watchers.Watcher> getWatcher() {
            if (watcher == null) {
                watcher = new ArrayList<LibCommMessage.Watchers.Watcher>();
            }
            return this.watcher;
        }


        /**
         * <p>Java class for anonymous complex type.
         * 
         * <p>The following schema fragment specifies the expected content contained within this class.
         * 
         * <pre>
         * &lt;complexType>
         *   &lt;complexContent>
         *     &lt;restriction base="{http://www.w3.org/2001/XMLSchema}anyType">
         *       &lt;sequence>
         *         &lt;element name="name" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="id" type="{http://www.w3.org/2001/XMLSchema}string"/>
         *         &lt;element name="notification">
         *           &lt;simpleType>
         *             &lt;restriction base="{http://www.w3.org/2001/XMLSchema}string">
         *               &lt;enumeration value="trace"/>
         *               &lt;enumeration value="success"/>
         *               &lt;enumeration value="error"/>
         *               &lt;enumeration value="warn"/>
         *             &lt;/restriction>
         *           &lt;/simpleType>
         *         &lt;/element>
         *       &lt;/sequence>
         *     &lt;/restriction>
         *   &lt;/complexContent>
         * &lt;/complexType>
         * </pre>
         * 
         * 
         */
        @XmlAccessorType(XmlAccessType.FIELD)
        @XmlType(name = "", propOrder = {
            "name",
            "id",
            "notification"
        })
        public static class Watcher {

            @XmlElement(required = true)
            protected String name;
            @XmlElement(required = true)
            protected String id;
            @XmlElement(required = true)
            protected String notification;

            /**
             * Gets the value of the name property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getName() {
                return name;
            }

            /**
             * Sets the value of the name property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setName(String value) {
                this.name = value;
            }

            /**
             * Gets the value of the id property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getId() {
                return id;
            }

            /**
             * Sets the value of the id property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setId(String value) {
                this.id = value;
            }

            /**
             * Gets the value of the notification property.
             * 
             * @return
             *     possible object is
             *     {@link String }
             *     
             */
            public String getNotification() {
                return notification;
            }

            /**
             * Sets the value of the notification property.
             * 
             * @param value
             *     allowed object is
             *     {@link String }
             *     
             */
            public void setNotification(String value) {
                this.notification = value;
            }

        }

    }

}
