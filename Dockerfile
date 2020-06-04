FROM yandex/clickhouse-server:20.4
RUN apt-get update && apt-get install curl
RUN cp ./conf/cluster-config.xml /etc/clickhouse-server/config.d/cluster-config.xml \
    cp ./conf/init-db.sql /docker-entrypoint-initdb.d/init-db.sql
