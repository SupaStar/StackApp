//
//  TickerViewModel
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import Foundation

class TickerViewModel {
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
    var isLoading: Bool = false {
        didSet { self.updateLoadingStatus?() }
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    // MARK: - Constructor
    init(dataService: TickersRequest) {
        self.tickersRequest = dataService
    }
    
    func requestTickers(limit: Int = 100, offset: Int = 0){
        self.tickersRequest?.loadTickers(limit: limit, offset: offset,completion: { tickers, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                self.isLoading = false
                return
            }
            self.isLoading = false
            self.tickers = tickers
        })
    }
    
    func requestCloses(symbols: String){
        self.tickersRequest?.getTickersClose(symbols: symbols, completion: { closes, errorMessage in
            if errorMessage != "" {
                self.errorMessage = errorMessage
                self.isLoading = false
                return
            }
            self.isLoading = false
            self.tickersCloses = closes
        })
    }
}
