// RUN: %target-parse-verify-swift

protocol P {
  associatedtype A
  func generate() -> Int
}
func f<U: P>(rhs: U) -> X<U.A> { // expected-error {{use of undeclared type 'X'}}
  // FIXME: This diagnostic isn't great, it happens because the generic constraint
  // 'U' from the invalid type signature never gets resolved.
  let g = rhs.generate() // expected-error {{cannot invoke 'generate' with no arguments}}
}

struct Zzz<T> {
  subscript (a: Foo) -> Zzz<T> { // expected-error {{use of undeclared type 'Foo'}}
  get: // expected-error {{expected '{' to start getter definition}}
  set:
    for i in value {}
  }
}

protocol _CollectionType {
  associatedtype Index
  associatedtype _Element
  subscript(i: Index) -> _Element {get}
}

protocol CollectionType : _CollectionType, SequenceType {
  subscript(i: Index) -> Generator.Element {get set }
}
func insertionSort<C: Mutable> (elements: inout C, i: C.Index) { // expected-error {{use of undeclared type 'Mutable'}} expected-error {{'Index' is not a member type of 'C'}}
  var x: C.Generator.Element = elements[i] // expected-error {{'Generator' is not a member type of 'C'}}
}
