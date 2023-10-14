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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let ticker = self.ticker {
            self.loadStock(ticker: ticker)
        } else{
            print("regresar")
        }
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
        let chartX = chartView.frame.minX
        let chartY = chartView.frame.minY
        let chart = ChartView(frame: CGRect(x: chartX, y: chartY, width: chartWidth, height: chartHeight))
        chart.x = self.dates
        chart.y = self.yValues
        chartView.addSubview(chart)
    }
    
    // MARK: Make the drop down menu
    func loadFilterChartOptions(){
        var optionsArray = [UIAction]()
        for country in options {
            let action = UIAction(title: country.rawValue, state: .off, handler: self.changeChart)
            
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
                self.loadFilterChartOptions()
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
    
    func selectedOption(){
        
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
