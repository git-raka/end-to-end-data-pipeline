curl -H 'Content-Type: application/json' 192.168.18.132:8083/connectors --data '
{
  "name": "neo4jv5",
  "config": {
        "topics": "postgres.public.customers,postgres.public.orders,postgres.public.shippers",
        "connector.class": "streams.kafka.connect.sink.Neo4jSinkConnector",
        "key.converter": "org.apache.kafka.connect.storage.StringConverter",
        "value.converter": "org.apache.kafka.connect.json.JsonConverter",
        "errors.retry.timeout": "-1",
        "errors.retry.delay.max.ms": "1000",
        "errors.tolerance": "all",
        "errors.log.enable": true,
        "errors.log.include.messages": true,
        "neo4j.server.uri": "bolt://192.168.18.135:7687",
        "neo4j.authentication.basic.username": "neo4j",
        "neo4j.authentication.basic.password": "neo4j123",
        "neo4j.batch.parallelize": "false",
        "neo4j.database": "neo4jv5",
        "neo4j.encryption.enabled": "false",
	"value.converter.schemas.enable":"false",
	"neo4j.topic.cypher.postgres.public.customers": "WITH event CALL { WITH event WITH event WHERE event.op IN [\"c\",\"u\",\"r\"] WITH event[\"after\"] AS cust MERGE (c:Customer {CustomerID:toInteger(cust.customerid)}) ON CREATE SET c.CustomerName = cust.customername,c.ContactName = cust.contactname,c.Address = cust.address,c.City = cust.city,c.PostalCode = cust.postalcode,c.Country = cust.country ON MATCH SET c.CustomerName = cust.customername,c.ContactName = cust.contactname,c.Address = cust.address,c.City = cust.city,c.PostalCode = cust.postalcode,c.Country = cust.country UNION WITH event WITH event WHERE event.op IN [\"d\"] WITH event[\"before\"] AS cust MATCH (c1:Customers {CustomerID:cust.customerid}) WITH c1 OPTIONAL MATCH (c1)-[:PLACED_ORDER]->(o) DETACH DELETE c1, o }",
	"neo4j.topic.cypher.postgres.public.shippers": "WITH event CALL { WITH event WITH event   WHERE event.op IN [\"c\",\"u\",\"r\"]   WITH event[\"after\"] AS cust  MERGE (b:Shipper {Shipperid:toInteger(cust.shipperid)}) ON CREATE SET b.shippername = cust.shippername, b.phone = cust.phone  ON MATCH SET b.shippername = cust.shippername, b.phone = cust.phone UNION WITH event WITH event   WHERE event.op IN [\"d\"] WITH event[\"before\"]  AS cust   MATCH (b1:Shipper {Shipperid:toInteger(cust.shipperid)}) WITH b1 OPTIONAL MATCH (b1)-[:HAS_SEND]->(o) DETACH DELETE b1, o}",
	"neo4j.topic.cypher.postgres.public.orders": "WITH event CALL {  WITH event WITH event  WHERE event.op IN [\"c\",\"u\",\"r\"]  WITH event[\"after\"] AS cust MERGE (b:Shipper {Shipperid:toInteger(cust.shipperid)}) MERGE (c:Customer {CustomerID:toInteger(cust.customerid)}) MERGE (o:Orders {OrderID:toInteger(cust.orderid)})  ON CREATE SET o.customerid = cust.customerid, o.employeeid = cust.employeeid, o.OrderDate = cust.orderDate, o.Shipperid = cust.shipperid ON MATCH SET o.customerid = cust.customerid, o.employeeid = cust.employeeid, o.OrderDate = cust.orderDate, o.Shipperid = cust.shipperid MERGE (c)-[:PLACED_ORDER]->(o) MERGE (b)-[:HAS_SEND]->(o) UNION WITH event WITH event  WHERE event.op IN [\"d\"] WITH event[\"before\"]  AS cust  MATCH (o:Orders {OrderID:toInteger(cust.orderid)}) DETACH DELETE o }"
  }
}'
