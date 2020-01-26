
+++
title = "Simple, Scalable, and Responsive Data Retrieval with ElasticSearch"
date = "2019-05-24"
author = "Jason Beach"
categories = ["DataStore", "Category"]
tags = ["elasticsearch", "tag2"]
+++


Distributed systems are very popular tools in the 'big data' market space and ElasticSearch evolved to become one of the major players.  It serves the niche role of scaling to store large amounts of data, then allows querying it quickly.  It evolved greatly over the last ten years to provide a variety of functionality.  While it serves its primary purpose well, teams should resist the urge to use it in other roles, such as advanced analytics.

## Tool Characteristics

### Strengths

ElasticSearch is a Java, Lucene-based, tool that queries large, unstructured data very quickly.  It can be deployed using docker and offers just a simple http endpoint for interaction.

In the realm of 'big data' it provides much the expected functionality.  Because is distributed it has great ability to scale horizontally.  The data is also replicated, automatically, in case of server node failure.

ElasticSearch can execute complex queries very quickly.  This is because it indexes all data.  Part of its speed is that it caches many of the queries used as a filter, so it only executes them once.  This is performed with support for all commonly-used data types, such as Text (structured and unstructured, Numbers (long, integer, short, byte, double, float), Dates, as well as complex types such as: arrays, objects, nested types, geo-spatial, iPV4 and others.

Additional functionality is provided through a variety of plugins. This supports scenarios for great security and analysis.

### Weaknesses

Despite these strengths, Elasticsearch has drawbacks that are quite similar to other 'big data' tools.  Particularly, it is great with data search and recovery, but not for creating and modifying data.  MongoDb is still popular for unstructured transactional data.  

ElasticSearch is a type of data warehousing paradigm, not a database replacement.  Specifically, the Elastic company, with its many related products, really grew in size when it was applied to logging and log search problems.  The last decade saw a growing demand for analysts to be able to search the large amounts of metadata created by machines.

Elastic attempted to make in-roads as an analytics and data science platform.  This is a dangerous road for teams to go down.  While it can retrieve data, specifically in time-series scenarios, ElasticSearch is an unstructured-only tool.  

Data science demands structure in the final stages of modeling.  The balance of working with structured and unstructured data is handled very well by Apache Spark's RDD's and DataFrames.  ElasticSearch has no such complimentary models.  The most sophisticated role it can handel is the analyst answering basic business questions. 

Another difficulty is the major breakages that occur between versions.  For a fast-moving team, keeping up-to-date with the latest ElasticSearch can be a big obstacle.

## Installation

ElasticSearch can be quickly deployed on a single node using docker.  One requirement is the vm.max_map_count kernel setting needs to be set to at least 262144 for production use. 

```python
#get the container running
docker run -d -p 9200:9200 -p 9300:9300 -e "discovery.type=single-node" --name cntr_elastic docker.elastic.co/elasticsearch/elasticsearch:7.0.1

#enter container to check-out configs            
docker exec -it --user root cntr_elastic bash
```

The configuration is loaded from files under `/usr/share/elasticsearch/config/`.

Some configurations that may need changing in `elasticsearch.yml`:

* `cluster.name: "docker-cluster"`
* `path.logs: /path/to/logs`
* `discovery.zen.ping.unicast.hosts: ["localhost"]`

To install directly on MacOS it is simple enough.  Afterward, make appropriate updates to `~/.bash_profile`.

```python
brew install elasticsearch
```

Check that node es01 listens on localhost:9200 while es02 talks to es01 over a Docker network.

__NOTE__: because we are running these curl command from within docker, and they must reach the host's ip address, then when must use `host.docker.internal` for the ip address (since the host is a MacOS).  Read more about your host's ip address by referencing this [stackoverflow post](https://stackoverflow.com/questions/22944631/how-to-get-the-ip-address-of-the-docker-host-from-inside-a-docker-container).

```python
! curl http://host.docker.internal:9200/_cat/health
```

{{< output >}}
```nb-output
1559051160 13:46:00 docker-cluster green 1 1 0 0 0 0 0 0 - 100.0%
```
{{< /output >}}

## Operation

### Typical command syntax

All commands follow similar pattern:

`<HTTP Verb> /<Index>/<Endpoint>/<ID>`

### Explore cluster

Get health of the cluster:

* Green - everything is good (cluster is fully functional)
* Yellow - all data is available but some replicas are not yet allocated (cluster is fully functional)
* Red - some data is not available for whatever reason (cluster is partially functional) 

```python
! curl -X GET "host.docker.internal:9200/_cat/health?v"
```

{{< output >}}
```nb-output
epoch      timestamp cluster        status node.total node.data shards pri relo init unassign pending_tasks max_task_wait_time active_shards_percent
1559051178 13:46:18  docker-cluster green           1         1      0   0    0    0        0             0                  -                100.0%
```
{{< /output >}}

List the available nodes

```python
! curl -X GET "host.docker.internal:9200/_cat/nodes?v"
```

{{< output >}}
```nb-output
ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.17.0.3           31          31  16    0.33    0.25     0.14 mdi       *      fa57091880ec
```
{{< /output >}}

List indices being used

```python
! curl -X GET "host.docker.internal:9200/_cat/indices?v"
```

{{< output >}}
```nb-output
health status index uuid pri rep docs.count docs.deleted store.size pri.store.size
```
{{< /output >}}

Create a new index: `customer`, and use pretty-print in json.

There is now one index named customer and it has one primary shard and one replica (the defaults) and it contains zero documents in it

```python
! curl -X PUT "host.docker.internal:9200/customer?pretty"
```

{{< output >}}
```nb-output
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "customer"
}
```
{{< /output >}}

Add(Index) one `document`, with `id` of 1

specific `id` provided

```python
! curl -X PUT "host.docker.internal:9200/customer/_doc/1?pretty" -H 'Content-Type: application/json' -d'{"name": "John Doe"}'
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```
{{< /output >}}

no `id` specified

```python
! curl -X POST "host.docker.internal:9200/customer/_doc?pretty" -H 'Content-Type: application/json' -d'{"name": "Jane Doe"}'
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "K4Sy_moBhQilF9iEcwe-",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 1,
  "_primary_term" : 1
}
```
{{< /output >}}

Query the index

```python
! curl -X GET "host.docker.internal:9200/customer/_doc/1?pretty"
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "name" : "John Doe"
  }
}
```
{{< /output >}}

Delete the index

```python
! curl -X DELETE "host.docker.internal:9200/customer?pretty"
```

{{< output >}}
```nb-output
{
  "acknowledged" : true
}
```
{{< /output >}}

### Modify data

Add(Index) one `document`, with `id` of 1

specific `id` provided

```python
! curl -X PUT "host.docker.internal:9200/customer/_doc/1?pretty" -H 'Content-Type: application/json' -d'{"name": "John Doe"}'
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 1,
  "result" : "created",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 0,
  "_primary_term" : 1
}
```
{{< /output >}}

Update document

Change the name and provide a new field

```python
! curl -X POST "host.docker.internal:9200/customer/_update/1?pretty" -H 'Content-Type: application/json' -d '{"doc": { "name": "Jane Doe", "age": 20  }}'
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 2,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 1,
  "_primary_term" : 1
}
```
{{< /output >}}

Increment with script

```python
! curl -X POST "host.docker.internal:9200/customer/_update/1?pretty" -H 'Content-Type: application/json' -d'{"script" : "ctx._source.age += 5"}'
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "1",
  "_version" : 3,
  "result" : "updated",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 2,
  "_primary_term" : 1
}
```
{{< /output >}}

Delete the document

```python
! curl -X DELETE "host.docker.internal:9200/customer/_doc/2?pretty"
```

{{< output >}}
```nb-output
{
  "_index" : "customer",
  "_type" : "_doc",
  "_id" : "2",
  "_version" : 1,
  "result" : "not_found",
  "_shards" : {
    "total" : 2,
    "successful" : 1,
    "failed" : 0
  },
  "_seq_no" : 3,
  "_primary_term" : 1
}
```
{{< /output >}}

Run a Batch process

* update the first doc, delete the second
* if a single action fails, it will continue to process others
* may get an error `[\\n]`, different for each operating system

```python
! curl -X POST "host.docker.internal:9200/customer/_bulk?pretty" -H 'Content-Type: application/json' -d'\
{"index":{"_id":"1"}}\
{"name": "John Doe" }\
{"index":{"_id":"2"}}'
```

### Explore data

Bulk load json, load data file: accounts.json

```python
! curl -H "Content-Type: application/json" -XPOST "host.docker.internal:9200/bank/_bulk?pretty&refresh" --data-binary "@./Data/ElasticSearch/accounts.json";
```

Query: uri

```python
! curl -X GET "host.docker.internal:9200/bank/_search?q=*&sort=account_number:asc&pretty"
```

Query: body

  	+ more typical and expressive search
  	+ _source is used to select fields
  	+ from is 0-based, defaults to 0 
  	+ size defaults to 10

```python
! curl -X GET "host.docker.internal:9200/bank/_search" -H 'Content-Type: application/json' -d'\
{"query": { "match_all": {} },\
  "_source": ["account_number", "balance"],\
  "sort": [{ "account_number": "asc" }],\
  "from": 10,\
  "size": 1\
}'
```

{{< output >}}
```nb-output
{"took":11,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":1000,"relation":"eq"},"max_score":null,"hits":[{"_index":"bank","_type":"_doc","_id":"10","_score":null,"_source":{"account_number":10,"balance":46170},"sort":[10]}]}}
```
{{< /output >}}

Query: where clause

* `bool must` clause specifies AND, all the queries that must be true
* `bool should` clause for OR
* `bool "must_not"` clause for NONE

```python
! curl -X GET "host.docker.internal:9200/bank/_search" -H 'Content-Type: application/json' -d'\
{"query": {"bool": {"must": \
	[{ "match": { "address": "mill" } },\
	 { "match": { "address": "lane" } }\
    ]\
}}}'
```

{{< output >}}
```nb-output
{"took":25,"timed_out":false,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0},"hits":{"total":{"value":1,"relation":"eq"},"max_score":9.507477,"hits":[{"_index":"bank","_type":"_doc","_id":"136","_score":9.507477,"_source":{"account_number":136,"balance":45801,"firstname":"Winnie","lastname":"Holland","age":38,"gender":"M","address":"198 Mill Lane","employer":"Neteria","email":"winnieholland@neteria.com","city":"Urie","state":"IL"}}]}}
```
{{< /output >}}

Query: filter clause

* get a range of values
* bool query contains a match_all query (the query part) and a range query (the filter part)

```python
! curl -X GET "host.docker.internal:9200/bank/_search" -H 'Content-Type: application/json' -d'\
{"query": {"bool": {"must": { "match_all": {} },\
      "filter": {"range": {\
          "balance": {"gte": 20000, "lte": 30000}\
          }}\
}}}'
```

For more specific queries using [Aggregations](https://www.elastic.co/guide/en/elasticsearch/reference/current/getting-started-aggregations.html) check the docs.

## Conclusion

ElasticSearch is a powerful tool for a very specific use case of fast data querying.  However, do not attempt over-extend its functional uses. 

## References

* [docker configurations](https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html)
* [gettings started guide](https://www.elastic.co/guide/en/elasticsearch/reference/current/index.html)
