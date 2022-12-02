use std::io;

fn move_for_outcome(theirs: char, outcome: char) -> char {
    match (outcome, theirs) {
        ('X', 'A') => 'C',
        ('X', 'B') => 'A',
        ('X', 'C') => 'B',
        ('Y', 'A') => 'A',
        ('Y', 'B') => 'B',
        ('Y', 'C') => 'C',
        ('Z', 'A') => 'B',
        ('Z', 'B') => 'C',
        ('Z', 'C') => 'A',
        _ => panic!("invalid play"),
    }
}

fn main() {
    let input: Vec<[char; 2]> = io::stdin()
        .lines()
        .map(|l| {
            let line = l.unwrap();
            let bytes = line.as_bytes();
            [bytes[0] as char, bytes[2] as char]
        })
        .collect();

    let sum: u32 = input
        .iter()
        .map(|l| {
            let selected_points = match move_for_outcome(l[0], l[1]) {
                'A' => 1,
                'B' => 2,
                'C' => 3,
                _ => panic!("invalid play"),
            };
            let outcome_points = match l[1] {
                'X' => 0,
                'Y' => 3,
                'Z' => 6,
                _ => panic!("invalid play"),
            };

            selected_points + outcome_points
        })
        .sum();

    println!("{}", sum)
}
