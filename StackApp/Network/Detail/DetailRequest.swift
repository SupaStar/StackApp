//
//  DetailRequest
//  StackApp
//
//  Created by Obed Martinez on 13/10/23
//



import Foundation
import Alamofire

class DetailRequest {
    func loadHistorical(symbol: String, completion: @escaping(([HistoricalModel], String)->Void)){
        let params = [
            "symbols": symbol,
            "limit": "30"
        ]
        guard let url = makeURL(method: "eod", parameters: params) else {
            completion([], "Ocurrio un error al crear la url")
            return
        }
        
        let request = AF.request(url, method: .get)
        request.responseDecodable(of:HistoricalModelResponse.self){ (response) in
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
}
