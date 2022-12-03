use std::io;

fn main() {
    let input: Vec<String> = io::stdin().lines().map(|l| l.unwrap()).collect();

    let mut total: u32 = 0;

    for line in input {
        let bytes = line.as_bytes();
        let (left, right) = bytes.split_at(bytes.len() / 2);

        for l in left {
            if right.contains(l) {
                total += if l.is_ascii_uppercase() {
                    l - ('A' as u8) + 27
                } else {
                    l - ('a' as u8) + 1
                } as u32;
                break;
            }
        }
    }

    println!("{}", total);
}
