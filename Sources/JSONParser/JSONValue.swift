//
//  JSONValue.swift
//  JSONParser
//
//  Created by Gabriel Jacoby-Cooper on 10/9/20.
//

import Foundation

/// A value that can be represented in JSON.
public protocol JSONValue: Codable { }

extension Bool: JSONValue { }

extension Int: JSONValue { }

extension Float: JSONValue { }

extension Double: JSONValue { }

extension String: JSONValue { }

extension Array: JSONValue where Element: JSONValue { }

extension Dictionary: JSONValue where Key == String, Value: JSONValue { }
