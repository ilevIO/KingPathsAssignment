//
//  GetPathsAlgorithmTests.swift
//  ChessBoardAssignmentTests
//
//  Created by Ilya Yelagov on 3/2/21.
//

import XCTest
@testable import ChessBoardAssignment

class GetPathsAlgorithmTests: XCTestCase {
    
    func testNonExistingPaths() {
        let foundPaths = GetPathsAlgorithm(
            figure: KnightFigure(),
            source: .init(row: 0, column: 0),
            destination: .init(row: 1, column: 1),
            stepsLimit: 3,
            boardSize: 6
        ).getPaths()
        
        XCTAssert(foundPaths.isEmpty)
    }
    
    func testWithPossibleLesserSteps() {
        let supposedPaths: Set<[ChessPosition]> = [
            [
                .init(row: 0, column: 0),
                .init(row: 2, column: 1),
                .init(row: 0, column: 2)
            ]
        ]
        
        let foundPaths = GetPathsAlgorithm(
            figure: KnightFigure(),
            source: .init(row: 0, column: 0),
            destination: .init(row: 0, column: 2),
            stepsLimit: 3,
            boardSize: 6
        ).getPaths()
        
        XCTAssert(supposedPaths.count == foundPaths.count)
        for foundPath in foundPaths {
            XCTAssert(supposedPaths.contains(foundPath))
        }
    }
    
    func testPathsUniqueness() {
        let boardSize = 6
        let stepsLimit = 3
        
        //Testing for all combinations
        for startRow in 0..<boardSize {
            for startColumn in 0..<boardSize {
                let startCell = ChessPosition(row: startRow, column: startColumn)
                for endRow in 0..<boardSize {
                    for endColumn in 0..<boardSize {
                        let endCell = ChessPosition(row: endRow, column: endColumn)
                        let foundPaths = GetPathsAlgorithm(
                            figure: KnightFigure(),
                            source: startCell,
                            destination: endCell,
                            stepsLimit: stepsLimit,
                            boardSize: boardSize
                        ).getPaths()
                        let foundPathsSet = Set<[ChessPosition]>(foundPaths)
                        XCTAssert(foundPaths.count == foundPathsSet.count)
                    }
                }
            }
        }
    }
    
    func testPathsWithCellRevisiting() {
        let supposedRoutes: Set<[ChessPosition]> = [
            [
                .init(row: 0, column: 0),
                .init(row: 2, column: 1)
            ],
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 0, column: 0),
                .init(row: 2, column: 1)
            ],
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 3, column: 3),
                .init(row: 2, column: 1)
            ]
        ]
        
        let boardSize = 6
        let stepsLimit = 3
        
        let foundPaths = GetPathsAlgorithm(
            figure: KnightFigure(),
            source: ChessPosition(row: 0, column: 0),
            destination: ChessPosition(row: 2, column: 1),
            stepsLimit: stepsLimit,
            boardSize: boardSize
        ).getPaths()
        
        XCTAssert(supposedRoutes.count == foundPaths.count)
        for foundPath in foundPaths {
            XCTAssert(supposedRoutes.contains(foundPath))
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
