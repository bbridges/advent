use std::io;

fn main() {
    let input = io::stdin().lines().map(|l| l.unwrap());

    let mut x = 1;
    let mut cycle = 1;
    let mut sum = 0;

    for line in input {
        let cycle_stage = cycle % 40;

        match &line[..4] {
            "noop" => {
                if cycle_stage == 20 {
                    sum += cycle * x;
                }

                cycle += 1;
            }
            "addx" => {
                let num = line[5..].parse::<i32>().unwrap();

                if cycle_stage == 20 {
                    sum += cycle * x;
                } else if cycle_stage == 19 {
                    sum += (cycle + 1) * x;
                }

                x += num;
                cycle += 2;
            }
            _ => panic!("unexpected instruction"),
        }
    }

    println!("{}", sum);
}
