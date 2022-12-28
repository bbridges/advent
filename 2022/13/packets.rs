use std::{cmp::Ordering, io, iter::Peekable, str::Bytes};

fn main() {
    let input = io::stdin()
        .lines()
        .map(|l| l.unwrap())
        .collect::<Vec<_>>()
        .chunks(3)
        .map(|c| (Packet::parse(&c[0]), Packet::parse(&c[1])))
        .collect::<Vec<_>>();

    let mut sum = 0;

    for (i, (left, right)) in input.iter().enumerate() {
        if Packet::in_order(left, right) {
            sum += i + 1;
        }
    }

    println!("{}", sum);
}

struct Packet {
    data: Vec<PacketData>,
}

enum PacketData {
    Integer(u8),
    List(Vec<PacketData>),
}

impl Packet {
    pub fn parse(s: &String) -> Packet {
        Packet {
            data: Self::parse_list(&mut s.bytes().peekable()),
        }
    }

    fn parse_list(b: &mut Peekable<Bytes>) -> Vec<PacketData> {
        let mut list = vec![];
        b.next();

        loop {
            match b.peek().unwrap() {
                b'0'..=b'9' => {
                    let parsed = Self::parse_integer(b);
                    list.push(PacketData::Integer(parsed));
                }
                b'[' => {
                    let parsed = Self::parse_list(b);
                    list.push(PacketData::List(parsed));
                }
                b',' => {
                    b.next();
                }
                b']' => {
                    break;
                }
                _ => panic!("unexpected data"),
            }
        }

        b.next();
        list
    }

    fn parse_integer(b: &mut Peekable<Bytes>) -> u8 {
        let mut number = b.next().unwrap() - b'0';

        while u8::is_ascii_digit(b.peek().unwrap()) {
            number = 10 * number + b.next().unwrap() - b'0';
        }

        number
    }

    pub fn in_order(left: &Packet, right: &Packet) -> bool {
        Self::lists_in_order(&left.data, &right.data).expect("order is indeterminate")
    }

    fn lists_in_order(left: &Vec<PacketData>, right: &Vec<PacketData>) -> Option<bool> {
        for i in 0..left.len() {
            let left_data = &left[i];

            if let Some(right_data) = right.get(i) {
                let next = match (left_data, right_data) {
                    (PacketData::Integer(l), PacketData::Integer(r)) => match l.cmp(&r) {
                        Ordering::Less => Some(true),
                        Ordering::Greater => Some(false),
                        Ordering::Equal => None,
                    },
                    (PacketData::List(l), PacketData::List(r)) => Self::lists_in_order(l, r),
                    (PacketData::Integer(l), PacketData::List(r)) => {
                        Self::lists_in_order(&vec![PacketData::Integer(*l)], r)
                    }
                    (PacketData::List(l), PacketData::Integer(r)) => {
                        Self::lists_in_order(l, &vec![PacketData::Integer(*r)])
                    }
                };

                if next.is_some() {
                    return next;
                }
            } else {
                return Some(false);
            }
        }

        if left.len() == right.len() {
            None
        } else {
            Some(true)
        }
    }
}
