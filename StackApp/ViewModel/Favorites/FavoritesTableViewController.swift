//
//  FavoritesTableViewController
//  StackApp
//
//  Created by Obed Martinez on 15/10/23
//



import UIKit

class FavoritesTableViewController: UITableViewController {

    var tickers: [SavedTickerEntity] = []
    let loader = Loader()
    var persistanceS: PersistenceService = PersistenceService()
    var user: UserEntity?
    var selectedTicker: TickerModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Favorites"
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if let id = UserDefaults.standard.string(forKey: UserDefaultEnum.idUser.rawValue) {
            self.user = persistanceS.getUser(id: id)
            self.loadSaved()
        }
    }
    
    func loadSaved(){
        guard let user = self.user else {
            return
        }
        self.persistanceS = PersistenceService()
        self.tickers = persistanceS.getAllSavedTickers(user: user)
        self.tableView.reloadData()
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
        let tickerE = tickers[indexPath.row]
        let tickerSt = StockExchange(name: tickerE.stock_e_name ?? "", acronym: tickerE.stock_acron ?? "", mic: "", country: tickerE.stock_country ?? "", country_code: "", city: "")
        let tickerM = TickerModel(name: tickerE.name ?? "", symbol: tickerE.symbol ?? "", stock_exchange: tickerSt)
        cell.ticker = tickerM
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! TickerTableViewCell
        selectedTicker = cell.ticker
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "detail", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let destinationVC = segue.destination as? DetailViewController {
                destinationVC.ticker = selectedTicker
            }
        }
    }
}
