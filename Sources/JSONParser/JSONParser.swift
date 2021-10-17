//
//  JSONParser.swift
//  JSONParser
//
//  Created by Gabriel Jacoby-Cooper on 10/9/20.
//

import Foundation

/// The protocol to which all concrete JSON parser types conform.
public protocol JSONParser {
	
	associatedtype Key: JSONKey
	
	associatedtype InternalCollection: Collection
	
	/// The underlying data in raw bytes.
	var data: Data { get }
	
	/// Create a parser from raw bytes.
	init(_: Data)
	
	subscript(arrayAt key: Key) -> ArrayJSONParser? { get }
	
	subscript(dictionaryAt key: Key) -> DictionaryJSONParser? { get }
	
	subscript<Value>(_: Key, as _: Value.Type) -> Value? where Value: JSONValue { get }
	
	/// Get the value that's associated with a particular key.
	/// - Returns: The value.
	func get<Value>(valueAt: Key, as: Value.Type) throws -> Value where Value: JSONValue
	
	/// Get the value that's associated with a particular key as re-serialized data.
	/// - Returns: The re-serialized data.
	func get<Value>(dataAt: Key, asCollection: Value.Type) throws -> Data where Value: Collection
	
	/// Parses the underlying data.
	/// - Returns: A type-erased `Collection` instance.
	func parse() throws -> InternalCollection
	
}

/// A JSON parser that supports iteration.
public protocol IterableJSONParser: JSONParser {
	
	/// Iterate over the elements in the JSON data.
	func iterate(_ closure: (JSONProxy<Key>) throws -> Void) throws
	
}

public extension JSONParser {
	
	subscript(arrayAt key: Key) -> ArrayJSONParser? {
		guard let newData = try? self.get(dataAt: key, asCollection: [Any].self) else {
			return nil
		}
		return ArrayJSONParser(newData)
	}
	
	subscript(dictionaryAt key: Key) -> DictionaryJSONParser? {
		guard let newData = try? self.get(dataAt: key, asCollection: [String: Any].self) else {
			return nil
		}
		return DictionaryJSONParser(newData)
	}
	
	subscript<Value>(_ key: Key, as _: Value.Type) -> Value? where Value: JSONValue {
		return try? self.get(valueAt: key, as: Value.self)
	}
	
}

/// A JSON array parser.
public struct ArrayJSONParser: IterableJSONParser {
	
	/// The underlying data.
	public let data: Data
	
	/// Create an array parser from raw bytes.
	/// - Parameter data: The raw data.
	public init(_ data: Data) {
		self.data = data
	}
	
	/// Create an array parser from an array.
	init?(_ array: [Any]) {
		guard let data = try? JSONSerialization.data(withJSONObject: array) else {
			return nil
		}
		self.init(data)
	}
	
	/// Get the value that's associated with a particular key.
	/// - Returns: The value.
	public func get<Value>(valueAt key: Int, as: Value.Type) throws -> Value where Value: JSONValue {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let array = object as? [Any] else {
			throw JSONError.inavlidData
		}
		guard array.indices.contains(key) else {
			throw JSONError.invalidKey
		}
		guard let value = array[key] as? Value else {
			throw JSONError.invalidType
		}
		return value
	}
	
	/// Get the value that's associated with a particular key as re-serialized data.
	/// - Returns: The re-serialized data.
	public func get<Value>(dataAt key: Int, asCollection: Value.Type) throws -> Data where Value: Collection {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let array = object as? [Any] else {
			throw JSONError.inavlidData
		}
		guard array.indices.contains(key) else {
			throw JSONError.invalidKey
		}
		guard let newObject = array[key] as? Value else {
			throw JSONError.invalidType
		}
		return try JSONSerialization.data(withJSONObject: newObject)
	}
	
	/// Parse the underlying data into a Swift array.
	/// - Returns: The array.
	public func parse() throws -> [Any] {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let array = object as? [Any] else {
			throw JSONError.inavlidData
		}
		return array
	}
	
	/// Iterate over the elements in the JSON array.
	/// - Parameter closure: A closure that takes a `JSONProxy<Int>` instance as input, which contains both the key and the value at each iteration time-step.
	public func iterate(_ closure: (JSONProxy<Int>) throws -> Void) throws {
		try self.parse()
			.enumerated()
			.forEach { (key, value) in
				try closure(JSONProxy(key: key, value: value))
			}
	}
	
}

/// A JSON dictionary parser.
public struct DictionaryJSONParser: IterableJSONParser {
	
	/// The underlying data.
	public let data: Data
	
	/// Create a dictionary parser from raw bytes.
	/// - Parameter data: The raw data.
	public init(_ data: Data) {
		self.data = data
	}
	
	/// Create a dictionary parser from a dictionary.
	init?(_ dictionary: [String: Any]) {
		guard let data = try? JSONSerialization.data(withJSONObject: dictionary) else {
			return nil
		}
		self.init(data)
	}
	
	/// Get the value that's associated with a particular key.
	/// - Returns: The value.
	public func get<Value>(valueAt key: String, as: Value.Type) throws -> Value where Value: JSONValue {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let dictionary = object as? [String: Any] else {
			throw JSONError.inavlidData
		}
		guard dictionary.keys.contains(key) else {
			throw JSONError.invalidKey
		}
		guard let value = dictionary[key] as? Value else {
			throw JSONError.invalidType
		}
		return value
	}
	
	/// Get the value that's associated with a particular key as re-serialized data.
	/// - Returns: The re-serialized data.
	public func get<Value>(dataAt key: String, asCollection: Value.Type) throws -> Data where Value: Collection {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let dictionary = object as? [String: Any] else {
			throw JSONError.inavlidData
		}
		guard dictionary.keys.contains(key) else {
			throw JSONError.invalidKey
		}
		guard let value = dictionary[key] as? Value else {
			throw JSONError.invalidType
		}
		return try JSONSerialization.data(withJSONObject: value)
	}
	
	/// Parse the underlying data into a Swift dictionary.
	/// - Returns: The dictionary.
	public func parse() throws -> [String: Any] {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let dictionary = object as? [String: Any] else {
			throw JSONError.inavlidData
		}
		return dictionary
	}
	
	/// Iterate over the elements in the JSON dictionary.
	/// - Parameter closure: A closure that takes a `JSONProxy<String>` instance as input, which contains both the key and the value at each iteration time-step.
	public func iterate(_ closure: (JSONProxy<String>) throws -> Void) throws {
		try self.parse()
			.forEach { (key, value) in
				try closure(JSONProxy(key: key, value: value))
			}
	}
	
}
