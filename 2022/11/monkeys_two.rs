use std::io;

fn main() {
    let input = io::stdin().lines().map(|l| l.unwrap()).collect::<Vec<_>>();

    let mut item_lists = vec![];
    let mut operations = vec![];
    let mut tests = vec![];
    let mut inspection_counts = vec![];

    for lines in input.chunks(7) {
        let items = lines[1][18..]
            .split(", ")
            .map(|s| s.parse::<u64>().unwrap())
            .collect::<Vec<_>>();

        let operation = match lines[2].as_bytes()[23] as char {
            '+' => Operation::Add(lines[2][25..].parse::<u64>().unwrap()),
            '*' if &lines[2][25..] == "old" => Operation::Square,
            '*' => Operation::Mul(lines[2][25..].parse::<u64>().unwrap()),
            _ => panic!("unexpected operation"),
        };

        let test = (
            lines[3][21..].parse::<u64>().unwrap(),
            lines[4][29..].parse::<usize>().unwrap(),
            lines[5][30..].parse::<usize>().unwrap(),
        );

        item_lists.push(items);
        operations.push(operation);
        tests.push(test);
        inspection_counts.push(0);
    }

    let lcd = tests.iter().map(|&t| t.0).reduce(|acc, n| acc * n).unwrap();
    let count = item_lists.len();

    for _ in 0..10000 {
        for i in 0..count {
            let item_count = item_lists[i].len();

            for j in 0..item_count {
                let item = item_lists[i][j];

                let worry = match operations[i] {
                    Operation::Add(n) => item + n,
                    Operation::Mul(n) => item * n,
                    Operation::Square => item * item,
                } % lcd;

                let target = if worry % tests[i].0 == 0 {
                    tests[i].1
                } else {
                    tests[i].2
                };

                item_lists[target].push(worry);
            }

            inspection_counts[i] += item_count;
            item_lists[i].clear();
        }
    }

    inspection_counts.sort();

    println!(
        "{}",
        inspection_counts[count - 1] * inspection_counts[count - 2]
    );
}

enum Operation {
    Add(u64),
    Mul(u64),
    Square,
}
