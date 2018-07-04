import groovy.xml.*


def f = 'qnap-repo.xml' as File

def now = new Date()

f.withWriter('UTF-8') { writer ->
	def xml = new MarkupBuilder(writer)

	xml.mkp.xmlDeclaration(version: "1.0", encoding: "utf-8")
	xml.plugins {
		item {
			cachechk(now.format('yyyyMMddHHmm'))
			name(properties.title)
			internalName(properties.package)
			category('Essentials')
			type('Developer Tools')
			icon80('https://github.com/rednoah/java-installer/raw/master/package/qnap/icons/oracle-java_80.gif')
			description("${properties.title} will help you install ${properties.product} ${properties.version} on your Synology NAS. On install, this package will download the Apache Ant and Apache Ivy binaries and optional libraries. This may take a while.")
			fwVersion('4.2.1')
			version(properties.version)
			['TS-269H', 'TS-NASARM', 'TS-NASX86', 'TS-X28', 'TS-X31', 'TS-X31U', 'TS-X41', 'TS-ARM-X09', 'TS-ARM-X19'].each{ id ->
				platform{
					platformID(id)
					location("https://github.com/rednoah/ant-installer/releases/download/${properties.version}/${properties.package}-${properties.version}.qpkg")
				}
			}
			publishedDate(now.format('yyyy/MM/dd'))
			maintainer('rednoah')
			forumLink('https://github.com/rednoah/ant-installer')
			language('English')
		}
	}
}
