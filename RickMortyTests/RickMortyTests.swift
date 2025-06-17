//
//  RickMortyTests.swift
//  RickMortyTests
//
//  Created by Andres on 16/06/25.
//

import XCTest
import Testing
@testable import RickMorty

final class RickMortyTests: XCTestCase {
    
    var viewModel: CharactersViewModel!
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        
        viewModel = CharactersViewModel(session: session)
    }
    
    func testFetchCharactersSuccess() {
        let json = """
            {
              "info": {
                "next": null
              },
              "results": [
                {
                  "id": 1,
                  "name": "Rick Sanchez",
                  "status": "Alive",
                  "species": "Human",
                  "created": "2017-11-04T18:48:46.250Z",
                  "gender": "Male",
                  "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                  "origin": {
                    "name": "Earth (C-137)"
                  },
                  "location": {
                    "name": "Citadel of Ricks"
                  }
                }
              ]
            }
            """
        
        MockURLProtocol.testData = json.data(using: .utf8)
        
        let expectation = XCTestExpectation(description: "Fetch Characters")
        
        viewModel.fetchCharacters()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.characters.count, 1)
            XCTAssertEqual(self.viewModel.characters.first?.name, "Rick Sanchez")
            XCTAssertEqual(self.viewModel.characters.first?.origin.name, "Earth (C-137)")
            XCTAssertEqual(self.viewModel.characters.first?.location.name, "Citadel of Ricks")
            XCTAssertFalse(self.viewModel.isLoading)
            XCTAssertFalse(self.viewModel.hasMorePages)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
    
}
