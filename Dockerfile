# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /your-app/your-app

# Copy the JAR file into the container at /your-app/your-app/target
COPY target/jenkins-sonar-1.0-SNAPSHOT.jar /your-app/your-app/target/your-app.jar

# Run the JAR file
ENTRYPOINT ["java", "-jar", "/your-app/your-app/target/your-app.jar"]

# Expose the application port (adjust the port if needed)
EXPOSE 8081
