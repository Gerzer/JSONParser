# JSONParser
Elegant, type-safe JSON parsing in Swift

If you're a clever programmer, then you probably use `Codable` types wherever you can do so. However, sometimes you need to parse some JSON data the structure of which you don't control. Previously, this was a painful operation:

```swift
let object = try (JSONSerialization.jsonObject(with: data) as! [String: Any])
guard let foo = object["foo"] as? Int, let bar = object["bar"] as? String, let array = object["array"] as? [Any] else {
	return
}
guard let number = array[0] as? Double, let word = array[1] as? String, let dictionary = array[3] as? [String: Int] else {
	return
}
guard let hello = dictionary["hello"] else {
	return
}
```

With JSONParser, this process is **elegant and effortless**:

```swift
let parser = data.dictionaryParser // `data` is an instance of `Data` from `Foundation`
let foo = parser["foo", as: Int.self]
let bar = parser["bar", as: String.self]
let number = parser[arrayAt: "array"]?[0, as: Double.self]
let word = parser[arrayAt: "array"]?[1, as: String.self]
let hello = parser[arrayAt: "array"]?[dictionaryAt: 2]?["hello", as: Int.self]
```

You can also **iterate over heterogenous JSON arrays**:

```swift
try data.arrayParser.iterate { (proxy) in
	if let value = proxy.get(as: Int.self) {
		print(value * 2)
	} else if let value = proxy.get(as: Bool.self) {
		print(!value)
	}
}
```

JSONParser can **work with other providers**, not just `Data` from `Foundation`. Just have your custom class or struct conform to the `JSONProvider` protocol. It has only one mandatory interface member:

```swift
// This `Set` extension is already provided in the JSONParser package; use it as a guide for writing your own extensions for other types
extension Set: JSONProvider {

	public var parser: ArrayJSONParser? {
		get {
			return Array(self).parser
		}
	}

}
```

Convenient functions and subscript accessors are automatically provided for free, requiring **no manual implementation**:

```swift
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
```

JSONParser builds on top of Swift's robust generic-typing system to provide an **easy, intuitive API** for interacting with JSON data. It has **no external dependencies** and relies solely on `Foundation` APIs, so it **works on Linux and Windows** in addition to the various Apple platforms.
