//
//  JSONProxy.swift
//  
//
//  Created by Gabriel Jacoby-Cooper on 11/30/20.
//

import Foundation

public struct JSONProxy<Key> where Key: JSONKey {
	
	public let key: Key
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
	
	public func get<Value>(as _: Value.Type) -> Value? where Value: JSONValue {
		return self.value as? Value
	}
	
	public func get<Value>(as _: Value.Type) -> (Key, Value?) where Value: JSONValue {
		return (key: self.key, value: self.value as? Value)
	}
	
}
