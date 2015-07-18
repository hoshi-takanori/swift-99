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

func encodeModified<T: Comparable>(list: List<T>) -> List<Code<T>> {
    return .Nil
}

encodeModified(ListFromString("aaaabccaadeeee")).toArray()

//: Problem 12 (**) Decode a run-length encoded list.
//:
//: Given a run-length code list generated as specified in problem 11.
//: Construct its uncompressed version.

func decodeModified<T>(list: List<Code<T>>) -> List<T> {
    return .Nil
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
    return .Nil
}

encodeDirect(ListFromString("aaaabccaadeeee")).toArray()

decodeModified(encodeDirect(ListFromString("aaaabccaadeeee"))).toString()

//: Problem 14 (*) Duplicate the elements of a list.

func dupli<T>(list: List<T>) -> List<T> {
    return .Nil
}

dupli(List(1, 2, 3)).toArray()

//: Problem 15 (**) Replicate the elements of a list a given number of times.

func repli<T>(list: List<T>, _ cnt: Int) -> List<T> {
    return .Nil
}

repli(ListFromString("abc"), 3).toString()

//: Problem 16 (**) Drop every N'th element from a list.

func dropEvery<T>(list: List<T>, _ skip: Int) -> List<T> {
    return .Nil
}

dropEvery(ListFromString("abcdefghik"), 3).toString()

//: Problem 17 (*) Split a list into two parts; the length of the first part is given.

func split<T>(list: List<T>, _ len: Int) -> (List<T>, List<T>) {
    return (.Nil, .Nil)
}

let (a, b) = split(ListFromString("abcdefghik"), 3)
(a.toString(), b.toString())

//: Problem 18 (**) Extract a slice from a list.
//:
//: Given two indices, i and k, the slice is the list containing the elements
//: between the i'th and k'th element of the original list (both limits included).
//: Start counting the elements with 1.

func slice<T>(list: List<T>, _ start: Int, _ end: Int) -> List<T> {
    return .Nil
}

slice(ListFromString("abcdefghik"), 3, 7).toString()

//: Problem 19 (**) Rotate a list N places to the left.
//:
//: Hint: Use the predefined functions length and (++).

func rotate<T>(list: List<T>, _ cnt: Int) -> List<T> {
    return .Nil
}

rotate(ListFromString("abcdefgh"), 3).toString()
rotate(ListFromString("abcdefgh"), -2).toString()

//: Problem 20 (*) Remove the K'th element from a list.

func removeAt<T>(list: List<T>, _ index: Int) -> (T?, List<T>) {
    return (nil, .Nil)
}

let (c, d) = removeAt(ListFromString("abcd"), 2)
(c, d.toString())

//: [Next](@next)
