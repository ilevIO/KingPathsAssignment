//
//  ChessBoardAssignmentTests.swift
//  ChessBoardAssignmentTests
//
//  Created by Ilya Yelagov on 2/25/21.
//

import XCTest
@testable import ChessBoardAssignment

class BoardTests: XCTestCase {
    let maxPathsCount = 20
    let maxPathLength = 10
    
    func testCellSelection(intendedCell: ChessPosition, boardSize: Int) {
        let board = Board()
        board.size = boardSize
        board.maxFindPathsCount = maxPathsCount
        board.maxFindPathLength = maxPathLength
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        XCTAssertEqual(board.startPosition, intendedCell)
    }
    
    func testMinEdgeCellSelection() {
        testCellSelection(
            intendedCell: ChessPosition(row: 0, column: 0),
            boardSize: 6
        )
    }
    
    func testMaxEdgeCellSelection() {
        let boardSize = 6
        
        testCellSelection(
            intendedCell: ChessPosition(row: boardSize - 1, column: boardSize - 1),
            boardSize: 6
        )
    }

    func testBoardStartPositionSelection() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        board.maxFindPathsCount = maxPathsCount
        board.maxFindPathLength = maxPathLength
        
        let intendedCell = ChessPosition(row: 0, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        XCTAssertEqual(board.startPosition, intendedCell)
        XCTAssertEqual(board.state, .setEndPosition)
    }
    
    func testBoardEndPositionSelection() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        board.maxFindPathsCount = maxPathsCount
        board.maxFindPathLength = maxPathLength
        
        let intendedStartCell = ChessPosition(row: 0, column: 0)
        let intendedEndCell = ChessPosition(row: 1, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedStartCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedStartCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedEndCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedEndCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssertEqual(board.endPosition, intendedEndCell)
        XCTAssertEqual(board.state, .performSearch)
    }
    
    func testSameCellSelected() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        board.maxFindPathsCount = maxPathsCount
        board.maxFindPathLength = maxPathLength
        
        let intendedCell = ChessPosition(row: 0, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssertEqual(board.startPosition, intendedCell)
        XCTAssertEqual(board.state, .setEndPosition)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssertNil(board.endPosition)
        XCTAssertEqual(board.state, .setEndPosition)
    }
    
    func testPathFinding() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        board.maxFindPathsCount = maxPathsCount
        board.maxFindPathLength = maxPathLength
        
        let intendedStartCell = ChessPosition(row: 0, column: 0)
        let intendedEndCell = ChessPosition(row: 1, column: 0)
        let expectation = self.expectation(description: #function)
        
        board.findFigurePathsCompletion = { foundPaths in
            XCTAssertFalse(foundPaths.isEmpty)
            expectation.fulfill()
        }
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedStartCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedStartCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedEndCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedEndCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssertEqual(board.state, .performSearch)
        XCTAssertFalse(board.selectedCells.isEmpty)
        waitForExpectations(timeout: 10)
        XCTAssertNotNil(board.foundPaths)
    }
    
    func testBoardClear() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        board.maxFindPathsCount = maxPathsCount
        board.maxFindPathLength = maxPathLength
        
        let intendedStartCell = ChessPosition(row: 0, column: 0)
        let intendedEndCell = ChessPosition(row: 1, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedStartCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedStartCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedEndCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedEndCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        board.clear()
        XCTAssertEqual(board.state, .setStartPosition)
        XCTAssertNil(board.startPosition)
        XCTAssertNil(board.endPosition)
        XCTAssertNil(board.foundPaths)
        XCTAssertTrue(board.selectedCells.isEmpty)
    }
}
