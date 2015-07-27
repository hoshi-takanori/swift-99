//: [Previous](@previous)

import Foundation

//: Problem 21 - Insert an element at a given position into a list.

func insertAt<T>(elem: T, _ list: List<T>, _ index: Int) -> List<T> {
    switch list {
    case .Nil:
        return .Cons(elem, .Nil)
    case let .Cons(head, tail):
        if index <= 1 {
            return .Cons(elem, list)
        } else {
            return .Cons(head, insertAt(elem, tail, index - 1))
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
        return .Cons(from, range(from + 1, to))
    } else {
        return .Nil
    }
}

range(4, 9).toArray()

//: Problem 23 - Extract a given number of randomly selected elements from a list.

func myLength<T>(list: List<T>) -> Int {
    return list.reduce(0) {(n, m) in n + 1}
}

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

func append<T>(list1: List<T>, _ list2: List<T>) -> List<T> {
    return list1.reduce(list2) {.Cons($1, $0)}
}

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

func rnd_select<T>(list: List<T>, _ cnt: Int) -> List<T> {
    switch list {
    case .Nil:
        return .Nil
    case .Cons(_, _):
        if cnt <= 0 {
            return .Nil
        } else {
            let (a, b) = removeAt(list, Int(arc4random_uniform(UInt32(myLength(list)))) + 1)
            return .Cons(a!, rnd_select(b, cnt - 1))
        }
    }
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
    return list.reduce(.Nil) {append($1, $0)}
}

func combinations<T>(cnt: Int, _ list: List<T>) -> List<List<T>> {
    if cnt <= 0 {
        return .Cons(.Nil, .Nil)
    } else {
        return appendAll(range(1, myLength(list)).map {
            let (_, b) = split(list, $0 - 1)
            switch b {
            case .Nil:
                return .Nil
            case let .Cons(head, tail):
                return combinations(cnt - 1, tail).map{.Cons(head, $0)}
            }
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
            return .Cons((.Nil, .Nil, list), .Nil)
        } else {
            let list2 = range(0, myLength(list) - cnt).map { index -> (T?, List<T>, List<T>) in
                let (a, b) = split(list, index)
                switch b {
                case .Nil:
                    return (nil, a, .Nil)
                case let .Cons(head, tail):
                    return (head, a, tail)
                }
            }
            if cnt == 1 {
                return list2.map{(.Cons($0.0!, .Nil), $0.1, $0.2)}
            } else {
                return appendAll(list2.map { tuple in
                    group1(cnt - 1, tuple.2).map{(.Cons(tuple.0!, $0.0), append(tuple.1, $0.1), $0.2)}
                })
            }
        }
    }
    switch cnts {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        switch tail {
        case .Nil:
            return group1(head, list).map{.Cons($0.0, .Nil)}
        case .Cons(_, _):
            return appendAll(group1(head, list).map { tuple in
                group(tail, append(tuple.1, tuple.2)).map{.Cons(tuple.0, $0)}
            })
        }
    }
}

let g = group(List(2, 3), ListFromString("abcde")).map{$0.map(ListToString).toArray()}.toArray()
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
            return .Cons(elem, .Nil)
        case let .Cons(head, tail):
            if less(head, elem) {
                return .Cons(head, sort1(elem, tail, less))
            } else {
                return .Cons(elem, list)
            }
        }
    }
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        return sort1(head, sort(tail, less), less)
    }
}

func lsort<T>(list: List<List<T>>) -> List<List<T>> {
    let list2 = list.map{(myLength($0), $0)}
    return sort(list2){$0.0 < $1.0}.map{$0.1}
}

lsort(List("abc", "de", "fgh", "de", "ijkl", "mn", "o").map(ListFromString)).map(ListToString).toArray()

func encodeDirect<T: Comparable>(list: List<T>) -> List<(Int, T)> {
    switch list {
    case .Nil:
        return .Nil
    case let .Cons(head, tail):
        let encoded = encodeDirect(tail)
        switch encoded {
        case .Nil:
            return .Nil
        case let .Cons((cnt, value), tail2):
            if value == head {
                return .Cons((1, head), encoded)
            } else {
                return .Cons((cnt + 1, value), tail2)
            }
        }
    }
}

func find<T>(list: List<T>, _ pred: T -> Bool) -> T? {
    switch list {
    case .Nil:
        return nil
    case let .Cons(head, tail):
        return pred(head) ? head : find(tail, pred)
    }
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
