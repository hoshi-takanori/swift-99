//: [Previous](@previous)

import Foundation

//: Problem 21 - Insert an element at a given position into a list.

func insertAt<T>(elem: T, _ list: List<T>, _ index: Int) -> List<T> {
    switch list {
    case .Nil:
        return Cons(elem, .Nil)
    case let .Cons(head, tail):
        if index <= 1 {
            return Cons(elem, list)
        } else {
            return Cons(head.value, insertAt(elem, tail.value, index - 1))
        }
    }
}

insertAt("X", ListFromString("abcd"), 1).toString()
insertAt("X", ListFromString("abcd"), 2).toString()
insertAt("X", ListFromString("abcd"), 3).toString()
insertAt("X", ListFromString("abcd"), 4).toString()
insertAt("X", ListFromString("abcd"), 5).toString()

//: Problem 22 - Create a list containing all integers within a given range.

func range(from: Int, _ to: Int) -> List<Int> {
    if from <= to {
        return Cons(from, range(from + 1, to))
    } else {
        return .Nil
    }
}

range(4, 9).toArray()

//: Problem 23 - Extract a given number of randomly selected elements from a list.

func myLength<T>(list: List<T>) -> Int {
    guard case let .Cons(_, tail) = list else { return 0 }
    return 1 + myLength(tail.value)
}

func split<T>(list: List<T>, _ len: Int) -> (List<T>, List<T>) {
    guard case let .Cons(head, tail) = list where len > 0 else { return (.Nil, list) }
    let (a, b) = split(tail.value, len - 1)
    return (Cons(head.value, a), b)
}

func append<T>(list1: List<T>, _ list2: List<T>) -> List<T> {
    guard case let .Cons(head, tail) = list1 else { return list2 }
    return Cons(head.value, append(tail.value, list2))
}

func removeAt<T>(list: List<T>, _ index: Int) -> (T?, List<T>) {
    let (a, b) = split(list, index - 1)
    guard case let .Cons(head, tail) = b where index > 0 else { return (nil, append(a, b)) }
    return (head.value, append(a, tail.value))
}

func rnd_select<T>(list: List<T>, _ cnt: Int) -> List<T> {
    guard case .Cons(_, _) = list where cnt > 0 else { return .Nil }
    let (a, b) = removeAt(list, Int(arc4random_uniform(UInt32(myLength(list)))) + 1)
    return Cons(a!, rnd_select(b, cnt - 1))
}

rnd_select(ListFromString("abcdefgh"), 3).toString()

//: Problem 24 - Lotto: Draw N different random numbers from the set 1..M.

func diff_select(cnt: Int, _ max: Int) -> List<Int> {
    return rnd_select(range(1, max), cnt)
}

diff_select(6, 49).toArray()

//: Problem 25 - Generate a random permutation of the elements of a list.

func rnd_permu<T>(list: List<T>) -> List<T> {
    return rnd_select(list, myLength(list))
}

rnd_permu(ListFromString("abcdef")).toString()

//: Problem 26 (**) Generate the combinations of K distinct objects chosen
//: from the N elements of a list.

func appendAll<T>(list: List<List<T>>) -> List<T> {
    guard case let .Cons(head, tail) = list else { return .Nil }
    return append(head.value, appendAll(tail.value))
}

func combinations<T>(cnt: Int, _ list: List<T>) -> List<List<T>> {
    if cnt <= 0 {
        return Cons(.Nil, .Nil)
    } else {
        return appendAll(range(1, myLength(list)).map {
            let (_, b) = split(list, $0 - 1)
            guard case let .Cons(head, tail) = b else { return .Nil }
            return combinations(cnt - 1, tail.value).map{Cons(head.value, $0)}
        })
    }
}

combinations(1, ListFromString("abc")).map(ListToString).toArray()
combinations(2, ListFromString("abc")).map(ListToString).toArray()
combinations(3, ListFromString("abc")).map(ListToString).toArray()

combinations(3, ListFromString("abcdef")).map(ListToString).toArray()

//: Problem 27 - Group the elements of a set into disjoint subsets.

func group<T>(cnts: List<Int>, _ list: List<T>) -> List<List<List<T>>> {
    func group1(cnt: Int, _ list: List<T>) -> List<(List<T>, List<T>, List<T>)> {
        if cnt <= 0 {
            return Cons((.Nil, .Nil, list), .Nil)
        } else {
            let list2 = range(0, myLength(list) - cnt).map { index -> (T?, List<T>, List<T>) in
                let (a, b) = split(list, index)
                guard case let .Cons(head, tail) = b else { return (nil, a, .Nil) }
                return (head.value, a, tail.value)
            }
            if cnt == 1 {
                return list2.map{(Cons($0.0!, .Nil), $0.1, $0.2)}
            } else {
                return appendAll(list2.map { tuple in
                    group1(cnt - 1, tuple.2).map{(Cons(tuple.0!, $0.0), append(tuple.1, $0.1), $0.2)}
                })
            }
        }
    }
    switch cnts {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        switch tail.value {
        case .Nil:
            return group1(head.value, list).map{Cons($0.0, .Nil)}
        case .Cons(_, _):
            return appendAll(group1(head.value, list).map { tuple in
                group(tail.value, append(tuple.1, tuple.2)).map{Cons(tuple.0, $0)}
            })
        }
    }
}

let g = group(List(2, 2, 2), ListFromString("abcdef")).map{$0.map(ListToString).toArray()}.toArray()
g.count
g

/*
let g1 = group(List(2, 3, 4), List("aldo", "beat", "carla", "david", "evi", "flip", "gary", "hugo", "ida"))
myLength(g1)

let g2 = group(List(2, 2, 5), List("aldo", "beat", "carla", "david", "evi", "flip", "gary", "hugo", "ida"))
myLength(g2)
*/

//: Problem 28 - Sorting a list of lists according to length of sublists.

func sort<T>(list: List<T>, _ less: (T, T) -> Bool) -> List<T> {
    func sort1(elem: T, _ list: List<T>, _ less: (T, T) -> Bool) -> List<T> {
        switch list {
        case .Nil:
            return Cons(elem, .Nil)
        case let .Cons(head, tail):
            if less(head.value, elem) {
                return Cons(head.value, sort1(elem, tail.value, less))
            } else {
                return Cons(elem, list)
            }
        }
    }
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        return sort1(head.value, sort(tail.value, less), less)
    }
}

func lsort<T>(list: List<List<T>>) -> List<List<T>> {
    let list2 = list.map{(myLength($0), $0)}
    return sort(list2){$0.0 < $1.0}.map{$0.1}
}

lsort(List("abc", "de", "fgh", "de", "ijkl", "mn", "o").map(ListFromString)).map(ListToString).toArray()

func encodeDirect<T: Comparable>(list: List<T>) -> List<(Int, T)> {
    guard case let .Cons(head, tail) = list else { return .Nil }
    let encoded = encodeDirect(tail.value)
    guard case let .Cons(code, tail2) = encoded where code.value.1 == head.value
        else { return Cons((1, head.value), encoded) }
    return Cons((code.value.0 + 1, code.value.1), tail2.value)
}

func find<T>(list: List<T>, _ pred: T -> Bool) -> T? {
    guard case let .Cons(head, tail) = list else { return nil }
    return pred(head.value) ? head.value : find(tail.value, pred)
}

func lfsort<T>(list: List<List<T>>) -> List<List<T>> {
    let list2 = list.map{(myLength($0), $0)}
    let cnts = encodeDirect(sort(list2.map{$0.0}){$0 < $1})
    func cntOf(len: Int) -> Int { return find(cnts){$0.1 == len}!.0 }
    let list3 = list2.map{(cntOf($0.0), $0.1)}
    return sort(list3){$0.0 < $1.0}.map{$0.1}
}

lfsort(List("abc", "de", "fgh", "de", "ijkl", "mn", "o").map(ListFromString)).map(ListToString).toArray()

//: [Next](@next)
