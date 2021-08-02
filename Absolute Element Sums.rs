use std::io::{BufRead, stdin};
use std::str::FromStr;

trait Readable {
    fn read() -> Self;
}

struct Values<T>(Vec<T>);

impl<T: FromStr> Readable for T {
    fn read() -> T {
        let mut buf = String::new();
        stdin().read_line(&mut buf).unwrap();
        buf.trim().parse::<T>().ok().unwrap()
    }
}

impl<T: FromStr> Readable for Values<T> {
    fn read() -> Values<T> {
        let mut buf = String::new();
        stdin().read_line(&mut buf).unwrap();
        Values(buf.trim().split(' ').map(|s| s.parse::<T>().ok().unwrap()).collect())
    }
}

fn main() {
    let n = usize::read();
    let mut nums = Values::<i64>::read().0;
    assert_eq!(nums.len(), n);
    let m = usize::read();
    let Values(queries) = Values::<i64>::read();
    assert_eq!(queries.len(), m);

    nums.sort();
    let partial_sum = nums.iter().fold(vec![0 as i64], |mut v, a| {
        let last = *v.last().unwrap();
        v.push(last + *a);
        v
    });
    let total_sum = partial_sum.last().unwrap();
    let mut sum_acc: i64 = 0;
    for q in queries {
        sum_acc += q;
        let left = match nums.binary_search(&-sum_acc) {
            Ok(idx) => idx,
            Err(idx) => idx,
        };
        let right = nums.len() - left;
        let sum = (total_sum - 2 * partial_sum[left]) + sum_acc * (right as i64 - left as i64);
        println!("{}", sum);
    }
}
