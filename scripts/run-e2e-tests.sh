#!/bin/bash
# Move to the Protractor test project folder
cd $HOME
# Install the necessary npm packages
ls
echo "NPM installing"

npm install
ls
# Complie the ts files and transcript to js files
echo "NPM tsc"
npm run tsc
# echo 'syswari'
# Run the Selenium installation script, located in the local node_modules/ directory.
# This script downloads the files required to run Selenium itself and build a start script and a directory with them.
# When this script is finished, we can start the standalone version of Selenium with the Chrome driver by executing the start script.
# node ./node_modules/protractor/bin/webdriver-manager update --versions.chrome=2.38 --versions.standalone=2.3.1
webdriver-manager update --versions.chrome=2.38 --versions.standalone=2.3.1
# X11 for Ubuntu is not configured! The following configurations are needed for XVFB.
# Make a new display :21 with virtual screen 0 with resolution 1024x768 24dpi
Xvfb :10 -screen 0 1920x1080x24 2>&1 >/dev/null &
# Export the previously created display
# export DISPLAY=:10.0

# Right now this is not necessary, because of 'directConnect: true' in the 'e2e.conf.js'
echo "Starting webdriver"
sudo webdriver-manager start --versions.chrome=2.38 --versions.standalone=2.3.1 --detach
# node ./node_modules/protractor/bin/webdriver-manager start [OR webdriver-manager start] &
echo "Finished starting webdriver"
sleep 20

echo "Running Protractor tests"
# The 'uluwatu-e2e-protractor' test project launch configuration file (e2e.conf.js) should be passed here.
DISPLAY=:10 protractor $@
export RESULT=$?

echo "Protractor tests have done"
# Close the XVFB display
killall Xvfb
# Remove temporary folders
rm -rf .config .local .pki .cache .dbus .gconf .mozilla
# Set the file access permissions (read, write and access) recursively for the result folders
chmod -Rf 777 allure-results test-results

exit $RESULT
