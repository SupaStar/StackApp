//
//  Constant
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import Foundation
import UIKit

// API
let apiKey = "37b509e45739dc73e7441465c15f39e6"
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

// DEVICE
func getDeviceUUID() -> String {
    if let uuid = UIDevice.current.identifierForVendor?.uuidString {
        return uuid
    } else {
        // En caso de que no se pueda obtener el UUID del dispositivo
        return "No se pudo obtener el UUID"
    }
}

// UX

