//: [Previous](@previous)

//: Problem 11 (*) Modified run-length encoding.
//:
//: Modify the result of problem 10 in such a way that if an element
//: has no duplicates it is simply copied into the result list.
//: Only elements with duplicates are transferred as (N E) lists.

enum Code<T> {
    case Single(T)
    case Multiple(Int, T)
}

func myLength<T>(list: List<T>) -> Int {
    return list.reduce(0) {(n, m) in n + 1}
}

func pack<T: Comparable>(list: List<T>) -> List<List<T>> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, .Cons(head2, tail2)) where head == head2:
        guard case let .Cons(phead, ptail) = pack(.Cons(head2, tail2)) else { return .Nil }
        return .Cons(.Cons(head, phead), ptail)
    case let .Cons(head, tail):
        return .Cons(List(head), pack(tail))
    }
}

func encode<T: Comparable>(list: List<T>) -> List<(Int, T)> {
    func conv(list: List<List<T>>) -> List<(Int, T)> {
        guard case let .Cons(head, tail) = list else {return .Nil }
        guard case let .Cons(head1, _) = head else {return conv(tail) }
        return .Cons((myLength(head), head1), conv(tail))
    }
    return conv(pack(list))
}

func encodeModified<T: Comparable>(list: List<T>) -> List<Code<T>> {
    func conv(tuple: (Int, T)) -> Code<T> {
        if tuple.0 == 1 {
            return .Single(tuple.1)
        } else {
            return .Multiple(tuple.0, tuple.1)
        }
    }
    return encode(list).map(conv)
}

encodeModified(ListFromString("aaaabccaadeeee")).toArray()

//: Problem 12 (**) Decode a run-length encoded list.
//:
//: Given a run-length code list generated as specified in problem 11.
//: Construct its uncompressed version.

func decodeMultiple<T>(cnt: Int, _ value: T, _ tail: List<T>) -> List<T> {
    guard cnt > 0 else { return tail }
    return .Cons(value, decodeMultiple(cnt - 1, value, tail))
}

func decodeModified<T>(list: List<Code<T>>) -> List<T> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(.Single(value), tail):
        return .Cons(value, decodeModified(tail))
    case let .Cons(.Multiple(cnt, value), tail):
        return decodeMultiple(cnt, value, decodeModified(tail))
    }
}

decodeModified(List(.Single(Character("a")), .Multiple(3, Character("b")))).toString()
decodeModified(List(
    .Multiple(4, Character("a")), .Single(Character("b")), .Multiple(2, Character("c")),
    .Multiple(2, Character("a")), .Single(Character("d")), .Multiple(4, Character("e")))).toString()

decodeModified(encodeModified(ListFromString("aaaabccaadeeee"))).toString()

//: Problem 13 (**) Run-length encoding of a list (direct solution).
//:
//: Implement the so-called run-length encoding data compression method directly.
//: I.e. don't explicitly create the sublists containing the duplicates, as in problem 9,
//: but only count them. As in problem P11, simplify the result list
//: by replacing the singleton lists (1 X) by X.

func encodeDirect<T: Comparable>(list: List<T>) -> List<Code<T>> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, .Cons(head2, tail2)) where head == head2:
        switch encodeDirect(.Cons(head2, tail2)) {
        case .Nil:
            return .Nil
        case let .Cons(.Single(value), tail):
            return .Cons(.Multiple(2, value), tail)
        case let .Cons(.Multiple(cnt, value), tail):
            return .Cons(.Multiple(cnt + 1, value), tail)
        }
    case let .Cons(head, tail):
        return .Cons(.Single(head), encodeDirect(tail))
    }
}

encodeDirect(ListFromString("aaaabccaadeeee")).toArray()

decodeModified(encodeDirect(ListFromString("aaaabccaadeeee"))).toString()

//: Problem 14 (*) Duplicate the elements of a list.

func dupli<T>(list: List<T>) -> List<T> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        return .Cons(head, .Cons(head, dupli(tail)))
    }
}

dupli(List(1, 2, 3)).toArray()

//: Problem 15 (**) Replicate the elements of a list a given number of times.

func repli<T>(list: List<T>, _ cnt: Int) -> List<T> {
    func rep(list: List<T>, _ cnt: Int, _ i: Int) -> List<T> {
        switch list {
        case .Nil:
            return .Nil
        case let .Cons(head, tail):
            if i <= 0 {
                return rep(tail, cnt, cnt)
            } else {
                return .Cons(head, rep(list, cnt, i - 1))
            }
        }
    }
    return rep(list, cnt, cnt)
}

repli(ListFromString("abc"), 3).toString()

//: Problem 16 (**) Drop every N'th element from a list.

func dropEvery<T>(list: List<T>, _ skip: Int) -> List<T> {
    func drop(list: List<T>, _ skip: Int, _ i: Int) -> List<T> {
        switch list {
        case .Nil:
            return .Nil
        case let .Cons(head, tail):
            if i <= 1 {
                return drop(tail, skip, skip)
            } else {
                return .Cons(head, drop(tail, skip, i - 1))
            }
        }
    }
    return drop(list, skip, skip)
}

dropEvery(ListFromString("abcdefghik"), 3).toString()

//: Problem 17 (*) Split a list into two parts; the length of the first part is given.

func split<T>(list: List<T>, _ len: Int) -> (List<T>, List<T>) {
    switch list {
    case .Nil:
        return (.Nil, .Nil)
    case let .Cons(head, tail):
        if len <= 0 {
            return (.Nil, list)
        } else {
            let (a, b) = split(tail, len - 1)
            return (.Cons(head, a), b)
        }
    }
}

let (a, b) = split(ListFromString("abcdefghik"), 3)
(a.toString(), b.toString())

//: Problem 18 (**) Extract a slice from a list.
//:
//: Given two indices, i and k, the slice is the list containing the elements
//: between the i'th and k'th element of the original list (both limits included).
//: Start counting the elements with 1.

func slice<T>(list: List<T>, _ start: Int, _ end: Int) -> List<T> {
    let (a, _) = split(list, end)
    let (_, b) = split(a, start - 1)
    return b
}

slice(ListFromString("abcdefghik"), 3, 7).toString()

//: Problem 19 (**) Rotate a list N places to the left.
//:
//: Hint: Use the predefined functions length and (++).

func append<T>(list1: List<T>, _ list2: List<T>) -> List<T> {
    return list1.reduce(list2) {.Cons($1, $0)}
}

func rotate<T>(list: List<T>, _ cnt: Int) -> List<T> {
    let len = myLength(list)
    let (a, b) = split(list, (cnt % len + len) % len)
    return append(b, a)
}

rotate(ListFromString("abcdefgh"), 3).toString()
rotate(ListFromString("abcdefgh"), -2).toString()

//: Problem 20 (*) Remove the K'th element from a list.

func removeAt<T>(list: List<T>, _ index: Int) -> (T?, List<T>) {
    let (a, b) = split(list, index - 1)
    switch b {
    case .Nil:
        return (nil, list)
    case let .Cons(head, tail):
        if index <= 0 {
            return (nil, list)
        } else {
            return (head, append(a, tail))
        }
    }
}

let (c, d) = removeAt(ListFromString("abcd"), 2)
(c, d.toString())

//: [Next](@next)
