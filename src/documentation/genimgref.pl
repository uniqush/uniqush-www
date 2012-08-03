while (<>) {
    chomp;
    if (/\/([a-zA-Z0-9\-_]+)\.png/) {
        print "[$1]: $_\n";
    }
}
