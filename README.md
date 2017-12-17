# APICodable

[![CI Status](http://img.shields.io/travis/iAmrSalman/APICodable.svg?style=flat)](https://travis-ci.org/iAmrSalman/APICodable)
[![Version](https://img.shields.io/cocoapods/v/APICodable.svg?style=flat)](http://cocoapods.org/pods/APICodable)
[![License](https://img.shields.io/cocoapods/l/APICodable.svg?style=flat)](http://cocoapods.org/pods/APICodable)
[![Platform](https://img.shields.io/cocoapods/p/APICodable.svg?style=flat)](http://cocoapods.org/pods/APICodable)

## TO-DOs

- [x] perform network request
- [x] easy to switch between multiple services
- [x] automatically mapping models
- [ ] network status mintoring 
- [ ] save incompleted requests when there is no connection 
- [ ] perform requests once connected to network
- [ ] serilize response -> force failure

## Requirements

- iOS 9.0+
- Xcode 9.0+
- Swift 4.0+

## Installation

APICodable is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'APICodable'
```

## Usage

### 1. Create a model (class or struct)

```swift
class FirstModel: Codable, Returnable {
    
    struct JSON: Codable {
        var name: String
        var github: String
    }
    
    var origin: String?
    var json: JSON?
    var labelOrigin: String {
        return "IP -> " + (origin ?? "Unkown")
    }
}
```

### 2. Create an API base

```swift
struct HTTPBin: APIBase {
    
    static var baseURL: String {
        return "https://httpbin.org/"
    }
    
    static var headers: [String: String]? {
        return nil
    }
}
```

### 3. Request

```swift
Request<Service, Model>.Method(Path, Parameters).onSuccess{...}.onFailure{...} 
```
> Method: GET, POST, PUT or DELETE. 
> onSuccess & onFailure is not mandatory.

#### GET

parameters -> <URL>?foo=bar

```swift
static func requestIP(completionHandler: @escaping (FirstModel) -> Void) {
    
    Request<HTTPBin, FirstModel>.GET("ip").onSuccess(completionHandler).onFailure({ reason in print(reason) })
    
}
```
#### POST

HTTP header: Content-Type: application/json

HTTP body: {"foo": [1, 2, 3], "bar": {"baz": "qux"}}

```swift
Request<HTTPBin, FirstModel>.POST("post", parameters: ["name": "@iAmrSalman", "github": "https://github.com/iAmrSalman"])
    .onSuccess { model in
        print("Name: \(model.json?.name),", "github: \(model.json?.github)")
    }
    .onFailure { reason in
        print(reason)
    }
```

#### More Control?

```swift
Request<HTTPBin, FirstModel>(.post,
                             path: "post",
                             parameters: ["name": "@iAmrSalman", "github": "https://github.com/iAmrSalman"])
    .perform(onSuccess: { model in
        print("Name: \(model.json?.name),", "github: \(model.json?.github)")
    },
             onFaild: { reson in
                print(reson)
                
    })
```

## Author

iAmrSalman, iamrsalman@gmail.com

## License

APICodable is available under the MIT license. See the LICENSE file for more info.
