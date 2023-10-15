//
//  HomeTableViewController
//  StackApp
//
//  Created by Obed Martinez on 11/10/23
//



import UIKit
import FirebaseAnalytics
import FirebaseAuth

class HomeTableViewController: UITableViewController {
    
    // MARK: INJECTIONS
    var tickerVM: TickerRequestViewModel = TickerRequestViewModel(dataService: TickersRequest())
    var tickers: [TickerModel] = []
    let loader = Loader()
    
    // MARK: Variables
    var numberPetitions = 1
    var limit: Int = 100
    var offset: Int = 0
    var selectedTicker: TickerModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tickers"
        
        UserDefaults.standard.set(true, forKey: UserDefaultEnum.logedBefore.rawValue)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let signOut = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right.fill"), style: .plain, target: self, action: #selector(closeSession))
        
        // Asignar el botón a la barra de navegación
        self.navigationItem.rightBarButtonItem = signOut
        
        self.loadTickers()
    }
    
    @objc func closeSession(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            performSegue(withIdentifier: "goLogin", sender: self)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    @objc func hideLoader(){
        var delayTime = 1.0
        if self.tickers.count > 100 {
            delayTime = 1.0
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
        Analytics.logEvent("Carga de tickers", parameters: ["fecha":"\(Date())"])
        self.tickerVM.requestTickers(limit: self.limit, offset: self.offset)
        self.tickerVM.didFinishFetch = {
            self.tickers = self.tickerVM.tickers ?? []
            // MARK: Uncoment if you wish view close prices, this petition spend a lot of credits
            //            self.loadClosesPrices()
            self.hideLoader()
        }
        self.tickerVM.updateLoadingStatus = {
            self.loader.hide()
        }
        self.tickerVM.showAlertClosure = {
            self.hideLoader()
            if let message = self.tickerVM.errorMessage {
                if message != "" {
                    CommonUtils.alert(message: message, title: "Error", origin: self)
                }
            }
        }
    }
    
    func loadClosesPrices(){
        Analytics.logEvent("Carga de precios de cierre", parameters: ["fecha":"\(Date())"])
        let symbols = self.makeSymbolsToPetition()
        self.tickerVM.requestCloses(symbols: symbols)
        self.tickerVM.didFinishFetch = {
            self.tickers.enumerated().forEach { (index, ticker) in
                if let close = self.tickerVM.tickersCloses?.first(where: { $0.symbol == ticker.symbol }) {
                    self.tickers[index].closes = close.close
                }
            }
            self.hideLoader()
        }
        self.tickerVM.updateLoadingStatus = {
            self.loader.hide()
        }
        self.tickerVM.showAlertClosure = {
            self.hideLoader()
            if let message = self.tickerVM.errorMessage {
                if message != "" {
                    CommonUtils.alert(message: message, title: "Error", origin: self)
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
        if indexPath.row == 0 {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "TickerVC", for: indexPath) as! TickerTableViewCell
        cell.ticker = tickers[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 30
        }
        return 75
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TickerTableViewCell
        selectedTicker = cell.ticker
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "trackDetail", sender: self)
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
    
    private func makeSymbolsToPetition() -> String {
        let symbolsArray = tickers[offset..<limit].map { $0.symbol }
        let symbolsString = symbolsArray.joined(separator: ",")
        return symbolsString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "trackDetail" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.ticker = selectedTicker
            }
        } else if segue.identifier == "goLogin" {
            guard segue.destination is MainViewController else {return}
        }
    }
}
