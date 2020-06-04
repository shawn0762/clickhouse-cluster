## 说明

#### 配置

###### 集群配置

- 集群包含3个分片,每个分片有两个副本,副本间的数据一致性由zookeeper保证

- 每个分片大概存放了集群数据的1/3,可以通过配置文件配置权重

- 同一分片的两个副本数据完全一致,其中一个挂了也不影响集群的运行

- 集群配置文件: `conf/cluster-config.xml`

###### 副本配置

- 共有副本数量:`3分片 * 2副本`,每个实例运行一个副本

- 副本配置文件: `conf/s01-r01.xml`,每个副本的配置不一样

###### 数据库初始化配置

分布式数据库需要在每一个节点(副本)创建表,

内置了一个测试数据库初始化脚本:`conf/init-db.sql`

## Usage

```shell

docker-compose up -d

```

#### select

```shell
## clickhouse-client in container

use ck_test_db;

## 只查询当前副本中该表的数据
select * from table_name;

## 查询集群三个分片中该表的所有数据
select * from table_name_all;

```

#### insert

- 直接在某个分片的某个副本插入数据

zk会自动将数据同步到同分片的另一个副本

```shell script
## clickhouse-client in container

use ck_test_db;

insert into table_name values ('2020-06-04 14:14:34', 123, 456)

```

- 或者在任意一个节点(副本)操作分布式表

分布式表会选择一个分片,并将数据插入其中一个副本,另一个副本的数据由zk保证一致性

```shell script
## clickhouse-client in any container

use ck_test_db;

insert into table_name_all values ('2020-06-04 14:14:34', 123, 456)

```