# = webgen extensions directory
#
# All init.rb files anywhere under this directory get automatically loaded on a webgen run. This
# allows you to add your own extensions to webgen or to modify webgen's core!
#
# If you don't need this feature you can savely delete this file and the directory in which it is!
#
# The +config+ variable below can be used to access the Webgen::Configuration object for the current
# website.
config = Webgen::WebsiteAccess.website.config
config['sourcehandler.patterns']['Webgen::SourceHandler::Copy'] << '**/uniqush*.deb'
config['sourcehandler.patterns']['Webgen::SourceHandler::Copy'] << '**/uniqush*.rpm'
config['sourcehandler.patterns']['Webgen::SourceHandler::Copy'] << '**/uniqush*.tar.gz'

download_prefix = 
    <<-eos
---
title: Downloads
in_menu: true
author: Nan Deng
author_url: http://monnand.me
---

##Downloads

eos

downloadf = File.open("src/downloads.page", "w+")
downloadf.write(download_prefix)

programs = []
versions = []
archs = []
package_types = ["rpm", "deb", "tar.gz"]

archconv = {}
package_types.each do | pkg |
    archconv[pkg] = {}
end

archconv["rpm"]["amd64"] = "x86_64"
archconv["tar.gz"]["amd64"] = "x86_64"
archconv["deb"]["amd64"] = "amd64"

prog_ver_sep = {}
prog_ver_sep["rpm"] = "-"
prog_ver_sep["tar.gz"] = "_"
prog_ver_sep["deb"] = "_"

ver_arch_sep = {}
ver_arch_sep["rpm"] = "-1."
ver_arch_sep["tar.gz"] = "_"
ver_arch_sep["deb"] = "_"

Dir.foreach("src/downloads") do |package|
    if (package =~ /uniqush-.+\.deb/)
        deb_pattern = /(.+)_(.+)_(.+)\.deb/
        m = deb_pattern.match(package)
        programs << m[1]
        versions << m[2]
        archs << m[3]
    end
end

programs.each do | prog |
    downloadf.write("###" + prog + "\n\n")
    archs.each do | arch |
        downloadf.write("####" + arch + "\n\n")
        versions.each do | ver |
            package_types.each do | pkg |
                arch_name = archconv[pkg][arch]
                filename = prog + prog_ver_sep[pkg] + ver + ver_arch_sep[pkg] + arch_name + "." + pkg
                downloadf.write("- [" + pkg + "](downloads/" + filename + ")\n")
            end
        end
    end
end
