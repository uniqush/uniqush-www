# = webgen extensions directory
#
# All init.rb files anywhere under this directory get automatically loaded on a webgen run. This
# allows you to add your own extensions to webgen or to modify webgen's core!
#
# If you don't need this feature you can savely delete this file and the directory in which it is!
#
# The +config+ variable below can be used to access the Webgen::Configuration object for the current
# website.


# class Version
#   include Comparable
#
#   attr_reader :major, :feature_group, :feature, :bugfix
#
#   def initialize(version="")
#     v = version.split(".")
#     @major = v[0].to_i
#     @feature_group = v[1].to_i
#     @feature = v[2].to_i
#     @bugfix = v[3].to_i
#   end
#
#   def <=>(other)
#     return @major <=> other.major if ((@major <=> other.major) != 0)
#     return @feature_group <=> other.feature_group if ((@feature_group <=> other.feature_group) != 0)
#     return @feature <=> other.feature if ((@feature <=> other.feature) != 0)
#     return @bugfix <=> other.bugfix
#   end
#
#   def self.sort
#     self.sort!{|a,b| a <=> b}
#   end
#
#   def to_s
#     @major.to_s + "." + @feature_group.to_s + "." + @feature.to_s + "." + @bugfix.to_s
#   end
# end

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

#Downloads

Please follow the instructions from [Installing Uniqush and its Dependencies](documentation/install.html) to install.


eos

downloadf = File.open("src/downloads.page", "w+")
downloadf.write(download_prefix)

programs = []
versions = {}
archs = {}
package_types = ["deb", "rpm", "tar.gz"]

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
        prog = m[1]
        ver = m[2]
        arch = m[3]

        if not versions.has_key?(prog)
            versions[prog] = []
        end
        if not archs.has_key?(prog)
            archs[prog] = []
        end
        versions[prog] << ver
        archs[prog] << arch
        programs << prog
    end
end


programs.uniq.each do | prog |
    downloadf.write("##" + prog + "\n\n")
    puts prog
    archs[prog].uniq.each do | arch |
        versions[prog] = versions[prog].uniq.sort { |x, y| y <=> x}
        latest = versions[prog][0]
        downloadf.write("latest version: **" + latest + "**\n")
        versions[prog].each do | ver |
            puts ver
            v = String.new(ver)
	    v["."]="-"
	    v["."]="-"
	    puts v
	    rnfile = "release-notes/rn-" + prog + "-" + v + ".html"
            downloadf.write("\n[" + prog + " " + ver + " release note](" + rnfile + ")\n\n")
            package_types.each do | pkg |
                arch_name = archconv[pkg][arch]
                filename = prog + prog_ver_sep[pkg] + ver + ver_arch_sep[pkg] + arch_name + "." + pkg
                downloadf.write("- [" + arch + " " + ver + " " + pkg + "](https://github.com/uniqush/uniqush-push/releases/tag/" + ver + ")\n")
            end
        end
    end
end
downloadf.close

