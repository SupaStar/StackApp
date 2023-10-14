//
//  TickerClosesModel
//  StackApp
//
//  Created by Obed Martinez on 12/10/23
//



import Foundation

struct TickerClosesModelResponse: Decodable {
    var pagination: PaginationModel
    var data: [TickerClosesModel]
}

struct TickerClosesModel: Decodable {
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var symbol: String
    
    enum CodingKeys: String, CodingKey {
        case open = "open"
        case high = "high"
        case low = "low"
        case close = "close"
        case symbol = "symbol"
    }
}
