# Use an official OpenJDK runtime as a parent image
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the jar file into the container at /app
COPY target/your-app-1.0-SNAPSHOT.jar /app/your-app.jar

# Run the jar file
ENTRYPOINT ["java", "-jar", "/app/your-app.jar"]

# Expose the application on port 8081
EXPOSE 8081
