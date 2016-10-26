#/bin/sh
ant resolve && ant update-ant -lib "lib" && ant spk package-source -lib "lib"
