//
//  DetailViewController
//  StackApp
//
//  Created by Obed Martinez on 13/10/23
//



import UIKit

class DetailViewController: UIViewController {
    // MARK: Variables
    var ticker: TickerModel?
    var historical: [HistoricalModel] = []
    
    // MARK: Components
    @IBOutlet weak var tickerNameLbl: UILabel!
    @IBOutlet weak var tickerSymbolLbl: UILabel!
    @IBOutlet weak var exchangeNameLbl: UILabel!
    @IBOutlet weak var stockExchangeAcronymLbl: UILabel!
    @IBOutlet weak var stockExchangeCountryLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var openPriceLbl: UILabel!
    @IBOutlet weak var closePriceLbl: UILabel!
    @IBOutlet weak var highPriceLbl: UILabel!
    @IBOutlet weak var lowPriceLbl: UILabel!
    @IBOutlet weak var volumeLbl: UILabel!
    
    // MARK: Injections
    var detailVM: DetailRequestViewModel = DetailRequestViewModel(dataService: DetailRequest())
    let loader = Loader()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ticker = self.ticker {
            self.loadStock(ticker: ticker)
        } else{
            print("regresar")
        }
    }
    
    func hideLoader(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.loader.hide()
        })
    }
    
    func loadStock(ticker: TickerModel){
        loader.show(in: self)
        self.tickerNameLbl.text = ticker.name
        self.tickerSymbolLbl.text = ticker.symbol
        self.exchangeNameLbl.text = ticker.stock_exchange.name
        self.stockExchangeAcronymLbl.text = ticker.stock_exchange.acronym
        self.stockExchangeCountryLbl.text = ticker.stock_exchange.country
        getHistoricalData(symbol: ticker.symbol)
        loadChartExample()
    }
    
    func getHistoricalData(symbol: String){
        self.detailVM.requestHistorical(symbol: symbol)
        self.detailVM.didFinishFetch = {
            self.historical = self.detailVM.historical ?? []
            if let today = self.historical.first {
                if let date = CommonUtils.formatDateString(date: today.date){
                    self.dateLbl.text = date
                }
                self.openPriceLbl.text = "\(today.adj_open)"
                self.closePriceLbl.text = "\(today.adj_close)"
                self.highPriceLbl.text = "\(today.adj_high)"
                self.lowPriceLbl.text = "\(today.adj_low)"
                self.volumeLbl.text = "\(today.adj_volume)"
            }
            self.hideLoader()
        }
        self.detailVM.showAlertClosure = {
            self.hideLoader()
            if let message = self.detailVM.errorMessage {
                if message != "" {
                    CommonUtils.alert(message: message, title: "Error", origin: self)
                }
            }
        }
    }
    
    func loadChartExample(){
        //        let barChartView = BarChartView()
        //        barChartView.frame = CGRect(x: 20, y: 100, width: 300, height: 200)
        //        view.addSubview(barChartView)
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
