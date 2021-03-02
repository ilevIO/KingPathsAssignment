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
        XCTAssertEqual(board.state, .none)
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
        
        let intendedStartCell = ChessPosition(row: 0, column: 0)
        let intendedEndCell = ChessPosition(row: 1, column: 0)
        
        board.findFigurePathsCompletion = { foundPaths in
            XCTAssertFalse(foundPaths.isEmpty)
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
        
        XCTAssertEqual(board.state, .none)
        XCTAssertNotNil(board.foundPaths)
        XCTAssertFalse(board.selectedCells.isEmpty)
    }
    
    func testBoardClear() {
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
