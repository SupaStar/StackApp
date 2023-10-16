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
    let loader = Loader()
    let options: [OptionFilterEnum] = [.open, .close, .high, .low, .volume]
    var dates: [String] = []
    var yValues: [Double] = []
    var user: UserEntity?
    var isSaved: Bool = false
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
    @IBOutlet weak var filterMenuBtn: UIButton!
    @IBOutlet weak var chartView: UIView!
    
    // MARK: Injections
    var detailVM: DetailRequestViewModel = DetailRequestViewModel(dataService: DetailRequest())
    var persistanceS: PersistenceService = PersistenceService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        if let ticker = self.ticker {
            self.loadStock(ticker: ticker)
        }
        if let id = UserDefaults.standard.string(forKey: UserDefaultEnum.idUser.rawValue) {
            guard let user = persistanceS.getUser(id: id), let ticker = self.ticker else {
                return
            }
            self.user = user
            self.isSaved = persistanceS.hasSavedTicker(user: user, name: ticker.name, stockAcron: ticker.stock_exchange.acronym, stockCountry: ticker.stock_exchange.country, symbol: ticker.symbol, stock_name: ticker.stock_exchange.name)
            let imgName = self.isSaved ? "star.fill" : "star"
            let save = UIBarButtonItem(image: UIImage(systemName: imgName), style: .plain, target: self, action: #selector(saveFav))
            
            // Asignar el botón a la barra de navegación
            self.navigationItem.rightBarButtonItem = save
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    @objc func saveFav(){
        guard let user = self.user, let ticker = self.ticker else {
            return
        }
        if self.isSaved {
            persistanceS.deleteTicker(user: user, name: ticker.name, stockAcron: ticker.stock_exchange.acronym, stockCountry: ticker.stock_exchange.country, symbol: ticker.symbol, stock_name: ticker.stock_exchange.name)
            self.isSaved = false
        }else{
            persistanceS.saveTicker(user: user, name: ticker.name, stockAcron: ticker.stock_exchange.acronym, stockCountry: ticker.stock_exchange.country, symbol: ticker.symbol, stock_name: ticker.stock_exchange.name)
            self.isSaved = true
        }
        let imgName = self.isSaved ? "star.fill" : "star"
        let save = UIBarButtonItem(image: UIImage(systemName: imgName), style: .plain, target: self, action: #selector(saveFav))
        
        // Asignar el botón a la barra de navegación
        self.navigationItem.rightBarButtonItem = save
    }
    
    func changeChart(action: UIAction){
        if let selectedOption = OptionFilterEnum(rawValue: action.title) {
            switch selectedOption {
            case .open:
                self.yValues = historical.map{$0.adj_open}
            case .close:
                self.yValues = historical.map{$0.adj_close}
            case .high:
                self.yValues = historical.map{$0.adj_high}
            case .volume:
                self.yValues = historical.map{$0.adj_volume}
            case .low:
                self.yValues = historical.map{$0.adj_low}
            }
            self.drawChart()
        }
    }
    
    func drawChart() {
        let chartHeight = chartView.frame.height
        let chartWidth = chartView.frame.width
        let chart = ChartView(frame: CGRect(x: 0, y: 0, width: chartWidth, height: chartHeight))
        chart.x = self.dates
        chart.y = self.yValues
        chartView.addSubview(chart)
    }
    
    // MARK: Make the drop down menu
    func loadFilterChartOptions(){
        var optionsArray = [UIAction]()
        for option in options {
            let action = UIAction(title: option.rawValue, state: .off, handler: self.changeChart)
            
            optionsArray.append(action)
        }
        optionsArray[0].state = .on
        let optionsMenu = UIMenu(title: "", options: .displayInline, children: optionsArray)
        filterMenuBtn.menu = optionsMenu
        filterMenuBtn.changesSelectionAsPrimaryAction = true
        filterMenuBtn.showsMenuAsPrimaryAction = true
        
        //First chart
        self.dates = historical.map {
            CommonUtils.formatDateStringShort(date: $0.date) ?? ""
        }
        self.yValues = historical.map{$0.adj_open}
        self.drawChart()
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
                self.loadFilterChartOptions()
            } else {
                CommonUtils.alert(message: "No historical data found.", title: "Warning.", origin: self, delay: 1.5)
                self.dateLbl.isHidden = true
                self.openPriceLbl.isHidden = true
                self.closePriceLbl.isHidden = true
                self.highPriceLbl.isHidden = true
                self.lowPriceLbl.isHidden = true
                self.volumeLbl.isHidden = true
                self.filterMenuBtn.isHidden = true
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
    
}
