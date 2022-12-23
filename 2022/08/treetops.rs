use std::io;

fn main() {
    let input = io::stdin()
        .lines()
        .map(|l| l.unwrap().as_bytes().to_vec())
        .collect::<Vec<_>>();

    let rows = input.len();
    let cols = input[0].len();

    let mut visibilities = vec![false; (rows - 1) * (cols - 1)];

    for i in 1..(rows - 1) {
        let row = &input[i];

        for j in 1..(cols - 1) {
            let value = row[j];
            let (mut l, mut r, mut u, mut d) = (j, j, i, i);

            while l > 0 && row[l - 1] < value {
                l -= 1;
            }

            while r < cols - 1 && row[r + 1] < value {
                r += 1;
            }

            while u > 0 && input[u - 1][j] < value {
                u -= 1;
            }

            while d < rows - 1 && input[d + 1][j] < value {
                d += 1;
            }

            let visible = l == 0 || r == cols - 1 || u == 0 || d == rows - 1;
            visibilities[(i - 1) * rows + j - 1] = visible;
        }
    }

    let all_visible = 2 * rows + 2 * cols - 4 + visibilities.iter().filter(|&&v| v).count();

    println!("{}", all_visible);
}
