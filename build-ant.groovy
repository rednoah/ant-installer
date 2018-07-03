def version = properties.version
def url = "https://www.apache.org/dist/ant/binaries/apache-ant-${version}-bin.tar.bz2"

// generate properties file
ant.propertyfile(file: 'build-ant.properties', comment: "Apache Ant ${version}") {
	entry(key: 'ant.version', value: version)
	entry(key: 'ant.url', value: url)
	entry(key: 'ant.sha512', value: new URL("${url}.sha512").text.trim())
}
