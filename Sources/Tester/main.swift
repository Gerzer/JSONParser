import Foundation
import JSONParser

let array = [
	0,
	1,
	[
		"2": true
	]
] as [AnyHashable]
let set = Set(array)
try set.iterate { (proxy) in
	print(proxy.get(as: Int.self) ?? proxy.get(as: [String: Bool].self)!)
}
try array.iterate { (proxy) in
	print(proxy.get(as: Int.self) ?? proxy.get(as: [String: Bool].self)!["2", as: Bool.self]!)
}
try array.parser?[dictionaryAt: 2]?.iterate { (proxy) in
	let (key, value) = proxy.get(as: Bool.self)
	print("\(key): \(value!)")
}
