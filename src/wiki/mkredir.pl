while (<>) {
    chomp;
    my ($dir, $link) = split;
    chomp $dir;
    `rm -rf $dir`;
    `mkdir $dir`;
    open INDEX, "+>$dir/index.page";

    my $content = 
    "---
title: $dir
author: Nan Deng
author_url: /authors/monnand.html
routed_title: dir
redir: $link
---
";

    print INDEX $content;
    close INDEX;
}
