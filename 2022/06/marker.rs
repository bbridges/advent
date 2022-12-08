use std::io::{self, Read};

fn main() {
    let mut input = vec![];
    io::stdin().read_to_end(&mut input).unwrap();

    let s_1 = &input;
    let s_2 = &input[1..];
    let s_3 = &input[2..];
    let s_4 = &input[3..];

    let mut i = 0;

    while s_1[i] == s_2[i]
        || s_1[i] == s_3[i]
        || s_1[i] == s_4[i]
        || s_2[i] == s_3[i]
        || s_2[i] == s_4[i]
        || s_3[i] == s_4[i]
    {
        i += 1
    }

    let marker = i + 4;

    println!("{}", marker);
}
