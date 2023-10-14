//
//  IndexTickersRequest
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import Foundation
import Alamofire

class TickersRequest {
    
    func loadTickers(limit: Int = 100, offset: Int = 0, completion: @escaping(([TickerModel], String)->Void)){
        let params = [
            "limit": "\(limit)",
            "offset": "\(offset)"
        ]
        guard let url = makeURL(method: "tickers", parameters: params) else {
            completion([], "Ocurrio un error al crear la url")
            return
        }
        let request = AF.request(url, method: .get)
        
        request.responseDecodable(of:TickerModelResponse.self){ (response) in
            switch response.result {
            case .success(let value):
                completion(value.data, "")
            case .failure( _):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 500 {
                        completion([], "Error interno")
                    }else if statusCode == 422 {
                        completion([], "Error de validación")
                    }else if statusCode == 429 {
                        completion([], "Tu token alcanzo su limite")
                    }else {
                        completion([], "Error \(statusCode)")
                    }
                }
                else {
                    completion([], "Error desconocido")
                }
            }
        }
    }
    
    func getTickersClose(symbols: String, completion:@escaping(([TickerClosesModel], String)->Void)){
        let params = [
            "symbols" : symbols
        ]
        guard let url = makeURL(method: "eod", parameters: params) else {
            completion([], "Ocurrio un error al crear la url")
            return
        }
        print(url)
        let request = AF.request(url, method: .get)
        request.responseDecodable(of:TickerClosesModelResponse.self){ (response) in
            switch response.result {
            case .success(let value):
                completion(value.data, "")
            case .failure( _):
                if let statusCode = response.response?.statusCode {
                    if statusCode == 500 {
                        completion([], "Error interno")
                    }else if statusCode == 422 {
                        completion([], "Error de validación")
                    }else if statusCode == 429 {
                        completion([], "Tu token alcanzo su limite")
                    } else {
                        completion([], "Error \(statusCode)")
                    }
                }
                else {
                    completion([], "Error desconocido")
                }
            }
            
        }
        
    }
}
