def version = [
	ant: '1.9.6',
	ivy: '2.4.0'
]

def url = [
	ant: "https://www.apache.org/dist/ant/binaries/apache-ant-${version.ant}-bin.tar.gz",
	ivy: "https://www.apache.org/dist/ant/ivy/${version.ivy}/apache-ivy-${version.ivy}-bin.tar.gz"
]

// generate properties file
ant.propertyfile(file: 'build-ant.properties', comment: "Apache Ant ${version.ant} & Apache Ivy ${version.ivy} binaries") {
	version.each{ n, v ->
		entry(key:"${n}.version", value: v)
		entry(key:"${n}.url", value: url[n])
		entry(key:"${n}.md5", value: new URL(url[n]+'.md5').getText().tokenize().first())
	}
}
