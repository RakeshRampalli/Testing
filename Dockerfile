# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the built jar file from the target directory in the project
COPY target/app-1.0-SNAPSHOT.jar /app/app.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/app.jar"]

# Expose the application port
EXPOSE 8081
