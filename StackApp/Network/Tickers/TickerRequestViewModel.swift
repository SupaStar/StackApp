//
//  TickerViewModel
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import Foundation

class TickerRequestViewModel {
    //MARK: - Properties
    var tickers: [TickerModel]? {
        didSet { self.didFinishFetch?() }
    }
    
    var tickersCloses: [TickerClosesModel]? {
        didSet { self.didFinishFetch?() }
    }
    
    private var tickersRequest: TickersRequest?
    
    var errorMessage: String? = ""{
        didSet {
            if errorMessage != "" && errorMessage != nil {
                showAlertClosure?()
            }
        }
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: TickersRequest) {
        self.tickersRequest = dataService
    }
    
    // MARK: Methods
    func requestTickers(limit: Int = 100, offset: Int = 0, search: String?){
        self.tickersRequest?.loadTickers(limit: limit, offset: offset, search: search ,completion: { tickers, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                return
            }
            self.tickers = tickers
        })
    }
    
    func requestCloses(symbols: String){
        self.tickersRequest?.getTickersClose(symbols: symbols, completion: { closes, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                return
            }
            self.tickersCloses = closes
        })
    }
}
