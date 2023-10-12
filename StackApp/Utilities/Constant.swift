//
//  Constant
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import Foundation

// API
let apiKey = "2c8008f343e596c967f98d6982cfbc95"
let apiURL = "http://api.marketstack.com/v1/"

func makeURL(method: String, parameters: [String:String]) -> URL? {
    var baseURL = "\(apiURL)\(method)?access_key=\(apiKey)"
    if !parameters.isEmpty {
        baseURL += "&"
    }
    let queryItems = parameters.map { (key, value) in
        return "\(key)=\(value)"
    }
    baseURL += queryItems.joined(separator: "&")
    if let url = URL(string: baseURL) {
        return url
    } else {
        return nil
    }
}
