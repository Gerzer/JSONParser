//
//  JSONKey.swift
//  JSONParser
//
//  Created by Gabriel Jacoby-Cooper on 10/9/20.
//

import Foundation

/// A key for a collection that's representable in JSON.
public protocol JSONKey { }

extension Int: JSONKey { }

extension String: JSONKey { }
