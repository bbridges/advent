use std::{cmp::Ordering, io, iter::Peekable, str::Bytes};

fn main() {
    let mut input = io::stdin()
        .lines()
        .map(|l| l.unwrap())
        .filter(|l| !l.is_empty())
        .map(|l| Packet::parse(&l))
        .collect::<Vec<_>>();

    let dividers = [2, 6];

    for d in dividers {
        input.push(Packet {
            data: vec![PacketData::List(vec![PacketData::Integer(d)])],
        });
    }

    input.sort_by(|l, r| {
        if Packet::in_order(l, r) {
            Ordering::Less
        } else {
            Ordering::Greater
        }
    });

    let mut product = 1;

    for d in dividers {
        product *= 1 + input
            .iter()
            .position(|p| {
                if p.data.len() != 1 {
                    return false;
                }

                if let PacketData::List(inner) = &p.data[0] {
                    if inner.len() != 1 {
                        return false;
                    }

                    if let PacketData::Integer(i) = inner[0] {
                        return i == d;
                    }
                }

                false
            })
            .unwrap();
    }

    println!("{}", product);
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
