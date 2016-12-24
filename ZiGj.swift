func terminal_handler(e: String, test: String, msg: String) {
    switch e {
        case "pass":
            print("\u{001B}[0;32m✔ " + test + ": " + msg)
        case "fail", "except":
            print("\u{001B}[0;31m✘ " + test + ": " + msg)
        default:
            fatalError("\u{001B}[0;31mError: unknown value `\(e)`.\n" +
                       "\u{001B}[0;31mPlease report a bug.")
    }
}


// `deepeq` currently only applies to the following type
//
// - Built in Equatable `==`, e.g. numbers, strings and sets;
// - Array with Equatable elements `[Equatable]`;
// - Flat dictionaries with Equatable values `[Hashable: Equatable]`.
func deepeq<T: Equatable>(_ a: T,  _ b: T) -> Bool {
    let a = a as T
    let b = b as T
    return a == b
}

func deepeq<E: Equatable>(_ a: [E], _ b: [E]) -> Bool {
    if a.count != b.count {
        return false
    } else {
        for i in a.indices {
            if a[i] != b[i] {
                return false
            } else {
                // next
            }
        }
        return true
    }
}

func deepeq<V: Equatable, K: Hashable>(_ a: [K: V], _ b: [K: V]) -> Bool {
    if a.count != b.count {
        return false
    } else {
        for (k, v) in a {
            if let bk = b[k] {
                if v != bk {
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }
}


// An error to represent no error.
class ZiGjNoError: ErrorProtocol {}
// Swift does not have a Null type.
class Null {}


class Spy {
    var called: [[Any]] = []
    var thrown: [ErrorProtocol] = []

    // A spy wraps a normal function
    // but remembers function calls and thrown exceptions.
    //
    // Swift does not have a callable protocol.
    // Thus we only supports spying functions:
    //
    // - with zero parameter;
    // - with one to five implicit parameter,
    //     whose value cannot be nil.
    //
    // Extend this Spy class to support functions
    // with more implicit parameters is easy,
    // just overload `spy(_:)`.
    // Extend to support functions accepting nil parameter is easy too,
    // but we think almost all functions should not accept nil.
    // If you want to spy functions with explicit parameters,
    // you need to wrap them into a function with implicit parameters,
    // probably a function accepting a dictionary.
    // Since Swift does not support applying or splatting parameters,
    // We do not support to spy a variadic function.
    // If you want to spy one, you need to wrap it into a function
    // accepting an array.
    //
    // Spy without an underlying function behaves like a function
    // that returns an instance of an empty class .
    //
    //
    // We return `() -> T?`,
    // but we really want to return something like
    // `() -> (T? | NoneResult)` if Swift has union types.
    func spy<T>(_ f: () throws -> T?) -> () -> T? {
        let s = { () -> T? in
            self.called.append([])
            do {
                let result: T? = try f()
                self.thrown.append(ZiGjNoError())
                return result
            } catch let error {
                self.thrown.append(error)
                return nil
            }
        }
        return s
    }
    func spy() -> () -> Null {
        let s = { () -> Null in
            self.called.append([])
            self.thrown.append(ZiGjNoError())
            return Null()
        }
        return s
    }
    func spy<T, U>(_ f: U throws -> T?) -> U -> T? {
        let s = { (arg1: U) -> T? in
            self.called.append([arg1])
            do {
                let result: T? = try f(arg1)
                self.thrown.append(ZiGjNoError())
                return result
            } catch let error {
                self.thrown.append(error)
                return nil
            }
        }
        return s
    }
    func spy<U>(_ arg1: U) -> U -> Null {
        let s = { (arg1: U) -> Null in
            self.called.append([arg1])
            self.thrown.append(ZiGjNoError())
            return Null()
        }
        return s
    }
    func spy<T, U, V>(_ f: (U, V) throws -> T?) -> (U, V) -> T? {
        let s = { (arg1: U, arg2: V) -> T? in
            self.called.append([arg1, arg2])
            do {
                let result: T? = try f(arg1, arg2)
                self.thrown.append(ZiGjNoError())
                return result
            } catch let error {
                self.thrown.append(error)
                return nil
            }
        }
        return s
    }
    func spy<U, V>(_ arg1: U, _ arg2: V) -> (U, V) -> Null {
        let s = { (arg1: U, arg2: V) -> Null in
            self.called.append([arg1, arg2])
            self.thrown.append(ZiGjNoError())
            return Null()
        }
        return s
    }
    func spy<T, U, V, W>(_ f: (U, V, W) throws -> T?) -> (U, V, W) -> T? {
        let s = { (arg1: U, arg2: V, arg3: W) -> T? in
            self.called.append([arg1, arg2, arg3])
            do {
                let result: T? = try f(arg1, arg2, arg3)
                self.thrown.append(ZiGjNoError())
                return result
            } catch let error {
                self.thrown.append(error)
                return nil
            }
        }
        return s
    }
    func spy<U, V, W>(_ arg1: U, _ arg2: V, _ arg3: W) -> (U, V, W) -> Null {
        let s = { (arg1: U, arg2: V, arg3: W) -> Null in
            self.called.append([arg1, arg2, arg3])
            self.thrown.append(ZiGjNoError())
            return Null()
        }
        return s
    }
    func spy<T, U, V, W, X>(_ f: (U, V, W, X) throws -> T?)
            -> (U, V, W, X) -> T? {
        let s = { (arg1: U, arg2: V, arg3: W, arg4: X) -> T? in
            self.called.append([arg1, arg2, arg3, arg4])
            do {
                let result: T? = try f(arg1, arg2, arg3, arg4)
                self.thrown.append(ZiGjNoError())
                return result
            } catch let error {
                self.thrown.append(error)
                return nil
            }
        }
        return s
    }
    func spy<U, V, W, X>(_ arg1: U, _ arg2: V, _ arg3: W, _ arg4: X)
            -> (U, V, W, X) -> Null {
        let s = { (arg1: U, arg2: V, arg3: W, arg4: X) -> Null in
            self.called.append([arg1, arg2, arg3, arg4])
            self.thrown.append(ZiGjNoError())
            return Null()
        }
        return s
    }
    func spy<T, U, V, W, X, Y>(_ f: (U, V, W, X, Y) throws -> T?)
                              -> (U, V, W, X, Y) -> T? {
        let s = { (arg1: U, arg2: V, arg3: W, arg4: X, arg5: Y) -> T? in
            self.called.append([arg1, arg2, arg3, arg4, arg5])
            do {
                let result: T? = try f(arg1, arg2, arg3, arg4, arg5)
                self.thrown.append(ZiGjNoError())
                return result
            } catch let error {
                self.thrown.append(error)
                return nil
            }
        }
        return s
    }
    func spy<U, V, W, X, Y>(
        _ arg1: U, _ arg2: V, _ arg3: W, _ arg4: X, _arg5: Y
        ) -> (U, V, W, X, Y) -> Null {
        let s = { (arg1: U, arg2: V, arg3: W, arg4: X, arg5: Y) -> Null in
            self.called.append([arg1, arg2, arg3, arg4, arg5])
            self.thrown.append(ZiGjNoError())
            return Null()
        }
        return s
    }
}


class ZiGj {
    var pendingTests: [(() -> Void) -> Void] = [];
    func handler(e: String, test: String, msg: String) {
        terminal_handler(e: e, test: test, msg: msg)
    }
    func runNextTest() {
        if let toRunTest = pendingTests.first {
                toRunTest(runNextTest)
        } else {
            // Currently there is no async test to run.
        }
    }

    // There are two differences between this api to gambiarra and klud:
    //
    // 1. We changed `name, f, async` to `name, async, f` to utilize
    //     Swift's trailing closure syntax sugar.
    //     For example:
    //
    //     ```swift
    //     test("A doublethink test") {
    //         ok(2 + 2 == 5, "two plus two equals five")
    //     }
    //     ```
    //
    //     Accordingly, we make `async` an explicit parameter,
    //     because `test("Test something", false) { ...}` may be mistakenly
    //     considered as equivalent something to`assertFailure`.
    //
    // 2. Gambiarra and klud override test to customize reporter,
    //     (and even the test api, which is undocumented).
    //     We do not provide this feature.
    //     To customize reporter or extend api, just extend this class.
    func test(_ name: String, async: true, _ f: () -> Void) {
        // TODO
    }
}



// TODO
func ok(@autoclosure cond: () -> Bool, msg: String = "", line: Int = #line) {
    let message: String
    if msg.isEmpty {
        message = "\(line)"
    } else {
        message = msg
    }
    if cond() {
        handler(e: "pass", msg: message)
    } else {
        handler(e: "fail", msg: message)
    }
}
