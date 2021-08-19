fn minimum_weight(nodes: u64, edges: u64, mst_weight: u64) -> Option<u64> {
    // check that this is solvable
    if (nodes == 0 || nodes == 1) && (edges > 0 || mst_weight > 0)
        || edges + 1 < nodes
        || mst_weight + 1 < nodes
        || edges > nodes * (nodes - 1) / 2
    {
        return None;
    }

    if nodes == 1 {
        return Some(0);
    }

    // our solution is to make the MST have most of its weight on one edge.
    // Then if m - 1 <= (n - 1) * (n - 2) / 2,
    // we can put all our added edges amongst the low-weight edges, all at weight 1
    if edges <= (nodes - 1) * (nodes - 2) / 2 + 1 {
        return Some(mst_weight + (edges - (nodes - 1)));
    }

    // otherwise, we'll have to add edges from the node that's only connected by the edge where our weight is
    let extra_edges = edges - ((nodes - 1) * (nodes - 2) / 2 + 1);

    // if n is large enough, we can't get an advantage by redistributing the weight
    // this actually simplifies to n >= 1 + sqrt(2m) (similar to what we had before)
    if nodes >= 2 * extra_edges + 3 {
        return Some((nodes - 1) * (nodes - 2) / 2 + (1 + extra_edges) * (mst_weight - (nodes - 2)))
    }

    // In this sweet spot, we can get an advantage by spreading out the weight as much as possible
    let light_weight = mst_weight / (nodes - 1);

    // here, partial switching isn't worth it, since we can't switch enough edges
    // to hit the payoff point
    // So we still even out as much as we can, but only have one heavy edge in the MST
    if 2 * nodes > mst_weight - light_weight * (nodes - 1) + 2 * extra_edges + 4 {
        return Some(((nodes - 1) * (nodes - 2) / 2 * light_weight + (1 + extra_edges) * (mst_weight - light_weight * (nodes - 2))))
    }

    let heavy_weight = light_weight + 1;

    let heavy_mst_edges = mst_weight - light_weight * (nodes - 1);

    let light_mst_edges = (nodes - 1) - heavy_mst_edges;

    let light_edges = edges.min((light_mst_edges + 1) * light_mst_edges / 2);
    let heavy_edges = edges - light_edges;

    Some(light_edges * light_weight + heavy_edges * heavy_weight)
}

macro_rules! read_types {
    ($($t: ty),*) => {
        {
            let mut string = String::new();
            std::io::stdin().read_line(&mut string).expect("Error while reading stdin");
            let mut values = string.split_whitespace();
            (
                $(
                    values.next().expect("Not enough input").parse::<$t>().expect("Unable to parse")
                ),*
            )
        };
    };
}

fn main() {
    let cases = read_types!(usize);
    for _ in 0..cases {
        let (nodes, edges, mst_weight) = read_types!(u64, u64, u64);
        if let Some(minimum) = minimum_weight(nodes, edges, mst_weight) {
            println!("{}", minimum);
        } else {
            println!("Invalid input")
        }
    }
}
