use std::io;

fn main() {
    let input = io::stdin().lines().map(|l| l.unwrap());

    let mut x = 0;
    let mut cycle = 0;
    let mut output = String::new();

    for line in input {
        let mut run_tick = || {
            let position = cycle % 40;
            let diff = position - x;
            let pixel = if diff >= 0 && diff <= 2 { "#" } else { "." };

            output += pixel;

            if position == 39 {
                output += "\n";
            }

            cycle += 1;
        };

        match &line[..4] {
            "noop" => {
                run_tick();
            }
            "addx" => {
                run_tick();
                run_tick();

                x += line[5..].parse::<i32>().unwrap()
            }
            _ => panic!("unexpected instruction"),
        }
    }

    print!("{}", output);
}
