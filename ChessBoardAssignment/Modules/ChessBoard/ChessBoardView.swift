//
//  ChessBoardView.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/25/21.
//

import Foundation
import UIKit

protocol ChessGameView: class {
    func update()
}

protocol ChessFigure {
    var location: ChessPosition { get set }
    func possibleMoves(in board: Board) -> [ChessPosition]
}

struct KingFigure: ChessFigure {
    var location: ChessPosition
    
    //Simplified without concerning about supposed check
    func possibleMoves(in board: Board) -> [ChessPosition] {
        var result = [ChessPosition]()
        
        for row in max(location.row - 1, 0)...min(location.row + 1, board.size - 1) {
            for column in max(location.column - 1, 0)...min(location.column + 1, board.size - 1) {
                if row != location.row || column != location.column {
                    result.append(.init(row: row, column: column))
                }
            }
        }
        return result
    }
}

struct ChessPosition: Hashable {
    var row: Int
    var column: Int
}

enum BoardState {
    case setStartPosition
    case setEndPosition
    case none
}

class BoardRenderer {
    weak var board: Board?
    
    func drawGrid(to layer: CALayer) {
        guard let board = board else { return }
        
        let boardSize = CGFloat(board.size)
        
        layer.frame.size = .init(width: 50 * boardSize, height: 50 * boardSize)
        layer.backgroundColor = UIColor.lightGray.cgColor
        //setAffineTransform(CGAffineTransform(scaleX: layer.bounds.width/(boardSize*50), y: layer.bounds.width/(boardSize*50)))
        layer.frame.origin = .zero
        let actualCellSize: CGFloat = 50// * layer.bounds.width / (boardSize*50)
        
        //layer.sublayerTransform = CATransform3DMakeScale(layer.bounds.width/(boardSize*50), layer.bounds.width/(boardSize*50), 1.0)
        let gridLayer = CAShapeLayer()
        layer.addSublayer(gridLayer)
        let path = CGMutablePath()
        
        let cellColor = UIColor.darkGray.cgColor
        
        for i in 0..<board.size {
            for j in 0..<board.size {
                if (j + i) % 2 == 0{
                    path.addRect(.init(x: CGFloat(i) * actualCellSize, y: CGFloat(j) * actualCellSize, width: actualCellSize, height: actualCellSize))
                }
            }
        }
        gridLayer.fillColor = cellColor
        gridLayer.path = path
        
        for selectedCell in board.selectedCells {
            let path = CGMutablePath()
            path.addRect(.init(x: CGFloat(selectedCell.column) * actualCellSize, y: CGFloat(selectedCell.row) * actualCellSize, width: actualCellSize, height: actualCellSize))
            let selectedLayer = CAShapeLayer()
            selectedLayer.path = path
            selectedLayer.fillColor = UIColor.red.cgColor
            layer.addSublayer(selectedLayer)
        }
        //gridLayer.frame = layer.bounds
    }
    
    func drawResults(_ results: [[ChessPosition]], to layer: CALayer) {
        let pathLine = CGMutablePath()
    }
    
    func render(to layer: CALayer) {
        drawGrid(to: layer)
    }
    
    init(board: Board) {
        self.board = board
    }
}

class BoardView: UIView {
    var boardRenderer: BoardRenderer!
    
    private var renderLayer: CALayer = .init()
    
    func configure(with board: Board) {
        self.boardRenderer = board.renderer
    }
    
    override func draw(_ rect: CGRect) {
        //let context = UIGraphicsGetCurrentContext()!
        
        renderLayer.removeFromSuperlayer()
        renderLayer = .init()
        
        boardRenderer.render(to: renderLayer)
        renderLayer.transform = CATransform3DMakeScale(self.layer.bounds.width/renderLayer.bounds.width, self.layer.bounds.height/renderLayer.bounds.height, 1.0)
        renderLayer.frame = self.layer.bounds
        self.layer.addSublayer(renderLayer)
        self.layer.cornerRadius = 10
    }
}

extension ChessBoard {
    
    static func view(with presenter: Presenter) -> UIViewController {
        View(with: presenter)
    }
    
    class View: UIViewController {
        let presenter: Presenter!
        
        //MARK: - Subviews
        let resetButton: UIButton = .init()
        let boardView: BoardView = .init()
        let expandResultsButton: UIButton = .init()
        let resultsTableview: UITableView = .init()
        
        //MARK: - Handlers
        @objc func boardViewTapped(_ recognizer: UITapGestureRecognizer) {
            let location = recognizer.location(in: boardView)
            let point = CGPoint(x: location.x / boardView.frame.width, y: location.y / boardView.frame.height)
            presenter.boardViewTapped(at: point)
        }
        
        @objc func resetButtonTapped(_ sender: UIButton) {
            presenter.resetTapped()
        }
        
        //MARK: - Setup
        private func buildHierarchy() {
            view.addSubview(boardView)
            view.addSubview(resetButton)
            view.addSubview(resultsTableview)
        }
        
        private func configureSubviews() {
            boardView.configure(with: presenter.board)
            boardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(boardViewTapped(_:))))
            
            resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
            resetButton.setTitle("Reset", for: .normal)
            
            resultsTableview.delegate = self
            resultsTableview.dataSource = self
            resultsTableview.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
        }
        
        private func setupLayout() {
            let guide = view.safeAreaLayoutGuide
            let horizontalMargin: CGFloat = 16
            let verticalMargin: CGFloat = 16
            let verticalInset: CGFloat = 8
            let horizontalInset: CGFloat = 8
            
            resetButton.translatesAutoresizingMaskIntoConstraints = false
            resetButton.attach(to: boardView, right: horizontalInset, top: verticalInset)
            
            boardView.translatesAutoresizingMaskIntoConstraints = false
            boardView.attach(to: guide, left: horizontalMargin, right: horizontalMargin, top: verticalMargin)
            boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor, multiplier: 1.0).isActive = true
            
            resultsTableview.translatesAutoresizingMaskIntoConstraints = false
            resultsTableview.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: verticalInset).isActive = true
            resultsTableview.attach(to: guide, left: horizontalMargin, right: horizontalMargin, bottom: verticalMargin)
            
        }
        
        private func setup() {
            buildHierarchy()
            configureSubviews()
            setupLayout()
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setup()
        }
        
        init(with presenter: Presenter) {
            self.presenter = presenter
            super.init(nibName: nil, bundle: nil)
            presenter.view = self
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}

extension ChessBoard.View: ChessGameView {
    func update() {
        resultsTableview.reloadData()
        
        boardView.setNeedsDisplay()
    }
}

extension ChessBoard.View: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        cell.textLabel?.text = presenter.results[indexPath.row]
        return cell
    }
    
}
