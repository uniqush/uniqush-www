while (<>) {
    chomp;
    while (1) {
        if (/(.*)\[(\S+)\s+(.+)\](.*)/) {
            $_ = "$1[$3]($2)$4";
            print "$1 [$3]($2) $4\n";
        } else {
            last;
        }
    }
    # print "$_\n";
}
