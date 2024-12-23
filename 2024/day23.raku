#!/usr/bin/env raku

my $file = open 'day23.txt';

my %graph;
for $file.lines -> $line {
    my ($l, $r) = $line.split('-');
    %graph{$l}.push($r);
    %graph{$r}.push($l);
}

my $set = SetHash.new();
my $visited = SetHash.new();

sub append_sets($set, $depth, $curr, @curr_arr) {
    if $depth == 1 {
        for %graph{$curr}.values -> $neighbour {
            if $visited !(cont) $neighbour and @curr_arr ∌ $neighbour and all @curr_arr>>.&{ %graph{$_} (cont) $neighbour } {
                my $inter_connected = sort(@curr_arr.clone.push($neighbour));
                $set{ $inter_connected.join('-') } = True
            }
        }
        return;
    }

    for %graph{$curr}.values -> $neighbour {
        if $visited !(cont) $neighbour and @curr_arr ∌ $neighbour and all @curr_arr>>.&{ %graph{$_} (cont) $neighbour } {
            my @inter_connected = @curr_arr.clone.push($neighbour);
            append_sets($set, $depth - 1, $neighbour, @inter_connected);
        }
    }
}

for %graph.keys -> $node {
    append_sets($set, 3, $node, []);
    $visited{$node} = True;
}

# say $set;

my $part1 = $set.keys.grep({ /<(^t|\-t)>/ }).elems;

say "part1: $part1";
