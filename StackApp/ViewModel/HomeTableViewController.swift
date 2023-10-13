//
//  HomeTableViewController
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import UIKit

class HomeTableViewController: UITableViewController {
    
    // MARK: INJECTIONS
    var tickerVM: TickerViewModel = TickerViewModel(dataService: TickersRequest())
    var tickers: [TickerModel] = []
    let loader = Loader()

    var numberPetitions = 1
    var limit: Int = 100
    var offset: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tickers"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        self.loadTickers()
    }
    
    @objc func hideLoader(){
        var delayTime = 1.0
        if self.tickers.count > 100 {
            delayTime = 3.0
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime, execute: {
            self.tableView.tableFooterView = nil
            self.tableView.reloadData()
            self.numberPetitions = 0
            self.loader.hide()
        })
    }
    
    func loadTickers(){
        loader.show(in: self)
        
        self.tickerVM.requestTickers(limit: self.limit, offset: self.offset)
        self.tickerVM.didFinishFetch = {
            self.tickers = self.tickerVM.tickers ?? []
            self.hideLoader()
        }
        self.tickerVM.updateLoadingStatus = {
            //            Loader.hide(for: self.view)
        }
        self.tickerVM.showAlertClosure = {
            if let message = self.tickerVM.errorMessage {
                if message != "" {
                    //                    CommonUtils.alert(message: message, title: "Ha ocurrido un error", origin: self)
                }
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TickerVC", for: indexPath) as! TickerTableViewCell
        cell.ticker = tickers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 0 {
            return 75
        }
        return 30
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let screenHeight = scrollView.bounds.height
        
        // If the user reaches the end, it automatically loads new data.
        if offsetY > contentHeight - screenHeight {
            if numberPetitions == 0 {
                numberPetitions = 1
                self.tableView.tableFooterView = createSpinnerFooter()
                limit = limit + 100
                offset = offset + 100
                self.loadTickers()
            }
        }
    }
    
    // Make the spinner for the end of the table
    private func createSpinnerFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
        
        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        spinner.color = .black
        footerView.addSubview(spinner)
        spinner.startAnimating()
        
        return footerView
    }
}
