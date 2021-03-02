//
//  ChessBoardAssignmentTests.swift
//  ChessBoardAssignmentTests
//
//  Created by Ilya Yelagov on 2/25/21.
//

import XCTest
@testable import ChessBoardAssignment

class BoardTests: XCTestCase {
    
    func testCellSelection(intendedCell: ChessPosition, boardSize: Int) {
        let board = Board()
        board.size = boardSize
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        XCTAssert(board.startPosition == intendedCell)
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
        
        let intendedCell = ChessPosition(row: 0, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        XCTAssert(board.startPosition == intendedCell)
        XCTAssert(board.state == .setEndPosition)
    }
    
    func testBoardEndPositionSelection() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        
        let intendedStartCell = ChessPosition(row: 0, column: 0)
        let intendedEndCell = ChessPosition(row: 1, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedStartCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedStartCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssert(board.startPosition == intendedStartCell)
        XCTAssert(board.state == .setEndPosition)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedEndCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedEndCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssert(board.endPosition == intendedEndCell)
        XCTAssert(board.state == .none)
    }
    
    func testSameCellSelected() {
        let board = Board()
        let boardSize = 6
        board.size = boardSize
        
        let intendedCell = ChessPosition(row: 0, column: 0)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssert(board.startPosition == intendedCell)
        XCTAssert(board.state == .setEndPosition)
        
        board.tapped(
            at: CGPoint(
                x: CGFloat(intendedCell.column)/CGFloat(boardSize) + .ulpOfOne,
                y: CGFloat(intendedCell.row)/CGFloat(boardSize) + .ulpOfOne
            )
        )
        
        XCTAssert(board.endPosition == nil)
        XCTAssert(board.state == .setEndPosition)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
