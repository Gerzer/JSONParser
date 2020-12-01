//
//  JSONProvider.swift
//  
//
//  Created by Gabriel Jacoby-Cooper on 11/23/20.
//

import Foundation

public protocol JSONProvider {
	
	associatedtype InternalJSONParser: JSONParser
	typealias Key = InternalJSONParser.Key
	
	var parser: InternalJSONParser? { get }
	
	subscript(arrayAt key: Key) -> ArrayJSONParser? { get }
	subscript(dictionaryAt key: Key) -> DictionaryJSONParser? { get }
	subscript<Value>(_: Key, as _: Value.Type) -> Value? where Value: JSONValue { get }
	
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

public struct ArrayData: JSONProvider {
	
	let data: Data
	public var parser: ArrayJSONParser? {
		get {
			return ArrayJSONParser(self.data)
		}
	}
	
	fileprivate init(_ data: Data) {
		self.data = data
	}
	
}

public struct DictionaryData: JSONProvider {
	
	private let data: Data
	public var parser: DictionaryJSONParser? {
		get {
			return DictionaryJSONParser(self.data)
		}
	}
	
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

extension Array: JSONProvider {
	
	public var parser: ArrayJSONParser? {
		get {
			guard let data = try? JSONSerialization.data(withJSONObject: self) else {
				return nil
			}
			return ArrayJSONParser(data)
		}
	}
	
}

extension Dictionary: JSONProvider where Key == String {
	
	public var parser: DictionaryJSONParser? {
		get {
			guard let data = try? JSONSerialization.data(withJSONObject: self) else {
				return nil
			}
			return DictionaryJSONParser(data)
		}
	}
	
}
