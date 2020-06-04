CREATE DATABASE IF NOT EXISTS ck_test_db;

/* 复制表使用zookeeper进行副本间的数据同步 */
CREATE TABLE IF NOT EXISTS ck_test_db.table_name
(
    EventDate DateTime,
    CounterID UInt32,
    UserID UInt32
) ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/table_name', '{replica}')
PARTITION BY toYYYYMM(EventDate)
ORDER BY (CounterID, EventDate, intHash32(UserID))
SAMPLE BY intHash32(UserID);

/* 创建分布式表,分布式表不存储数据,仅用于通过此表操作对于的实体表:即上述的table_name */
CREATE TABLE IF NOT EXISTS ck_test_db.table_name_all AS ck_test_db.table_name
ENGINE = Distributed(perftest_3shards_2replicas, 'ck_test_db', 'table_name', rand());
