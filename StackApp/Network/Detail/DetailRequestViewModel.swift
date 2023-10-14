//
//  DetailRequestViewModel
//  StackApp
//
//  Created by Obed Martinez on 13/10/23
//



import Foundation

class DetailRequestViewModel {
    //MARK: - Properties
    var historical: [HistoricalModel]? {
        didSet { self.didFinishFetch?() }
    }
    
    private var detailRequest: DetailRequest?
    
    var errorMessage: String? = ""{
        didSet {
            if errorMessage != "" && errorMessage != nil {
                showAlertClosure?()
            }
        }
    }
    
    // MARK: - Constructor
    init(dataService: DetailRequest) {
        self.detailRequest = dataService
    }
    
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    
    // MARK: Methods
    func requestHistorical(symbol: String){
        self.detailRequest?.loadHistorical(symbol: symbol, completion: { historical, error in
            if self.errorMessage != "" {
                self.errorMessage = self.errorMessage
                return
            }
            self.historical = historical
        })
    }
}
