//: [Previous](@previous)

import Foundation

//: Problem 21 - Insert an element at a given position into a list.

func insertAt<T>(elem: T, _ list: List<T>, _ index: Int) -> List<T> {
    return .Nil
}

insertAt("X", ListFromString("abcd"), 1).toString()
insertAt("X", ListFromString("abcd"), 2).toString()
insertAt("X", ListFromString("abcd"), 3).toString()
insertAt("X", ListFromString("abcd"), 4).toString()
insertAt("X", ListFromString("abcd"), 5).toString()

//: Problem 22 - Create a list containing all integers within a given range.

func range(from: Int, _ to: Int) -> List<Int> {
    return .Nil
}

range(4, 9).toArray()

//: Problem 23 - Extract a given number of randomly selected elements from a list.

func rnd_select<T>(list: List<T>, _ cnt: Int) -> List<T> {
    return .Nil
}

rnd_select(ListFromString("abcdefgh"), 3).toString()

//: Problem 24 - Lotto: Draw N different random numbers from the set 1..M.

func diff_select(cnt: Int, _ max: Int) -> List<Int> {
    return .Nil
}

diff_select(6, 49).toArray()

//: Problem 25 - Generate a random permutation of the elements of a list.

func rnd_permu<T>(list: List<T>) -> List<T> {
    return .Nil
}

rnd_permu(ListFromString("abcdef")).toString()

//: Problem 26 (**) Generate the combinations of K distinct objects chosen
//: from the N elements of a list.

func combinations<T>(cnt: Int, _ list: List<T>) -> List<List<T>> {
    return .Nil
}

combinations(1, ListFromString("abc")).map(ListToString).toArray()
combinations(2, ListFromString("abc")).map(ListToString).toArray()
combinations(3, ListFromString("abc")).map(ListToString).toArray()

combinations(3, ListFromString("abcdef")).map(ListToString).toArray()

//: Problem 27 - Group the elements of a set into disjoint subsets.

func group<T>(cnts: List<Int>, _ list: List<T>) -> List<List<List<T>>> {
    return .Nil
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

func lsort<T>(list: List<List<T>>) -> List<List<T>> {
    return .Nil
}

lsort(List("abc", "de", "fgh", "de", "ijkl", "mn", "o").map(ListFromString)).map(ListToString).toArray()

func lfsort<T>(list: List<List<T>>) -> List<List<T>> {
    return .Nil
}

lfsort(List("abc", "de", "fgh", "de", "ijkl", "mn", "o").map(ListFromString)).map(ListToString).toArray()

//: [Next](@next)
