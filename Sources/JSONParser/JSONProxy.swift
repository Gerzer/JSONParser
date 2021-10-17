//
//  JSONProxy.swift
//  JSONParser
//
//  Created by Gabriel Jacoby-Cooper on 11/30/20.
//

import Foundation

/// A proxy representation of a parsed JSON value.
public struct JSONProxy<Key> where Key: JSONKey {
	
	/// The key that's associated the JSON value.
	public let key: Key
	
	/// The JSON value.
	private let value: Any
	
	public var arrayParser: ArrayJSONParser? {
		get {
			guard let array = self.value as? [Any] else {
				return nil
			}
			return ArrayJSONParser(array)
		}
	}
	
	public var dictionaryParser: DictionaryJSONParser? {
		get {
			guard let dictionary = self.value as? [String: Any] else {
				return nil
			}
			return DictionaryJSONParser(dictionary)
		}
	}
	
	init(key: Key, value: Any) {
		self.key = key
		self.value = value
	}
	
	/// Get the value as a specific type.
	/// - Returns: The value
	public func get<Value>(as _: Value.Type) -> Value? where Value: JSONValue {
		return self.value as? Value
	}
	
	/// Get the key as well as the value as a specific type.
	/// - Returns: A 2-tuple `(key, value)` with the key as well as the parsed value.
	public func get<Value>(as _: Value.Type) -> (Key, Value?) where Value: JSONValue {
		return (key: self.key, value: self.value as? Value)
	}
	
}
