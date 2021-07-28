const MODULUS: usize = 1_000_000_007;
const INV_2: usize = 500_000_004;

//fn inverse_mod(x: usize) -> usize {
//    let mut power = MODULUS - 2;
//
//    let mut result = 1;
//    let mut multiplier = x;
//
//    while power > 0 {
//        if power % 2 == 1 {
//            result *= multiplier;
//            result %= MODULUS;
//        }
//
//        multiplier *= multiplier;
//        multiplier %= MODULUS;
//        power >>= 1;
//    }
//
//    result
//}

fn factorial_mod(x: usize) -> usize {
    (1..=x).fold(1, |prod, k| (prod * k) % MODULUS)
}

fn lsb(n: usize) -> usize {
    n & n.wrapping_neg()
}

struct BIT {
    tree: Vec<usize>,
}

impl BIT {
    fn from_freq(freq: &[u8]) -> Self {
        let mut tree = Vec::with_capacity(freq.len());
        for (i, &f) in freq.iter().enumerate().map(|(i, f)| (i + 1, f)) {
            let mut sum = f as usize;

            let mut index = i - 1;
            while index > i - lsb(i) {
                sum += tree[index - 1];
                index -= lsb(index);
            }

            tree.push(sum);
        }

        Self { tree }
    }

    fn subtract(&mut self, mut index: usize, value: usize) {
        while index <= self.tree.len() {
            self.tree[index - 1] -= value;
            index += lsb(index);
        }
    }

    fn get(&self, mut index: usize) -> usize {
        let mut sum = 0;
        while index > 0 {
            sum += self.tree[index - 1];
            index -= lsb(index);
        }
        sum
    }
}

struct CumulativeSums {
    cum_sums: Vec<usize>,
}

impl CumulativeSums {
    // freqs is one-based
    fn from_inv_freqs(freqs: &[u8]) -> Self {
        let mut count = 0;
        let mut cum_sums = Vec::with_capacity(freqs.len());
        for &f in freqs {
            if f == 0 {
                count += 1;
            }
            cum_sums.push(count);
        }

        Self { cum_sums }
    }

    fn num_less(&self, index: usize) -> usize {
        // strictly less
        if index <= 1 {
            return 0;
        }

        *self
            .cum_sums
            .get(index - 2)
            .or_else(|| self.cum_sums.last())
            .unwrap_or(&0)
    }

    fn num_greater(&self, index: usize) -> usize {
        // strictly greater
        if index == 0 {
            return *self.cum_sums.last().unwrap_or(&0);
        }

        *self.cum_sums.last().unwrap_or(&0) - self.cum_sums.get(index - 1).unwrap_or(&0)
    }
}

struct PermutationInfo {
    permutation: Vec<usize>,
    num_blanks: usize,
    remaining_nums: BIT,
    blank_counts: CumulativeSums,
    remaining_blanks: usize,
    sum_inverts: usize,
}

impl PermutationInfo {
    fn new(permutation: Vec<usize>) -> Self {
        // 1-based indexing
        let mut occ_count = vec![0_u8; permutation.len()];
        let mut num_blanks = 0;
        let mut occurences = vec![];

        for &el in &permutation {
            if el > 0 {
                occ_count[el - 1] += 1;
                occurences.push(el);
            } else {
                num_blanks += 1;
            }
        }

        let remaining_nums = BIT::from_freq(&occ_count);
        let blank_counts = CumulativeSums::from_inv_freqs(&occ_count);

        let sum_inverts = occurences
            .into_iter()
            .fold(0, |sum, x| (sum + blank_counts.num_greater(x)) % MODULUS);

        Self {
            permutation,
            num_blanks,
            remaining_nums,
            blank_counts,
            remaining_blanks: num_blanks,
            sum_inverts,
        }
    }

    fn consume_blank(&mut self) -> usize {
        self.remaining_blanks -= 1;

        ((((self.remaining_blanks * self.num_blanks) % MODULUS) * INV_2) % MODULUS
            + self.sum_inverts)
            % MODULUS
    }

    fn consume_num(&mut self, num: usize) -> usize {
        self.remaining_nums.subtract(num, 1);
        self.sum_inverts =
            ((MODULUS - self.blank_counts.num_greater(num)) + self.sum_inverts) % MODULUS;

        ((self.remaining_nums.get(num) * self.num_blanks % MODULUS)
            + (self.remaining_blanks * self.blank_counts.num_less(num) % MODULUS))
            % MODULUS
    }

    fn consume_num_no_blanks(&mut self, num: usize) -> usize {
        self.remaining_nums.subtract(num, 1);

        self.remaining_nums.get(num) % MODULUS
    }

    fn row_num(mut self) -> usize {
        let permutation = std::mem::replace(&mut self.permutation, vec![]);

        let mut multiplier = permutation.len();
        let mut sum = 0;

        if self.num_blanks > 0 {
            for element in permutation {
                if element > 0 {
                    sum = sum * multiplier % MODULUS + self.consume_num(element) % MODULUS;
                } else {
                    sum = sum * multiplier % MODULUS + self.consume_blank() % MODULUS;
                }
                multiplier -= 1;
            }
            (((sum + self.num_blanks) % MODULUS) * factorial_mod(self.num_blanks - 1)) % MODULUS
        } else {
            for element in permutation {
                sum = sum * multiplier % MODULUS + self.consume_num_no_blanks(element) % MODULUS;
                multiplier -= 1;
            }
            (sum + 1) % MODULUS
        }
    }
}

macro_rules! skip_line {
    () => {
        let mut string = String::new();
        std::io::stdin()
            .read_line(&mut string)
            .expect("Error while reading stdin");
    };
}

macro_rules! read_vec {
    ($t: ty) => {{
        let mut string = String::new();
        std::io::stdin()
            .read_line(&mut string)
            .expect("Error while reading stdin");
        string
            .split_whitespace()
            .map(|x| x.parse().expect("Unable to parse"))
            .collect::<Vec<$t>>()
    }};
}

fn main() {
    skip_line!();

    let permutation = read_vec!(usize);

    let perm_info = PermutationInfo::new(permutation);

    println!("{}", perm_info.row_num());
}
