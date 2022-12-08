use std::{
    collections::HashSet,
    io::{self, Read},
};

fn main() {
    let mut input = vec![];
    io::stdin().read_to_end(&mut input).unwrap();

    let mut i = 0;

    loop {
        let mut set = HashSet::<u8>::new();
        set.extend(&input[i..(i + 14)]);

        if set.len() == 14 {
            break;
        } else {
            i += 1;
        }
    }

    let marker = i + 14;

    println!("{}", marker);
}
