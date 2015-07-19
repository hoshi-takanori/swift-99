public enum List<T> {
    case Nil
    case Cons(Box<T>, Box<List>)

    public init(_ arr: [T]) {
        self = listFromSlice(arr[0..<arr.count])
    }

    public init(_ args: T...) {
        self = listFromSlice(args[0..<args.count])
    }

    public func map<S>(f: T -> S) -> List<S> {
        switch self {
        case .Nil:
            return List<S>.Nil
        case let .Cons(head, tail):
            return List<S>.Cons(Box(f(head.value)), Box(tail.value.map(f)))
        }
    }

    public func toArray() -> [T] {
        var arr = [T]()
        var list = self
        while case let .Cons(head, tail) = list {
            arr.append(head.value)
            list = tail.value
        }
        return arr
    }
}

public func Cons<T>(head: T, _ tail: List<T>) -> List<T> {
    return .Cons(Box(head), Box(tail))
}

func listFromSlice<T>(arr: ArraySlice<T>) -> List<T> {
    if arr.count == 0 { return List.Nil }
    return Cons(arr[0], listFromSlice(arr[1..<arr.count]))
}

public func ListFromString(str: String) -> List<Character> {
    var arr = [Character]()
    for c in str.characters {
        arr.append(c)
    }
    return listFromSlice(arr[0..<arr.count])
}

// we need to have a protocol to define List<Character>.toString().
// see http://ericasadun.com/2015/06/26/swift-protocol-requirements/

protocol CharacterProtocol {
    var asCharacter: Character { get }
}

extension Character: CharacterProtocol {
    var asCharacter: Character { return self }
}

public extension List where T: CharacterProtocol {
    func toString() -> String {
        var str = ""
        var list = self
        while case let .Cons(head, tail) = list {
            str.append(head.value.asCharacter)
            list = tail.value
        }
        return str
    }
}

public func ListToString(list: List<Character>) -> String {
    return list.toString()
}
