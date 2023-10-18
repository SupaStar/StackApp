//
//  HomeTableViewTests
//  StackAppTests
//
//  Created by Obed Martinez on 16/10/23
//



import XCTest
@testable import StackApp

final class HomeTableViewTests: XCTestCase {
    
    var viewController: HomeTableViewController!
    
    override func setUpWithError() throws {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeTableViewController") as! HomeTableViewController
        vc.tickerVM = TickerRequestViewModel(dataService: TickersRequest())
        viewController = vc
        viewController.loadViewIfNeeded()
    }
    
    override func tearDownWithError() throws {
        viewController = nil
    }
    
    func test_LoadViewController() throws{
        let tableView = try XCTUnwrap(viewController.tableView, "Funciono")
        let tickerVM = try XCTUnwrap(viewController.tickerVM, "Funciono")
        let tickers = XCTAssertTrue(viewController.tickers.count == 0, "Variable inicializada")
    }
    
    func test_SearchBar() throws {
        let tableView = try XCTUnwrap(viewController.tableView, "Funciono")
        
        let expLoading = expectation(description: "Load of view")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            expLoading.fulfill()
        })
        
        waitForExpectations(timeout: 3.0)
        
        guard let header = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? SearchTickerTableViewCell else {
            XCTFail("No existe")
            return
        }
        XCTAssertTrue(header.searchTxt.text == "")
    }
    
    func test_SearchWithSearchBar() throws {
        let tableView = try XCTUnwrap(viewController.tableView, "Funciono")
        
        let expLoading = expectation(description: "Load of view")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            expLoading.fulfill()
        })
        
        wait(for: [expLoading], timeout: 3.0)

        guard let header = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as? SearchTickerTableViewCell else {
            XCTFail("No existe")
            return
        }
        header.searchTxt.text = "AAPL"
        
        let expWait = expectation(description: "Wait event")

        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
            expWait.fulfill()
        })
        
        wait(for: [expWait], timeout: 6.0)
        
        viewController.tickerVM.didFinishFetch = {
            let tickers = self.viewController.tickerVM.tickers ?? []
            XCTAssertTrue(tickers.count > 0, "Se obtuvieron resultados")
        }
    }
    
    func test_LoadTickers() throws {
        viewController.loadTickers()
        viewController.tickerVM.didFinishFetch = {
            let tickers = self.viewController.tickerVM.tickers ?? []
            XCTAssertTrue(tickers.count > 0, "Se obtuvieron resultados")
        }
    }
    
    func test_HideLoader() throws{
        viewController.loadTickers()
        viewController.tickerVM.didFinishFetch = {
            self.viewController.hideLoader(delayTime: 0)
            XCTAssertTrue(self.viewController.numberPetitions == 0, "Peticiones en 0")
            XCTAssertFalse(self.viewController.isLoading, "El loader cambio")
        }
    }
    
    func test_BiometricsFlagActivated() throws{
        if let logedBefore = UserDefaults.standard.string(forKey: UserDefaultEnum.logedBefore.rawValue) {
            XCTAssertTrue(logedBefore == "1", "Se creo la bandera")
        } else{
            XCTAssertThrowsError("No se creo la bandera")
        }
    }
    
    func testCreateSpinnerFooter() throws {
        let footerView = viewController.createSpinnerFooter()
        
        // Verifica que se haya creado una vista
        XCTAssertNotNil(footerView)
        
        // Verifica que la vista tenga las dimensiones correctas
        XCTAssertEqual(footerView.frame.origin.x, 0)
        XCTAssertEqual(footerView.frame.origin.y, 0)
        XCTAssertEqual(footerView.frame.size.width, viewController.view.frame.size.width)
        XCTAssertEqual(footerView.frame.size.height, 100)
        
        // Verifica que se haya agregado un UIActivityIndicatorView
        let spinner = footerView.subviews.first { $0 is UIActivityIndicatorView } as? UIActivityIndicatorView
        XCTAssertNotNil(spinner)
        
        // Verifica que el spinner esté animando
        XCTAssertTrue(spinner?.isAnimating ?? false)
    }
    
}
