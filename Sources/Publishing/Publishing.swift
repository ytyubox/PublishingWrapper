import Combine
@propertyWrapper
@dynamicMemberLookup
public struct Publishing<Value> {
    private let _publisher: CurrentValueSubject<Value, Never>!

    public init(wrappedValue: Value) {
        self._publisher = CurrentValueSubject<Value, Never>(wrappedValue)
    }

    public var wrappedValue: Value {
        get { _publisher.value }
        nonmutating set { _publisher.value = newValue }
    }

    subscript<T>(dynamicMember keyPath: WritableKeyPath<Value, T>) -> T {
        get { _publisher.value[keyPath: keyPath] }
        set { _publisher.value[keyPath: keyPath] = newValue }
    }

    public var projectedValue: Binding<Value> {
        Binding(subject: _publisher)
    }
}

@propertyWrapper
public struct Binding<Value>: Publisher {
    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Value == S.Input {
        _publisher.subscribe(subscriber)
    }

    public typealias Output = Value

    public typealias Failure = Never

    private let _publisher: CurrentValueSubject<Value, Never>!
    public init(subject: CurrentValueSubject<Value, Never>) {
        _publisher = subject
    }

    public init(wrappedValue _: Value) {
        fatalError()
    }

    public var projectedValue: Binding<Value> {
        return self
    }

    public var wrappedValue: Value {
        get { _publisher.value }
        nonmutating set { _publisher.value = newValue }
    }
}
