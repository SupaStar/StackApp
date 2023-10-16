//
//  PersistenceService
//  StackApp
//
//  Created by Obed Martinez on 15/10/23
//



import Foundation
import CoreData

class PersistenceService {
    private let container: NSPersistentContainer
    private let containerName: String = "StackApp"
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error loading Core Data! \(error)")
            }
        }
    }
    
    func getUser(id: String) -> UserEntity? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        do {
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                return user
            }
        } catch {
            print("Error fetching user: \(error)")
            return nil
        }
        return nil
    }
    
    func saveUser(id: String) {
        let entity = UserEntity(context: container.viewContext)
        entity.id = id
        save()
    }
    
    func saveTicker(user: UserEntity, name: String, stockAcron: String, stockCountry: String, symbol: String, stock_name: String){
        let entity = SavedTickerEntity(context: container.viewContext)
        entity.name = name
        entity.stock_acron = stockAcron
        entity.stock_country = stockCountry
        entity.symbol = symbol
        entity.stock_e_name = stock_name
        user.addToTickers(entity)
        save()
    }
    
    func deleteTicker(user: UserEntity, name: String, stockAcron: String, stockCountry: String, symbol: String, stock_name: String) {
        if let tickers = user.tickers {
            for case let savedTicker as SavedTickerEntity in tickers {
                if savedTicker.name == name && savedTicker.stock_acron == stockAcron && savedTicker.stock_country == stockCountry && savedTicker.symbol == symbol && savedTicker.stock_e_name == stock_name {
                    user.removeFromTickers(savedTicker)
                    container.viewContext.delete(savedTicker)
                    save()
                    return
                }
            }
        }
    }
    
    func getAllSavedTickers(user: UserEntity) -> [SavedTickerEntity] {
        if let tickers = user.tickers {
            return tickers.allObjects as? [SavedTickerEntity] ?? []
        }
        return []
    }

    
    func hasSavedTicker(user: UserEntity, name: String, stockAcron: String, stockCountry: String, symbol: String, stock_name: String) -> Bool {
        if let tickers = user.tickers {
            for case let savedTicker as SavedTickerEntity in tickers {
                if savedTicker.name == name && savedTicker.stock_acron == stockAcron && savedTicker.stock_country == stockCountry && savedTicker.symbol == symbol && savedTicker.stock_e_name == stock_name{
                    return true
                }
            }
        }
        return false
    }
    
    func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
}


//class PortafolioService {
//
//    // MARK: PUBLIC
//
//    func addStock(name: String, marketVal: Double, symbol: String, country: String, portfolio: PortafolioEntity){
//        if portfolio.stocks?.first(where: { ($0 as? StockEntity)?.symbol == symbol }) is StockEntity {
//            // El símbolo ya existe, no se necesita crear un nuevo objeto
//            print("El símbolo ya está registrado: \(symbol)")
//            // Aquí puedes realizar otras acciones si es necesario
//            return
//        }
//        let entity = StockEntity(context: container.viewContext)
//        entity.name = name
//        entity.added_date = Date()
//        entity.value = marketVal
//        entity.symbol = symbol
//        entity.country = country
//        entity.last_price = marketVal
//        entity.modify_date = Date()
//        portfolio.addToStocks(entity)
//        applyChanges()
//    }
//
//    func addHold(stock: StockEntity, price: Double, quantity: Double, hold_date: Date, type: String = "Buy"){
//        let entity = HoldingEntity(context: container.viewContext)
//        entity.id = UUID()
//        entity.date = Date()
//        entity.price = price
//        entity.quantity = quantity
//        entity.hold_date = hold_date
//        entity.date = Date()
//        entity.type = type.lowercased()
//        stock.addToHolds(entity)
//        save()
//    }
//
//    func removeAllStocks(){
//        for savedStock in savedStocks {
//            container.viewContext.delete(savedStock)
//        }
//        applyChanges()
//    }
//
//    func deleteStocks(stocks: [StockEntity]){
//        for stock in stocks {
//            container.viewContext.delete(stock)
//        }
//        applyChanges()
//    }
//
//    func deleteHolds(holds: [HoldingEntity]) {
//        for hold in holds {
//            container.viewContext.delete(hold)
//        }
//        applyChanges()
//    }
//
//    func editPriceProm(stock: StockEntity, newPrice: Double){
//        stock.price_prom = newPrice
//        save()
//    }
//
//    func editDesiredTitles(stock: StockEntity, newAmmount: Double){
//        stock.desired_titles = newAmmount
//        save()
//    }
//
//    func editAmmount(stock: StockEntity, newAmmount: Double){
//        stock.week_ammount = newAmmount
//        save()
//    }
//
//    func getHolds(stock: StockEntity) -> [HoldingEntity] {
//        guard let stock = findStock(stock: stock, symbol: nil) else {
//            return []
//        }
//        if let holds = stock.holds {
//            var holdsS = holds.allObjects as! [HoldingEntity]
//            holdsS.sort { (hold1, hold2) in
//                return hold1.hold_date! > hold2.hold_date!
//            }
//            return holdsS
//        }
//        return []
//    }
//
//    func findStock(stock: StockEntity?, symbol: String?) -> StockEntity? {
//        var symbolF = ""
//        if let stock = stock {
//            guard let symbolS = stock.symbol else {
//                return nil
//            }
//            symbolF = symbolS
//        }
//        if let symbol = symbol {
//            symbolF = symbol
//        }
//        if let stockSel = savedStocks.first(where: { $0.symbol == symbolF }) {
//            return stockSel
//        }
//        return nil
//    }
//
//    func getStocks(portfolio: PortafolioEntity) -> [StockEntity] {
//        var finalStocks: [StockEntity] = []
//        if let stocks = portfolio.stocks {
//            var stocksL = stocks.allObjects as! [StockEntity]
//            stocksL.sort { (stock1, stock2) in
//                return stock1.added_date! < stock2.added_date!
//            }
//            finalStocks = stocksL
//        }
//        return finalStocks
//    }
//
//    func updateValue(stock: StockEntity, value: Double){
//        self.update(entity: stock, newValue: value)
//    }
//    // MARK: PRIVATE
//
//    func refreshStockData(stock: StockEntity, isEdit: Bool = false){
//        if let holds = stock.holds {
//            let savedHolds = holds.allObjects as! [HoldingEntity]
//            var totalPrice: Double = 0
//            var totalQuantity: Double = 0
//            for hold in savedHolds {
//                if hold.type == "buy"{
//                    totalPrice += hold.price * hold.quantity
//                    totalQuantity += hold.quantity
//                } else {
//                    totalPrice -= hold.price * hold.quantity
//                    totalQuantity -= hold.quantity
//                }
//            }
//            if !isEdit {
//                stock.price_prom = totalPrice / totalQuantity
//            }
//            stock.quantity = totalQuantity
//            applyChanges()
//        }
//    }
//
//    private func getPortfolio(){
//        let request = NSFetchRequest<PortafolioEntity>(entityName: entityName)
//        do {
//            portFolios = try container.viewContext.fetch(request)
//            if portFolios.isEmpty {
//                addPortfolio(name: "Inversiones")
//                getPortfolio()
//            } else {
//                getStocks()
//            }
//        } catch let error {
//            print("Error fetching Portfolio Entities. \(error)")
//        }
//    }
//
//    private func addPortfolio(name: String){
//        let entity = PortafolioEntity(context: container.viewContext)
//        entity.id = UUID()
//        entity.name = name
//        applyChanges()
//    }
//
//    private func getStocks() {
//        guard let portfolio = portFolios.first else {
//            return
//        }
//        if let stocks = portfolio.stocks {
//            savedStocks = stocks.allObjects as! [StockEntity]
//            savedStocks.sort { (stock1, stock2) in
//                return stock1.added_date! < stock2.added_date!
//            }
//            //            for stock in savedStocks {
//            //                if let holds = stock.holds {
//            //                    let savedHolds = holds.allObjects as! [HoldingEntity]
//            //                    var totalPrice: Double = 0
//            //                    var totalQuantity: Double = 0
//            //                    for hold in savedHolds {
//            //                        totalPrice += hold.price * hold.quantity
//            //                        totalQuantity += hold.quantity
//            //                    }
//            //                    stock.price_prom = totalPrice / totalQuantity
//            //                    stock.quantity = totalQuantity
//            //                    save()
//            //                }
//            //            }
//        }
//    }
//
//    private func update(entity: StockEntity, newValue: Double) {
//        entity.last_price = entity.value
//        entity.value = newValue
//        entity.modify_date = Date()
//        applyChanges()
//    }
//
//    private func delete(entity: StockEntity) {
//        container.viewContext.delete(entity)
//        applyChanges()
//    }
//
//
//    private func save() {
//        do {
//            try container.viewContext.save()
//        } catch let error {
//            print("Error saving to Core Data. \(error)")
//        }
//    }
//
//    private func applyChanges() {
//        save()
//        getPortfolio()
//    }
//}
