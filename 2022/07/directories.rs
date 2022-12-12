use std::{collections::HashMap, fmt::Write, io};

fn main() {
    let lines = io::stdin().lines().map(|l| l.unwrap()).collect::<Vec<_>>();

    let mut directory_sizes: HashMap<String, u32> = HashMap::new();
    let mut open_dirs: Vec<String> = vec![];

    let mut i = 1;
    let lines_count = lines.len();

    while i < lines_count {
        let command = &lines[i];

        match &command[..4] {
            "$ ls" => {
                while i < lines_count - 1 && !lines[i + 1].starts_with("$") {
                    i += 1;

                    let entry = &lines[i];
                    let (left, _name) = entry.split_once(' ').unwrap();

                    if left == "dir" {
                        continue;
                    }

                    let file_size = left.parse::<u32>().unwrap();

                    let dir_path = &mut "/".to_string();

                    if let Some(existing) = directory_sizes.get_mut(dir_path) {
                        *existing += file_size;
                    } else {
                        directory_sizes.insert(dir_path.clone(), file_size);
                    }

                    for open_dir in &open_dirs {
                        dir_path.write_fmt(format_args!("/{}", open_dir)).unwrap();

                        if let Some(existing) = directory_sizes.get_mut(dir_path) {
                            *existing += file_size;
                        } else {
                            directory_sizes.insert(dir_path.clone(), file_size);
                        }
                    }
                }
            }
            "$ cd" => match &command[5..] {
                ".." => {
                    open_dirs.pop();
                }
                name => {
                    open_dirs.push(name.to_string());
                }
            },
            _ => panic!("invalid command"),
        }

        i += 1;
    }

    let total_small_dirs: u32 = directory_sizes.values().filter(|&&s| s <= 100_000).sum();

    println!("{}", total_small_dirs);
}
