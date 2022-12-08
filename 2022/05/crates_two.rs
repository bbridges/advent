use std::{collections::LinkedList, io, iter};

fn main() {
    let lines = io::stdin()
        .lines()
        .map(|l| l.unwrap())
        .collect::<Vec<String>>();

    // Finding the empty line which separates the initial state from the moves.
    let sep = lines.iter().position(|l| l.is_empty()).unwrap();

    // Using the input width to determine stack count (includes spaces).
    let stack_count = (lines[sep - 1].len() + 1) / 4;

    let mut stacks = iter::repeat_with(LinkedList::<u8>::new)
        .take(stack_count)
        .collect::<Vec<_>>();
    let mut buffer = LinkedList::<u8>::new();

    // Fill in stacks with initial data.
    for i in 0..(sep - 1) {
        for (i, &init_crate) in lines[i][1..].as_bytes().iter().step_by(4).enumerate() {
            if init_crate != b' ' {
                stacks[i].push_back(init_crate);
            }
        }
    }

    // Run the steps to move crates to other stacks.
    for instruction in &lines[(sep + 1)..] {
        let count_start = &instruction[5..];
        let instruction_bytes = instruction.as_bytes();

        let count = count_start[..count_start.find(' ').unwrap()]
            .parse::<u8>()
            .unwrap();
        let from = instruction_bytes[instruction_bytes.len() - 6] - 48;
        let to = instruction_bytes[instruction_bytes.len() - 1] - 48;

        for _ in 0..count {
            buffer.push_front(stacks[from as usize - 1].pop_front().unwrap());
        }

        for _ in 0..count {
            stacks[to as usize - 1].push_front(buffer.pop_front().unwrap());
        }
    }

    // Getting the top of each stack.
    let tops = stacks
        .iter()
        .map(|s| (*s.front().unwrap() as char).to_string())
        .collect::<Vec<_>>()
        .concat();

    println!("{}", tops);
}
