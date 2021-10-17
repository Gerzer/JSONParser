//
//  JSONProvider.swift
//  JSONParser
//
//  Created by Gabriel Jacoby-Cooper on 11/23/20.
//

import Foundation

/// A protocol to which types that can provide JSON  data to be parsed conform.
public protocol JSONProvider {
	
	associatedtype InternalJSONParser: JSONParser
	
	typealias Key = InternalJSONParser.Key
	
	/// The underlying JSON parser instance.
	var parser: InternalJSONParser? { get }
	
	subscript(arrayAt key: Key) -> ArrayJSONParser? { get }
	
	subscript(dictionaryAt key: Key) -> DictionaryJSONParser? { get }
	
	subscript<Value>(_: Key, as _: Value.Type) -> Value? where Value: JSONValue { get }
	
}

/// A JSON provider that supports iteration.
public protocol IterableJSONProvider: JSONProvider {
	
	/// Iterate over the elements in the JSON data.
	func iterate(_ closure: (JSONProxy<Key>) throws -> Void) throws
	
}

public extension JSONProvider {
	
	subscript(arrayAt key: Key) -> ArrayJSONParser? {
		guard let newData = try? self.parser?.get(dataAt: key, asCollection: [Any].self) else {
			return nil
		}
		return ArrayJSONParser(newData)
	}
	
	subscript(dictionaryAt key: Key) -> DictionaryJSONParser? {
		guard let newData = try? self.parser?.get(dataAt: key, asCollection: [String: Any].self) else {
			return nil
		}
		return DictionaryJSONParser(newData)
	}
	
	subscript<Value>(_ key: Key, as _: Value.Type) -> Value? where Value: JSONValue {
		return try? self.parser?.get(valueAt: key, as: Value.self)
	}
	
}

public extension IterableJSONProvider where InternalJSONParser == ArrayJSONParser {
	
	/// Iterate over the elements in the JSON array.
	/// - Parameter closure: A closure that takes a `JSONProxy<Int>` instance as input, which contains both the key and the value at each iteration time-step.
	func iterate(_ closure: (JSONProxy<Int>) throws -> Void) throws {
		guard let parser = self.parser else {
			throw JSONError.failedIteration
		}
		try parser.iterate(closure)
	}
	
}

public extension IterableJSONProvider where InternalJSONParser == DictionaryJSONParser {
	
	/// Iterate over the elements in the JSON dictionary.
	/// - Parameter closure: A closure that takes a `JSONProxy<String>` instance as input, which contains both the key and the value at each iteration time-step.
	func iterate(_ closure: (JSONProxy<String>) throws -> Void) throws {
		guard let parser = self.parser else {
			throw JSONError.failedIteration
		}
		try parser.iterate(closure)
	}
	
}

/// A representation of the underlying data for a JSON array.
public struct ArrayData: IterableJSONProvider {
	
	/// The underlying data.
	private let data: Data
	
	/// The JSON parser.
	public var parser: ArrayJSONParser? {
		get {
			return ArrayJSONParser(self.data)
		}
	}
	
	/// Create an `ArrayData` instance from raw bytes.
	/// - Parameter data: The raw data.
	fileprivate init(_ data: Data) {
		self.data = data
	}
	
}

/// A representation of the underlying data for a JSON array.
public struct DictionaryData: IterableJSONProvider {
	
	/// The underlying data.
	private let data: Data
	
	/// The JSON parser.
	public var parser: DictionaryJSONParser? {
		get {
			return DictionaryJSONParser(self.data)
		}
	}
	
	/// Create a `DictionaryData` instance from raw bytes.
	/// - Parameter data: The raw data.
	fileprivate init(_ data: Data) {
		self.data = data
	}
	
}

public extension Data {
	
	var arrayData: ArrayData {
		get {
			return ArrayData(self)
		}
	}
	
	var dictionaryData: DictionaryData {
		get {
			return DictionaryData(self)
		}
	}
	
	var arrayParser: ArrayJSONParser? {
		get {
			return self.arrayData.parser
		}
	}
	
	var dictionaryParser: DictionaryJSONParser? {
		get {
			return self.dictionaryData.parser
		}
	}
	
}

extension Array: IterableJSONProvider {
	
	/// A JSON parser for this array.
	public var parser: ArrayJSONParser? {
		get {
			guard let data = try? JSONSerialization.data(withJSONObject: self) else {
				return nil
			}
			return ArrayJSONParser(data)
		}
	}
	
}

extension Dictionary: JSONProvider, IterableJSONProvider where Key == String {
	
	/// A JSON parser for this dictionary.
	public var parser: DictionaryJSONParser? {
		get {
			guard let data = try? JSONSerialization.data(withJSONObject: self) else {
				return nil
			}
			return DictionaryJSONParser(data)
		}
	}
	
}

extension Set: IterableJSONProvider {
	
	/// A JSON parser for this set.
	public var parser: ArrayJSONParser? {
		get {
			return Array(self).parser
		}
	}
	
}
