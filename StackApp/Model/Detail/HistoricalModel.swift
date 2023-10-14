//
//  HistoricalModel
//  StackApp
//
//  Created by Obed Martinez on 13/10/23
//



import Foundation

struct HistoricalModelResponse: Decodable {
    var pagination: PaginationModel
    var data: [HistoricalModel]
}

struct HistoricalModel: Decodable {
    var open: Double
    var high: Double
    var low: Double
    var close: Double
    var volume: Double
    var adj_high: Double
    var adj_low: Double
    var adj_close: Double
    var adj_open: Double
    var adj_volume: Double
    var split_factor: Double
    var dividend: Double
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case open = "open"
        case high = "high"
        case low = "low"
        case close = "close"
        case volume = "volume"
        case adj_high = "adj_high"
        case adj_low = "adj_low"
        case adj_close = "adj_close"
        case adj_open = "adj_open"
        case adj_volume = "adj_volume"
        case split_factor = "split_factor"
        case dividend = "dividend"
        case date = "date"
    }
}
