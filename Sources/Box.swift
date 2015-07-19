// we need to have a wrapper class to define a recursive enum List<T>.
// see http://www.quora.com/How-can-enumerations-in-Swift-be-recursive

public final class Box<T> {
    public let value: T

    public init(_ value: T) {
        self.value = value
    }
}
