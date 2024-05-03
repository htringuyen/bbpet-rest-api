#!/bin/bash

# Copy a file from the source directory to the destination directory
# cp $PROJ_HOME/db.properties $PROJ_HOME/src/main/resources/db

# Change to the directory containing the Gradle project
cd $PROJ_HOME

# Run a Gradle task
./gradlew war


#!/bin/bash

TOMCAT_WEBAPPS_DIR="/usr/local/tomcat/webapps"

# Find the WAR file in the build/libs directory
WAR_FILE=$(find "$PROJ_HOME/build/libs" -name "*.war" | head -n 1)

if [ -z "$WAR_FILE" ]; then
    echo "No WAR file found in $PROJ_HOME/build/libs"
    exit 1
fi

# Create a temporary directory to extract the WAR file
TEMP_DIR=$(mktemp -d)

# Extract the WAR file to the temporary directory
unzip -q "$WAR_FILE" -d "$TEMP_DIR"

# Remove the existing ROOT directory, if it exists
if [ -d "$TOMCAT_WEBAPPS_DIR/ROOT" ]; then
    rm -rf "$TOMCAT_WEBAPPS_DIR/ROOT"
fi


mkdir "$TOMCAT_WEBAPPS_DIR/ROOT"

# Move the remaining extracted contents to the ROOT directory
mv "$TEMP_DIR/WEB-INF" "$TOMCAT_WEBAPPS_DIR/ROOT"
mv "$TEMP_DIR/META-INF" "$TOMCAT_WEBAPPS_DIR/ROOT"
mv "$TEMP_DIR"/* "$TOMCAT_WEBAPPS_DIR/ROOT/"

# Remove the temporary directory
rm -rf "$TEMP_DIR"

catalina.sh run
