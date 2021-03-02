//
//  GetPathsAlgorithmTests.swift
//  ChessBoardAssignmentTests
//
//  Created by Ilya Yelagov on 3/2/21.
//

import XCTest
@testable import ChessBoardAssignment

class GetPathsAlgorithmTests: XCTestCase {
    let maxPathsCount = 5
    let maxPathLenght = 5
    
    func testNonExistingPaths() {
        let foundPaths = GetPathsAlgorithm(
            figure: KnightFigure(),
            source: .init(row: 0, column: 0),
            destination: .init(row: 9, column: 9),
            stepsLimit: 3,
            boardSize: 10,
            maxPathsCount: maxPathsCount,
            maxPathLength: maxPathLenght,
            onPathFound: { path in }
        ).getPaths()
        
        XCTAssert(foundPaths.isEmpty)
    }
    
    func testExistingPaths() {
        let supposedPaths: Set<[ChessPosition]> = [
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 2, column: 0),
                .init(row: 0, column: 1),
            ],
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 0, column: 4),
                .init(row: 2, column: 5),
                .init(row: 1, column: 3),
                .init(row: 0, column: 1),
            ],
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 2, column: 0),
                .init(row: 3, column: 2),
                .init(row: 1, column: 3),
                .init(row: 0, column: 1),
            ],
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 2, column: 0),
                .init(row: 4, column: 1),
                .init(row: 2, column: 2),
                .init(row: 0, column: 1),
            ],
            [
                .init(row: 0, column: 0),
                .init(row: 1, column: 2),
                .init(row: 2, column: 4),
                .init(row: 0, column: 3),
                .init(row: 2, column: 2),
                .init(row: 0, column: 1),
            ]
        ]
        
        let foundPaths = GetPathsAlgorithm(
            figure: KnightFigure(),
            source: .init(row: 0, column: 0),
            destination: .init(row: 0, column: 1),
            stepsLimit: 3,
            boardSize: 6,
            maxPathsCount: maxPathsCount,
            maxPathLength: maxPathLenght,
            onPathFound: { path in }
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
                            boardSize: boardSize,
                            maxPathsCount: maxPathsCount,
                            maxPathLength: maxPathLenght,
                            onPathFound: { path in }
                        ).getPaths()
                        let foundPathsSet = Set<[ChessPosition]>(foundPaths)
                        XCTAssert(foundPaths.count == foundPathsSet.count)
                    }
                }
            }
        }
    }

    func measureUpperLimitBoardSize() throws {
        self.measure {
            let boardSize = 16
            let stepsLimit = 3
            
            let _ = GetPathsAlgorithm(
                figure: KnightFigure(),
                source: ChessPosition(row: 5, column: 5),
                destination: ChessPosition(row: 5, column: 6),
                stepsLimit: stepsLimit,
                boardSize: boardSize,
                maxPathsCount: maxPathsCount,
                maxPathLength: maxPathLenght,
                onPathFound: { path in }
            ).getPaths()
        }
    }

}
