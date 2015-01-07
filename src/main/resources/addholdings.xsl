<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:context="http://www.springframework.org/schema/context"
    xsi:schemaLocation="
    http://www.springframework.org/schema/beans
    http://www.springframework.org/schema/beans/spring-beans.xsd
    http://camel.apache.org/schema/spring
    http://camel.apache.org/schema/spring/camel-spring.xsd
    http://www.springframework.org/schema/context
    http://www.springframework.org/schema/context/spring-context-3.0.xsd"
    >
    <!-- AWS Configuration -->
    <context:property-placeholder location="classpath:/aws.properties" />
    <bean name="sqsClient" class="com.amazonaws.services.sqs.AmazonSQSAsyncClient">
        <constructor-arg>
            <bean class="com.amazonaws.auth.BasicAWSCredentials">
                <constructor-arg value="${access.key}"/>
                <constructor-arg value="${secret.key}"/>
            </bean>
        </constructor-arg>
    </bean>
    <!-- Set a shorter timeout for shutdown, primarily for testing purposes. Default is 300. -->
    <bean id="shutdown" class="org.apache.camel.impl.DefaultShutdownStrategy">
        <property name="timeout" value="30"/>
    </bean>
    <!-- Configure display of trace log messages -->
    <bean id="traceFormatter" class="org.apache.camel.processor.interceptor.DefaultTraceFormatter">
        <property name="showBody" value="false"/>
        <property name="showHeaders" value="false"/>
    </bean>
    <!-- Add an event notifier to log throughput -->
    <!-- <bean id="eventTimer" class="edu.harvard.libcomm.pipeline.EventTimer"/> -->
    <!-- Definition of beans that handle processing of items in the pipeline -->
    <bean id="marcSplitter" class="edu.harvard.libcomm.pipeline.Splitter">
        <property name="splitter">
            <bean class="edu.harvard.libcomm.pipeline.MarcSplitter"/>
        </property>
    </bean>	
    
    <bean id="deleteSplitter" class="edu.harvard.libcomm.pipeline.Splitter">
        <property name="splitter">
            <bean class="edu.harvard.libcomm.pipeline.DeleteFileSplitter"/>
        </property>
    </bean>	
    
    <bean id="eadSplitter" class="edu.harvard.libcomm.pipeline.Splitter">
        <property name="splitter">
            <bean class="edu.harvard.libcomm.pipeline.EADSplitter"/>
        </property>
    </bean>
    <bean id="eadRawSplitter" class="edu.harvard.libcomm.pipeline.RawSplitter">
        <property name="splitter">
            <bean class="edu.harvard.libcomm.pipeline.EADRawSplitter"/>
        </property>
    </bean>
    <bean id="viaSplitter" class="edu.harvard.libcomm.pipeline.Splitter">
        <property name="splitter">
            <bean class="edu.harvard.libcomm.pipeline.VIASplitter"/>
        </property>
    </bean>
    <bean id="viaRawSplitter" class="edu.harvard.libcomm.pipeline.RawSplitter">
        <property name="splitter">
            <bean class="edu.harvard.libcomm.pipeline.VIARawSplitter"/>
        </property>
    </bean>
    
    <bean id="modsAggregator" class="edu.harvard.libcomm.pipeline.MODSAggregatorStrategy"/>
    
    <bean id="modsEADRawAggregator" class="edu.harvard.libcomm.pipeline.MODSRawAggregatorStrategy">
        <property name="source" value="OASIS"/>
    </bean>
    
    <bean id="modsVIARawAggregator" class="edu.harvard.libcomm.pipeline.MODSRawAggregatorStrategy">
        <property name="source" value="VIA"/>
    </bean>
    
    <bean id="modsProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.ModsProcessor"/>
        </property>
    </bean>
    <bean id="filterUnchangedProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.FilterUnchangedProcessor"/>
        </property>
    </bean>
    <bean id="holdingsProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.HoldingsProcessor"/>
        </property>
    </bean>
    <bean id="stackscoreProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.StackScoreProcessor"/>
        </property>
    </bean>
    <bean id="lccProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.LCCProcessor"/>
        </property>
    </bean>
    <!-- 
    <bean id="collectionsProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.CollectionsProcessor"/>
        </property>
    </bean>
    <bean id="collectionUpdateProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.CollectionUpdateProcessor"/>
        </property>
    </bean>-->
    <bean id="removeRestrictedProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.PublishProcessor"/>
        </property>
    </bean>
    <bean id="solrLoadProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.SolrProcessor">
                <property name="commitWithinTime" value="30000"/>
            </bean>
        </property>
    </bean>
    <bean id="solrLoadProcessorImmediate" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.SolrProcessor"/>
        </property>
    </bean>
    <bean id="solrDeleteProcessor" class="edu.harvard.libcomm.pipeline.LibCommProcessor">
        <property name="processor">
            <bean class="edu.harvard.libcomm.pipeline.SolrDeleteProcessor"/>
        </property>
    </bean>
    
    <camelContext id="sqsContext" xmlns="http://camel.apache.org/schema/spring" trace="true">
        <!-- Environment-specific properties -->
        <propertyPlaceholder id="librarycloud-properties" location="classpath:/librarycloud.env.properties" />
        <!-- Error handling behavior -->
        <errorHandler id="eh" redeliveryPolicyRef="myPolicy" type="DeadLetterChannel"
            deadLetterUri="direct:dead-letter"/>
        <redeliveryPolicyProfile id="myPolicy" maximumRedeliveries="0"/>
        <route id="dead-letter">
            <from uri="direct:dead-letter"/>
            <to uri="file://{{librarycloud.files.basepath}}/ERROR"/>
            <!-- Post to the AWS dead letter queue, and handle errors (e.g. file size exceeded) -->
            
        </route>

        <!-- Aleph ingest and normalization -->
        <route id="aleph-ingest-split" errorHandlerRef="eh">
            <from uri="file:{{librarycloud.files.basepath}}/ingest-aleph?include=.*.xml" />
            <!-- <from uri="aws-sqs://{{librarycloud.sqs.environment}}-ingest-aleph?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient&amp;visibilityTimeout=1800" /> -->
            <!-- Try block required for errors thrown out of the splitter -->
            <doTry>
                <split streaming="true" parallelProcessing="true">
                    <method bean="marcSplitter" method="split"/>
                    <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-normalize-marcxml?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient" /> -->
                    <to uri="file://{{librarycloud.files.basepath}}/normalize-marcxml?fileName=${header.CamelSplitIndex}" />
                </split>
                <doCatch>
                    <exception>java.lang.Exception</exception>
                    <to uri="direct:dead-letter" />
                </doCatch>
            </doTry>
        </route>
        
        <route id="marctomods" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}/normalize-marcxml" />
            <process ref="modsProcessor"/>
            <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-start?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient" /> -->
            <to uri="file://{{librarycloud.files.basepath}}/enrich-start" />
        </route>

        
        <!-- VIA ingest and normalization -->
        <!--  Read from raw VIA export files dropped on disk.
              We want to change this to a model whereby the command is read from SQS with a reference
              to the raw VIA file in S3, which camel will download; rather than forcing us to drop the
              raw VIA file on a specific server.   -->
        <route id="via-ingest-raw-file" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}/ingest-via-file" />
            <doTry>
                <split streaming="true">
                    <tokenize token="viaRecord" xml="true"/>          
                    <setHeader headerName="outerSplitIndex">
                        <simple>${header.CamelSplitIndex}</simple>
                    </setHeader>
                    
                    <split streaming="true" parallelProcessing="true">
                        <method bean="viaRawSplitter" method="split"/>
                        <aggregate strategyRef="modsVIARawAggregator" completionSize="100" completionInterval="10000">
                            <correlationExpression>
                                <simple>all</simple>
                            </correlationExpression>
                            <completionPredicate>
                                <simple>${header.messageLength} > 150000</simple>
                            </completionPredicate>  
                            <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-start?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient" /> -->
                            <to uri="file://{{librarycloud.files.basepath}}/enrich-start?fileName=${header.outerSplitIndex}-${header.CamelSplitIndex}" />
                        </aggregate>
                    </split>
                </split>
                <doCatch>
                    <exception>java.lang.Exception</exception>
                    <to uri="direct:dead-letter" />
                </doCatch>
            </doTry>
        </route>
        
        <!-- Route messages to the correct part of the enrich pipeline -->
        <route id="enrich-start" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}//enrich-start" />
            <!-- <from uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-start?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient&amp;maxMessagesPerPoll=10" /> -->
            <choice>
                <when>
                    <xpath>//source = 'aleph'</xpath>
                    <to uri="seda:enrich-01?size=20&amp;blockWhenFull=true" />
                </when>
                <when>
                    <xpath>//source = 'ALEPH'</xpath>
                    <to uri="seda:enrich-01?size=20&amp;blockWhenFull=true" />
                </when>
                <otherwise>
                    <!-- Skip Holdings, Stackscore, and LCCSH steps for non-aleph records -->
                    <to uri="file://{{librarycloud.files.basepath}}/enrich-end" />
                </otherwise>
            </choice>
        </route>
        
        <route id="addholdingstomods-seda" errorHandlerRef="eh">
            <from uri="direct:enrich-01"/>
            <to uri="seda:enrich-01?size=20&amp;blockWhenFull=true" />
        </route>
        <route id="addholdingstomods" errorHandlerRef="eh">
            <from uri="seda:enrich-01?concurrentConsumers=1"/>
            <process ref="holdingsProcessor"/>
            <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-02?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient" /> -->
            <to uri="file://{{librarycloud.files.basepath}}/enrich-02" />
        </route>
        
        <route id="addstackscoretomods-seda" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}//enrich-02" />
            <!-- <from uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-02?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient&amp;maxMessagesPerPoll=10" /> -->
            <to uri="seda:enrich-02?size=20&amp;blockWhenFull=true" />
        </route>
        <route id="addstackscoretomods" errorHandlerRef="eh">
            <from uri="seda:enrich-02?concurrentConsumers=1"/>
            <process ref="stackscoreProcessor"/>
            <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-03?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient" /> -->
            <to uri="file://{{librarycloud.files.basepath}}/enrich-03" />
        </route>
        
        <route id="addslcctomods-seda" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}/enrich-03" />
            <to uri="seda:enrich-03?size=20&amp;blockWhenFull=true" />
        </route>
        <route id="addslcctomods" errorHandlerRef="eh">
            <from uri="seda:enrich-03?concurrentConsumers=1"/>
            <process ref="lccProcessor"/>
            <to uri="file://{{librarycloud.files.basepath}}/enrich-04" />
        </route> 
        
		<route id="addcollectionstomods" errorHandlerRef="eh">
			<from uri="file://{{librarycloud.files.basepath}}/enrich-04"/>
			<to uri="file://{{librarycloud.files.basepath}}/enrich-end" />
		</route>
        
        <!-- Publishing records to consumers -->
        <route id="publish-seda" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}/enrich-end" />
            <!-- <from uri="aws-sqs://{{librarycloud.sqs.environment}}-enrich-end?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient&amp;maxMessagesPerPoll=10" /> -->
            <to uri="seda:enrich-end?size=20&amp;blockWhenFull=true"/>
        </route>
        <route id="publish" errorHandlerRef="eh">
            <from uri="seda:enrich-end?concurrentConsumers=1" />
            <process ref="removeRestrictedProcessor"/>
            
            <!-- Commenting out unchanged filter until we are set to deploy the associated database -->
            <!-- <process ref="filterUnchangedProcessor"/> -->
            
            <!-- Don't try to publish empty messages -->
            <choice>
                <when>
                    <xpath>string-length(/lib_comm_message/payload/data) = 0</xpath>
                    <to uri="file://{{librarycloud.files.basepath}}/empty-message" />
                </when>
                <otherwise>
                    <to uri="file://{{librarycloud.files.basepath}}/publish-public" />
                    <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-publish-public?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient" /> -->
                </otherwise>
            </choice>
        </route>
        
        
        <!-- SOLR consumer for loading into item API -->
        <route id="modstosolr-seda" errorHandlerRef="eh">
            <from uri="file://{{librarycloud.files.basepath}}/publish-public" />
            <!--<from uri="aws-sqs://{{librarycloud.sqs.environment}}-publish-public?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient&amp;maxMessagesPerPoll=10" /> -->
            <to uri="seda:publish-public?size=20&amp;blockWhenFull=true"/>
        </route>
        <route id="modstosolr" errorHandlerRef="eh">
            <from uri="seda:publish-public?concurrentConsumers=1" />
            <process ref="solrLoadProcessor"/>
            <to uri="log:edu.harvard.libcomm.throughput?level=TRACE&amp;marker=solrLoadProcessor&amp;groupSize=10"/>
            <!-- <to uri="aws-sqs://{{librarycloud.sqs.environment}}-done?accessKey=${access.key}&amp;secretKey=${secret.key}&amp;amazonSQSClient=#sqsClient"/>-->
            <to uri="file://{{librarycloud.files.basepath}}/done" />
        </route>
        
        
    </camelContext>
</beans>