FROM mcr.microsoft.com/mssql/server
MAINTAINER Shane Genschaw

VOLUME /docker-entrypoint-initdb.d
EXPOSE 1433

ENV PATH $PATH:/opt/mssql-tools/bin

# Copy the docker-entrypoint.sh script to the container
COPY docker-entrypoint.sh /usr/local/bin/

# Copy the docker-entrypoint-initdb.sh script to the container
COPY docker-entrypoint-initdb.sh /usr/local/bin/

# Set the entrypoint to the custom docker-entrypoint.sh script
ENTRYPOINT ["docker-entrypoint.sh"]

