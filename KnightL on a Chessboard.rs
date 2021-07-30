use std::collections::LinkedList;
use std::cell::RefCell;
fn check_knight(k: i32, l: i32, n: i32) -> i32 {
    let queue = RefCell::new(LinkedList::new());
    let marked = RefCell::new(Vec::new());
    queue.borrow_mut().push_back(((0i32, 0i32), 1_i32));
    marked.borrow_mut().push((0i32, 0i32));
    let check_point = |a: i32, b: i32, step: i32| -> bool {
        let point = (a, b);
        if a == (n - 1) && b == (n - 1) { return true }
        let m = marked.borrow().contains(&point);
        if a >= 0 && a < n && b >= 0 && b < n && !m {
            queue.borrow_mut().push_back((point, step + 1));
            marked.borrow_mut().push(point);
        }
        false
    };
    while queue.borrow().len() > 0 {
        let ((i, j), step) = queue.borrow_mut().pop_front().unwrap();
        if   check_point(i - k, j - l, step)
          || check_point(i - k, j + l, step)
          || check_point(i + k, j - l, step)
          || check_point(i + k, j + l, step)
          || check_point(i - l, j - k, step)
          || check_point(i - l, j + k, step)
          || check_point(i + l, j - k, step)
          || check_point(i + l, j + k, step) { return step }
    }
    return -1;
}
fn main() {
    let mut input_string = String::new();
    std::io::stdin().read_line(&mut input_string).ok();
    let n: usize = input_string.trim().parse().unwrap();
    let mut results = vec![vec![-1; n - 1]; n - 1];
    for i in 1..n {
        for j in 1..n {
            results[i-1][j-1] = if i > j { 
               results[j-1][i-1] 
            }
            else {
               check_knight(i as i32, j as i32, n as i32)
            };
        }
        println!("{}", results[i-1].iter().map(|x| x.to_string()).collect::<Vec<_>>().join(" "));
    }
}