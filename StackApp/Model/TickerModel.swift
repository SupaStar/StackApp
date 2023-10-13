//
//  Ticker
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import Foundation

struct TickerModelResponse: Decodable {
    var pagination: PaginationModel
    var data: [TickerModel]
}

struct PaginationModel: Decodable {
    var limit: Int
    var offset: Int
    var count: Int
    var total: Int
    
    enum CodingKeys: String, CodingKey {
        case limit = "limit"
        case offset = "offset"
        case count = "count"
        case total = "total"
    }
}
struct TickerModel: Decodable {
    var name: String
    var symbol: String
    var stock_exchange: StockExchange
    var closes: Double?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case symbol = "symbol"
        case stock_exchange = "stock_exchange"
    }
}

struct StockExchange: Decodable {
    var name: String
    var acronym: String
    var mic: String
    var country: String
    var country_code: String
    var city: String
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case acronym = "acronym"
        case mic = "mic"
        case country = "country"
        case country_code = "country_code"
        case city = "city"
    }
}
