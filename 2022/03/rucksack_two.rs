use std::io;

fn main() {
    let input: Vec<String> = io::stdin().lines().map(|l| l.unwrap()).collect();

    let groups = input.chunks_exact(3);
    let mut total: u32 = 0;

    for group in groups {
        let left = group[0].as_bytes();
        let middle = group[1].as_bytes();
        let right = group[2].as_bytes();

        for l in left {
            if middle.contains(l) && right.contains(l) {
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
