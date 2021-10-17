//
//  JSONError.swift
//  JSONParser
//
//  Created by Gabriel Jacoby-Cooper on 10/16/20.
//

import Foundation

/// An error that's thrown when JSON parsing or iteration fails.
enum JSONError: Error {
	
	case inavlidData
	
	case invalidKey
	
	case invalidType
	
	case failedIteration
	
}
