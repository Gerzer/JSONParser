//
//  JSONKey.swift
//  
//
//  Created by Gabriel Jacoby-Cooper on 10/9/20.
//

import Foundation

public protocol JSONKey { }

extension Int: JSONKey { }

extension String: JSONKey { }
