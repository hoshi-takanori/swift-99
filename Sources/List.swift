// we need to use switch instead of guard/if/while until next beta.
// https://forums.developer.apple.com/message/31981

public enum List<T> {
    case Nil
    indirect case Cons(T, List)

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
            return List<S>.Cons(f(head), tail.map(f))
        }
    }

    public func reduce<S>(zero: S, _ f: (S, T) -> S) -> S {
        switch self {
        case .Nil:
            return zero
        case let .Cons(head, tail):
            return tail.reduce(f(zero, head), f)
        }
    }

    public func forEach(f: T -> ()) {
        switch self {
        case .Nil:
            break
        case let .Cons(head, tail):
            f(head)
            tail.forEach(f)
        }
    }

    public func toArray() -> [T] {
        var arr = [T]()
        self.forEach{arr.append($0)}
        return arr
    }
}

func listFromSlice<T>(arr: ArraySlice<T>) -> List<T> {
    if arr.count == 0 { return List.Nil }
    return .Cons(arr[0], listFromSlice(arr[1..<arr.count]))
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
        self.forEach{str.append($0.asCharacter)}
        return str
    }
}

public func ListToString(list: List<Character>) -> String {
    return list.toString()
}
