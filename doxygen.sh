#
# Build the doxygen documentation for the project and load the docset into Xcode 
#
# Created by Fred McCann (www.duckrowing.com) based on:
# http://developer.apple.com/tools/creatingdocsetswithdoxygen.html
#

COMPANY_RDOMAIN_PREFIX=es.com.jano     # your app id
PRODUCT_NAME=Jobsket                   # your app name
SOURCE_ROOT=sources/objective-c        # source folder
TEMP_DIR=build/tmp                     # a tmp folder
DOXYFILE=sources/doxygen/Doxyfile      # doxygen config file
DOXYGEN_PATH=doxygen                   # Installation: sudo port install doxygen


# create the config file if needed
if ! [ -f $DOXYFILE ] 
then 
  echo doxygen config file does not exist
  $DOXYGEN_PATH -g $DOXYFILE
fi


#  Append the proper input/output directories and docset info to the config file.
echo mkdir -p $TEMP_DIR
mkdir -p $TEMP_DIR
cp $DOXYFILE $TEMP_DIR/Doxyfile
DOCSET_PATH=build/$PRODUCT_NAME.docset
echo "INPUT              = \"$SOURCE_ROOT\"" >> $TEMP_DIR/Doxyfile
echo "OUTPUT_DIRECTORY   = $DOCSET_PATH" >> $TEMP_DIR/Doxyfile
echo "RECURSIVE          = YES"          >> $TEMP_DIR/Doxyfile
echo "EXTRACT_ALL        = YES"          >> $TEMP_DIR/Doxyfile
echo "JAVADOC_AUTOBRIEF  = YES"          >> $TEMP_DIR/Doxyfile
echo "GENERATE_LATEX     = NO"           >> $TEMP_DIR/Doxyfile
echo "GENERATE_DOCSET    = YES"          >> $TEMP_DIR/Doxyfile
echo "DOCSET_FEEDNAME    = $PRODUCT_NAME Documentation" >> $TEMP_DIR/Doxyfile
echo "DOCSET_BUNDLE_ID   = $COMPANY_RDOMAIN_PREFIX.$PRODUCT_NAME" >> $TEMP_DIR/Doxyfile

echo "HTML_STYLESHEET  = sources/doxygen/terminal-style.css" >> $TEMP_DIR/Doxyfile
echo "HTML_HEADER      = sources/doxygen/header.html"        >> $TEMP_DIR/Doxyfile
echo "HTML_FOOTER      = sources/doxygen/footer.html"        >> $TEMP_DIR/Doxyfile


#  Run doxygen on the updated config file.
$DOXYGEN_PATH $TEMP_DIR/Doxyfile


#  Doxygen generates a make file that invokes docsetutil. 
echo 
echo RUNNING MAKE FILE... 
make -C $DOCSET_PATH/html install


#  Build an applescript file to tell Xcode to load a docset.
rm -f $TEMP_DIR/loadDocSet.scpt
echo "tell application \"Xcode\"" >> $TEMP_DIR/loadDocSet.scpt
echo "load documentation set with path \"/Users/$USER/Library/Developer/Shared/Documentation/DocSets/$COMPANY_RDOMAIN_PREFIX.$PRODUCT_NAME.docset\"" >> $TEMP_DIR/loadDocSet.scpt
echo "end tell" >> $TEMP_DIR/loadDocSet.scpt
osascript $TEMP_DIR/loadDocSet.scpt


exit 0
