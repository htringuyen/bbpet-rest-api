FROM tomcat:latest
RUN mkdir /home/project
ENV PROJ_HOME=/home/project

EXPOSE 8080

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Copy the run.sh file to the container's /home directory
COPY entrypoint.sh /home/entrypoint.sh

# Set the ENTRYPOINT to run the run.sh script
ENTRYPOINT ["/home/entrypoint.sh"]
