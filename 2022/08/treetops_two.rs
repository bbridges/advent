use std::io;

fn main() {
    let input = io::stdin()
        .lines()
        .map(|l| l.unwrap().as_bytes().to_vec())
        .collect::<Vec<_>>();

    let rows = input.len();
    let cols = input[0].len();

    let mut scores = vec![0; (rows - 1) * (cols - 1)];

    for i in 1..(rows - 1) {
        let row = &input[i];

        for j in 1..(cols - 1) {
            let value = row[j];
            let (mut l, mut r, mut u, mut d) = (j, j, i, i);

            while l > 1 && row[l - 1] < value {
                l -= 1;
            }

            while r < cols - 2 && row[r + 1] < value {
                r += 1;
            }

            while u > 1 && input[u - 1][j] < value {
                u -= 1;
            }

            while d < rows - 2 && input[d + 1][j] < value {
                d += 1;
            }

            let score = (j - l + 1) * (r - j + 1) * (i - u + 1) * (d - i + 1);
            scores[(i - 1) * rows + j - 1] = score;
        }
    }

    let max_score = scores.iter().max().unwrap();

    println!("{}", max_score);
}
