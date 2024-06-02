FROM openjdk:11-jre-slim

# Set environment variables for New Relic
ENV NEW_RELIC_APP_NAME="spring-petclinic"
ENV NEW_RELIC_LICENSE_KEY="YOUR_NEW_RELIC_LICENSE_KEY"
ENV NEW_RELIC_LOG="stdout"

# Download and install New Relic agent
RUN curl -L https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip -o /tmp/newrelic-java.zip && \
    unzip /tmp/newrelic-java.zip -d /opt && \
    rm /tmp/newrelic-java.zip

# Copy the Spring PetClinic application JAR file
COPY target/spring-petclinic-2.4.2.jar /app/spring-petclinic.jar

# Set the Java options to include the New Relic agent
ENV JAVA_OPTS="-javaagent:/opt/newrelic/newrelic.jar"

# Command to run the application
CMD ["java", "$JAVA_OPTS", "-jar", "/app/spring-petclinic.jar"]

