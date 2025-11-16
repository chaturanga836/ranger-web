FROM eclipse-temurin:8-jdk

ENV RANGER_HOME=/opt/ranger \
    JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /opt/ranger

# Install required system packages
RUN apt-get update && \
    apt-get install -y \
        python3 python3-pip \
        postgresql-client \
        curl unzip procps && \
    pip3 install --break-system-packages psycopg2-binary && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# ------------------------------------------------------------
# Copy Ranger Admin build (from your local folder)
# ------------------------------------------------------------
COPY conf/ /opt/ranger/conf/
COPY cred/ /opt/ranger/cred/
COPY ews/ /opt/ranger/ews/
COPY lib/ /opt/ranger/lib/

COPY lib/postgresql-42.7.8.jar /opt/ranger/ews/webapp/WEB-INF/lib/

# Create logs directory
RUN mkdir -p /opt/ranger/ews/logs

# Expose Ranger Admin port
EXPOSE 6080

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
