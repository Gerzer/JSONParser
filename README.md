# JSONParser
Elegant, type-safe JSON parsing in Swift

If you're a clever programmer, then you probably use `Codable` types wherever you can do so. However, sometimes you need to parse some JSON data the structure of which you don't control. Previously, this was a painful operation:

```swift
let object = try (JSONSerialization.jsonObject(with: data) as! [String: Any])
guard let foo = object["foo"] as? Int, let bar = object["baz"] as? String, let array = object["array"] as? [Any] else {
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
let parser = DictionaryJSONParser(data)
let foo = parser["foo", as: Int.self]
let bar = parser["bar", as: String.self]
let number = parser[arrayAt: "array"]?[0, as: Double.self]
let word = parser[arrayAt: "array"]?[1, as: String.self]
let hello = parser[arrayAt: "array"]?[dictionaryAt: 2]?["hello", as: Int.self]
```

JSONParser relies on Swift's robust generic-typing system to provide an **easy, intuitive API** for interacting with JSON data. It has **no external dependencies** and relies solely on `Foundation` APIs, so it **works on Linux and Windows** in addition to the various Apple platforms.
