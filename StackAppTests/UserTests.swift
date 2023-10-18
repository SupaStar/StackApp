//
//  UserTests
//  StackAppTests
//
//  Created by Obed Martinez on 16/10/23
//



import XCTest
@testable import StackApp
import FirebaseAuth

final class UserTests: XCTestCase {
    var persistanceS: PersistenceService!
    let email = "a@a.com"
    let password = "aaaaaaaa"
    override func setUpWithError() throws {
        self.persistanceS = PersistenceService()
    }
    
    override func tearDownWithError() throws {
        self.persistanceS = nil
    }
    
    func test_Login() {
        let expLoading = expectation(description: "Login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
            expLoading.fulfill()
        })
        
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                XCTFail("\(error)")
                return
            }
            
            if let error = error {
                XCTFail("Error al iniciar sesión: \(error.localizedDescription)")
                return
            }
            
            do {
                _ = try XCTUnwrap(authResult?.user.uid)
            } catch {
                XCTFail("No se pudo obtener el ID del usuario: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 10.0)
    }
    
    func test_GetUser() {
        let expLoading = expectation(description: "Login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
            expLoading.fulfill()
        })
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if error != nil {
                XCTFail("\(error)")
                return
            }
            
            if let userId = authResult?.user.uid {
                var user = self.persistanceS.getUser(id: userId)
                if user == nil {
                    self.persistanceS.saveUser(id: userId)
                    user = self.persistanceS.getUser(id: userId)
                }
                XCTAssert(user != nil, "El usuario fue creado o ya existía")
            } else {
                XCTFail("Error")
            }
        }
        waitForExpectations(timeout: 10.0)
    }
    
    func test_GetAllTickersSaved() {
        let expLoading = expectation(description: "Login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
            expLoading.fulfill()
        })
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            do {
                if let error = error {
                    XCTFail("Error al iniciar sesión: \(error.localizedDescription)")
                    return
                }
                
                guard let userId = authResult?.user.uid else {
                    XCTFail("No se pudo obtener el ID del usuario")
                    return
                }
                
                var user = self.persistanceS.getUser(id: userId)
                if user == nil {
                    self.persistanceS.saveUser(id: userId)
                    user = self.persistanceS.getUser(id: userId)
                }
                
                let userUnwrap = try XCTUnwrap(user)
                let tickers = try XCTUnwrap(self.persistanceS.getAllSavedTickers(user: userUnwrap))
            } catch {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 10.0)
    }
    
    
    func test_SaveNewTicker() {
        let expLoading = expectation(description: "Login")
        DispatchQueue.main.asyncAfter(deadline: .now() + 8, execute: {
            expLoading.fulfill()
        })
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            do {
                if let error = error {
                    XCTFail("Error al iniciar sesión: \(error.localizedDescription)")
                    return
                }
                
                guard let userId = authResult?.user.uid else {
                    XCTFail("No se pudo obtener el ID del usuario")
                    return
                }
                
                var user = self.persistanceS.getUser(id: userId)
                if user == nil {
                    self.persistanceS.saveUser(id: userId)
                    user = self.persistanceS.getUser(id: userId)
                }
                
                let userUnwrap = try XCTUnwrap(user)
                self.persistanceS.saveTicker(user: userUnwrap, name: "test", stockAcron: "test", stockCountry: "test", symbol: "test", stock_name: "test")
                let tickers = try XCTUnwrap(self.persistanceS.getAllSavedTickers(user: userUnwrap))
                XCTAssert(tickers.count > 0)
            } catch {
                XCTFail("Error: \(error.localizedDescription)")
            }
        }
        waitForExpectations(timeout: 10.0)
    }
    
}
