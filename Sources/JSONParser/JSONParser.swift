//
//  JSONParser.swift
//
//
//  Created by Gabriel Jacoby-Cooper on 10/9/20.
//

import Foundation

public protocol JSONParser {
	
	associatedtype Key: JSONKey
	associatedtype InternalCollection: Collection
	
	var data: Data { get }
	
	init(_: Data)
	subscript(arrayAt key: Key) -> ArrayJSONParser? { get }
	subscript(dictionaryAt key: Key) -> DictionaryJSONParser? { get }
	subscript<Value>(_: Key, as _: Value.Type) -> Value? where Value: JSONValue { get }
	
	func get<Value>(valueAt: Key, as: Value.Type) throws -> Value where Value: JSONValue
	func get<Value>(dataAt: Key, asCollection: Value.Type) throws -> Data where Value: Collection
	func parse() throws -> InternalCollection
	
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

public struct ArrayJSONParser: JSONParser {
	
	public let data: Data
	
	public init(_ data: Data) {
		self.data = data
	}
	
	public func get<Value>(valueAt key: Int, as: Value.Type) throws -> Value where Value: JSONValue {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let array = object as? [Any] else {
			throw JSONError.inavlidData
		}
		guard array.indices.contains(key) else {
			throw JSONError.invalidKey
		}
		guard let value = array[key] as? Value else {
			throw JSONError.inavlidData
		}
		return value
	}
	
	public func get<Value>(dataAt key: Int, asCollection: Value.Type) throws -> Data where Value: Collection {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let array = object as? [Any] else {
			throw JSONError.inavlidData
		}
		guard array.indices.contains(key) else {
			throw JSONError.invalidKey
		}
		guard let newObject = array[key] as? Value else {
			throw JSONError.inavlidData
		}
		return try JSONSerialization.data(withJSONObject: newObject)
	}
	
	public func parse() throws -> some Collection {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let array = object as? [Any] else {
			throw JSONError.inavlidData
		}
		return array
	}
	
}

public struct DictionaryJSONParser: JSONParser {
	
	public let data: Data
	
	public init(_ data: Data) {
		self.data = data
	}
	
	public func get<Value>(valueAt key: String, as: Value.Type) throws -> Value where Value: JSONValue {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let dictionary = object as? [String: Any] else {
			throw JSONError.inavlidData
		}
		guard let value = dictionary[key] as? Value else {
			throw JSONError.invalidKey
		}
		return value
	}
	
	public func get<Value>(dataAt key: String, asCollection: Value.Type) throws -> Data where Value: Collection {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let dictionary = object as? [String: Any] else {
			throw JSONError.inavlidData
		}
		guard let value = dictionary[key] as? Value else {
			throw JSONError.invalidKey
		}
		return try JSONSerialization.data(withJSONObject: value)
	}
	
	public func parse() throws -> some Collection {
		let object = try JSONSerialization.jsonObject(with: self.data)
		guard let dictionary = object as? [String: Any] else {
			throw JSONError.inavlidData
		}
		return dictionary
	}
	
}
