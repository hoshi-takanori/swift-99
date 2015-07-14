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
    guard case let .Cons(_, tail) = list else { return 0 }
    return 1 + myLength(tail.value)
}

func pack<T: Comparable>(list: List<T>) -> List<List<T>> {
    guard case let .Cons(head, tail) = list else { return .Nil }
    let packed = pack(tail.value)
    guard case let .Cons(head2, tail2) = packed else { return Cons(list, packed) }
    guard case let .Cons(head3, _) = head2.value else { return Cons(list, tail2.value) }
    if head.value == head3.value {
        return Cons(Cons(head.value, head2.value), tail2.value)
    } else {
        return Cons(Cons(head.value, .Nil), packed)
    }
}

func encode<T: Comparable>(list: List<T>) -> List<(Int, T)> {
    func conv(list: List<List<T>>) -> List<(Int, T)> {
        guard case let .Cons(head, tail) = list else { return .Nil }
        guard case let .Cons(head2, _) = head.value else { return conv(tail.value) }
        return Cons((myLength(head.value), head2.value), conv(tail.value))
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
    if cnt <= 0 {
        return tail
    } else {
        return Cons(value, decodeMultiple(cnt - 1, value, tail))
    }
}

func decodeModified<T>(list: List<Code<T>>) -> List<T> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        switch head.value {
        case let .Single(value):
            return Cons(value, decodeModified(tail.value))
        case let .Multiple(cnt, value):
            return decodeMultiple(cnt, value, decodeModified(tail.value))
        }
    }
}

ListToString(decodeModified(List(.Single("a"), .Multiple(3, "b"))))
ListToString(decodeModified(List(
    .Multiple(4, "a"), .Single("b"), .Multiple(2, "c"),
    .Multiple(2, "a"), .Single("d"), .Multiple(4, "e"))))

ListToString(decodeModified(encodeModified(ListFromString("aaaabccaadeeee"))))

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
    case let .Cons(head, tail):
        let encoded = encodeDirect(tail.value)
        switch encoded {
        case .Nil:
            return Cons(.Single(head.value), encoded)
        case let .Cons(code, tail2):
            switch code.value {
            case let .Single(value):
                if value == head.value {
                    return Cons(.Multiple(2, value), tail2.value)
                } else {
                    return Cons(.Single(head.value), encoded)
                }
            case let .Multiple(cnt, value):
                if value == head.value {
                    return Cons(.Multiple(cnt + 1, value), tail2.value)
                } else {
                    return Cons(.Single(head.value), encoded)
                }
            }
        }
    }
}

encodeDirect(ListFromString("aaaabccaadeeee")).toArray()

ListToString(decodeModified(encodeDirect(ListFromString("aaaabccaadeeee"))))

//: Problem 14 (*) Duplicate the elements of a list.

func dupli<T>(list: List<T>) -> List<T> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        return Cons(head.value, Cons(head.value, dupli(tail.value)))
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
                return rep(tail.value, cnt, cnt)
            } else {
                return Cons(head.value, rep(list, cnt, i - 1))
            }
        }
    }
    return rep(list, cnt, cnt)
}

ListToString(repli(ListFromString("abc"), 3))

//: Problem 16 (**) Drop every N'th element from a list.

func dropEvery<T>(list: List<T>, _ skip: Int) -> List<T> {
    func drop(list: List<T>, _ skip: Int, _ i: Int) -> List<T> {
        switch list {
        case .Nil:
            return .Nil
        case let .Cons(head, tail):
            if i <= 1 {
                return drop(tail.value, skip, skip)
            } else {
                return Cons(head.value, drop(tail.value, skip, i - 1))
            }
        }
    }
    return drop(list, skip, skip)
}

ListToString(dropEvery(ListFromString("abcdefghik"), 3))

//: Problem 17 (*) Split a list into two parts; the length of the first part is given.

func split<T>(list: List<T>, _ len: Int) -> (List<T>, List<T>) {
    switch list {
    case .Nil:
        return (.Nil, .Nil)
    case let .Cons(head, tail):
        if len <= 0 {
            return (.Nil, list)
        } else {
            let (a, b) = split(tail.value, len - 1)
            return (Cons(head.value, a), b)
        }
    }
}

let (a, b) = split(ListFromString("abcdefghik"), 3)
(ListToString(a), ListToString(b))

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

ListToString(slice(ListFromString("abcdefghik"), 3, 7))

//: Problem 19 (**) Rotate a list N places to the left.
//:
//: Hint: Use the predefined functions length and (++).

func append<T>(list1: List<T>, _ list2: List<T>) -> List<T> {
    guard case let .Cons(head, tail) = list1 else { return list2 }
    return Cons(head.value, append(tail.value, list2))
}

func rotate<T>(list: List<T>, _ cnt: Int) -> List<T> {
    let len = myLength(list)
    let (a, b) = split(list, (cnt % len + len) % len)
    return append(b, a)
}

ListToString(rotate(ListFromString("abcdefgh"), 3))
ListToString(rotate(ListFromString("abcdefgh"), -2))

//: Problem 20 (*) Remove the K'th element from a list.

func removeAt<T>(list: List<T>, _ index: Int) -> (T?, List<T>) {
    let (a, b) = split(list, index - 1)
    let (c, d) = split(b, 1)
    switch c {
    case .Nil:
        return (nil, append(a, d))
    case let .Cons(head, _):
        return (head.value, append(a, d))
    }
}

let (c, d) = removeAt(ListFromString("abcd"), 2)
(c, ListToString(d))

//: [Next](@next)
