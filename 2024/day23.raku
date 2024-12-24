#!/usr/bin/env raku

sub get_graph($file_path) {
    my $file = open $file_path;
    my %graph;
    for $file.lines -> $line {
        my ($l, $r) = $line.split('-');
        %graph{$l}.push($r);
        %graph{$r}.push($l);
    }
    return %graph;
}

sub interconnected($set, $depth, $curr, @curr_arr, %graph, $visited) {
    if $depth == 1 {
        for %graph{$curr}.values -> $neighbour {
            if $visited !(cont) $neighbour and @curr_arr ∌ $neighbour and all @curr_arr>>.&{ %graph{$_} (cont) $neighbour } {
                my $inter_connected = sort(@curr_arr.clone.push($neighbour));
                $set{ $inter_connected.join('-') } = True;
            }
        }
        return;
    }

    for %graph{$curr}.values -> $neighbour {
        if $visited !(cont) $neighbour and @curr_arr ∌ $neighbour and all @curr_arr>>.&{ %graph{$_} (cont) $neighbour } {
            my @inter_connected = @curr_arr.clone.push($neighbour);
            interconnected($set, $depth - 1, $neighbour, @inter_connected, %graph, $visited);
        }
    }
}

sub largest_cluster($start, %graph, $visited) {
    my $curr_visited = SetHash.new($start);

    my @inter_connected = [$start];
    for %graph{$start}.values -> $neighbour {
        if $visited !(cont) $neighbour and $curr_visited ∌ $neighbour and all @inter_connected>>.&{ %graph{$_} (cont) $neighbour } {
            @inter_connected.push($neighbour);
        }
        $curr_visited{$neighbour} = True;
    }

    for @inter_connected -> $curr {
        for %graph{$curr}.values -> $neighbour {
            if $visited !(cont) $neighbour and $curr_visited ∌ $neighbour and all @inter_connected>>.&{ %graph{$_} (cont) $neighbour } {
                @inter_connected.push($neighbour);
            }
            $curr_visited{$neighbour} = True;
        }
    }

    return sort(@inter_connected).join(',');
}

sub part1(%graph) {
    my $set = SetHash.new();
    my $visited = SetHash.new();
    for %graph.keys -> $node {
        interconnected($set, 2, $node, [$node], %graph, $visited);
        $visited{$node} = True;
    }

    return $set.keys.grep({ /<(^t|\-t)>/ }).elems;
}

sub part2(%graph) {
    my @clusters = [];
    my $visited = SetHash.new();
    for %graph.keys -> $node {
        @clusters.push(largest_cluster($node, %graph, $visited));
        $visited{$node} = True;
    }

    return @clusters.max(:by({ $_.chars }));
}

my %graph = get_graph("day23.txt");
say "part1: &part1(%graph)";
say "part2: &part2(%graph)";
