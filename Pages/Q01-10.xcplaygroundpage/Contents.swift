//: [Previous](@previous)

//: Problem 1 (*) Find the last element of a list.

func myLast<T>(list: List<T>) -> T? {
    return nil
}

myLast(List<Int>())
myLast(List(1, 2, 3, 4))
myLast(List("x", "y", "z"))

//: Problem 2 (*) Find the last but one element of a list.

func myButLast<T>(list: List<T>) -> T? {
    return nil
}

myButLast(List<Int>())
myButLast(List(1))
myButLast(List(1, 2))
myButLast(List(1, 2, 3))
myButLast(List(1, 2, 3, 4))
myButLast(List("x", "y", "z"))

//: Problem 3 (*) Find the K'th element of a list.
//: The first element in the list is number 1.

func elementAt<T>(list: List<T>, _ index: Int) -> T? {
    return nil
}

elementAt(List(1, 2, 3, 4), 2)
elementAt(ListFromString("Swift"), 5)

//: Problem 4 (*) Find the number of elements of a list.

func myLength<T>(list: List<T>) -> Int {
    return 0
}

myLength(List(123, 456, 789))
myLength(ListFromString("Hello, world!"))

//: Problem 5 (*) Reverse a list.

func myReverse<T>(list: List<T>) -> List<T> {
    return .Nil
}

ListToString(myReverse(ListFromString("A man, a plan, a canal, panama!")))
myReverse(List(1, 2, 3, 4)).toArray()

//: Problem 6 (*) Find out whether a list is a palindrome.
//: A palindrome can be read forward or backward; e.g. (x a m a x).

func isPalindrome<T: Comparable>(list: List<T>) -> Bool {
    return false
}

isPalindrome(List(1, 2, 3))
isPalindrome(ListFromString("madamimadam"))
isPalindrome(List(1, 2, 4, 8, 16, 8, 4, 2, 1))

//: Problem 7 (**) Flatten a nested list structure.
//:
//: Transform a list, possibly holding lists as elements into a `flat' list
//: by replacing each list with its elements (recursively).

enum Nest<T> {
    case Elem(Wrap<T>)
    case NestedList(List<Nest>)

    init(_ args: Nest<T>...) { self = .NestedList(List(args)) }
}

func Elem<T>(value: T) -> Nest<T> {
    return .Elem(Wrap(value))
}

func append<T>(list1: List<T>, _ list2: List<T>) -> List<T> {
    return .Nil
}

append(List(1, 2, 3), List(4, 5, 6)).toArray()

func appendAll<T>(list: List<List<T>>) -> List<T> {
    return .Nil
}

appendAll(List(List(1, 2, 3), List(4, 5, 6), List(7, 8, 9))).toArray()

func flatten<T>(nest: Nest<T>) -> List<T> {
    return .Nil
}

flatten(Elem(5)).toArray()
flatten(Nest(Elem(1), Elem(2), Elem(3))).toArray()
flatten(Nest(Nest(Elem(1)))).toArray()
flatten(Nest(Elem(1), Nest(Elem(2), Nest(Elem(3))))).toArray()
flatten(Nest(Nest(Nest(Elem(1)), Elem(2)), Elem(3))).toArray()

flatten(Nest(Elem("A"))).toArray()
flatten(Nest(Nest(Elem("C"), Elem("D")))).toArray()
flatten(Nest(Elem("B"), Nest(Elem("C"), Elem("D")), Elem("E"))).toArray()
flatten(Nest(Elem("A"), Nest(Elem("B"), Nest(Elem("C"), Elem("D")), Elem("E")))).toArray()

flatten(Nest<Int>()).toArray()

//: Problem 8 (**) Eliminate consecutive duplicates of list elements.
//:
//: If a list contains repeated elements they should be replaced with a single
//: copy of the element. The order of the elements should not be changed.

func compress<T: Comparable>(list: List<T>) -> List<T> {
    return .Nil
}

ListToString(compress(ListFromString("aaaabccaadeeee")))

//: Problem 9 (**) Pack consecutive duplicates of list elements into sublists.
//: If a list contains repeated elements they should be placed in separate sublists.

func pack<T: Comparable>(list: List<T>) -> List<List<T>> {
    return .Nil
}

pack(ListFromString("aaaabccaadeeee")).map(ListToString).toArray()

//: Problem 10 (*) Run-length encoding of a list. Use the result of problem P09
//: to implement the so-called run-length encoding data compression method.
//: Consecutive duplicates of elements are encoded as lists (N E) where N is the
//: number of duplicates of the element E.

func encode<T: Comparable>(list: List<T>) -> List<(Int, T)> {
    return .Nil
}

encode(ListFromString("aaaabccaadeeee")).toArray()

//: [Next](@next)
