FROM tomcat:latest
RUN mkdir /home/project
ENV PROJ_HOME=/home/project

EXPOSE 8080

RUN apt-get update && apt-get install -y unzip && rm -rf /var/lib/apt/lists/*

# Copy the run.sh file to the container's /home directory
COPY run.sh /home/

# (Optional) Set the executable permission for the run.sh file
RUN chmod +x /home/run.sh

# Set the ENTRYPOINT to run the run.sh script
ENTRYPOINT ["/home/run.sh"]
