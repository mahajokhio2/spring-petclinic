FROM openjdk:11-jre-slim

# Install curl
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# Install New Relic agent
RUN curl -L https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip -o /tmp/newrelic-java.zip && \
    unzip /tmp/newrelic-java.zip -d /opt && \
    rm /tmp/newrelic-java.zip

# Copy the Spring PetClinic application JAR file
COPY target/*.jar /app/spring-petclinic.jar

# Set the Java options to include the New Relic agent
ENV JAVA_OPTS="-javaagent:/opt/newrelic/newrelic.jar"

# Set the entrypoint
ENTRYPOINT ["java", "-jar", "/app/spring-petclinic.jar"]


