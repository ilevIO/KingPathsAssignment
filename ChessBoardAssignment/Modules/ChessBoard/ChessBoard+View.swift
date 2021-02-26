//
//  ChessBoard+View.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 2/26/21.
//

import UIKit

extension ChessBoard {
    static func view(with presenter: Presenter) -> UIViewController {
        View(with: presenter)
    }
    
    class View: UIViewController {
        static let resultCellIdentifier = "ResultCell"
        
        let presenter: Presenter!
        
        //MARK: - Subviews
        private let resetButton: UIButton = .init()
        private let boardView: BoardView = .init()
        private let expandResultsButton: UIButton = .init()
        private let resultsTableview: UITableView = .init()
        private let inputStackView: UIStackView = .init()
        private let setValuesButton: UIButton = .init()
        private let movesLimitTextField: UITextField = .init()
        private let boardSizeTextField: UITextField = .init()
        private let movesLimitLabel: UILabel = .init()
        private let boardSizeLabel: UILabel = .init()
        
        //MARK: - Constraints
        private var topContentConstraint: NSLayoutConstraint!
        
        //MARK: - Handlers
        @objc private func boardViewTapped(_ recognizer: UITapGestureRecognizer) {
            let location = recognizer.location(in: boardView)
            let point = CGPoint(x: location.x / boardView.frame.width, y: location.y / boardView.frame.height)
            presenter.boardViewTapped(at: point)
        }
        
        @objc private func resetButtonTapped(_ sender: UIButton) {
            presenter.resetTapped()
        }
        
        @objc private func setValuesButtonTapped(_ sender: UIButton) {
            guard let sizeString = boardSizeTextField.text, let movesLimitString = movesLimitTextField.text else { return }
            view.endEditing(true)
            presenter.setBoardParameters(size: sizeString, movesLimit: movesLimitString)
        }
        
        @objc func keyboardWillShow(_ notification: Notification) {
            guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
            topContentConstraint.constant = min(0, (view.frame.height - inputStackView.frame.maxY) - keyboardFrame.cgRectValue.height)
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
            UIView.animate(withDuration: duration, delay: 0) {
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            }
        }
        
        @objc func keyboardWillHide(_ notification: Notification) {
            topContentConstraint.constant = 0
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
            UIView.animate(withDuration: duration, delay: 0) {
                self.view.layoutIfNeeded()
                self.view.setNeedsDisplay()
            }
        }
        
        private func setFieldsValues() {
            movesLimitTextField.text = "\(presenter.board.movesLimit)"
            boardSizeTextField.text = "\(presenter.board.size)"
        }
        
        //MARK: - Setup
        private func buildHierarchy() {
            view.addSubview(boardView)
            view.addSubview(resetButton)
            view.addSubview(resultsTableview)
            view.addSubview(inputStackView)
            
            let boardSizeStackView = UIStackView()
            boardSizeStackView.axis = .horizontal
            boardSizeStackView.distribution = .fillEqually
            boardSizeStackView.addArrangedSubview(boardSizeLabel)
            boardSizeStackView.addArrangedSubview(boardSizeTextField)
            inputStackView.addArrangedSubview(boardSizeStackView)
            
            let movesLimitStackView = UIStackView()
            movesLimitStackView.axis = .horizontal
            movesLimitStackView.distribution = .fillEqually
            movesLimitStackView.addArrangedSubview(movesLimitLabel)
            movesLimitStackView.addArrangedSubview(movesLimitTextField)
            inputStackView.addArrangedSubview(movesLimitStackView)
            inputStackView.addArrangedSubview(setValuesButton)
        }
        
        private func configureSubviews() {
            let viewCornerRadius: CGFloat = 10
            
            boardView.configure(with: presenter.board)
            boardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(boardViewTapped(_:))))
            boardView.clipsToBounds = true
            boardView.layer.cornerRadius = viewCornerRadius
            
            resetButton.addTarget(self, action: #selector(resetButtonTapped(_:)), for: .touchUpInside)
            resetButton.setTitle("Reset", for: .normal)
            resetButton.setTitleColor(.red, for: .normal)
            
            resultsTableview.delegate = self
            resultsTableview.dataSource = self
            resultsTableview.register(UITableViewCell.self, forCellReuseIdentifier: Self.resultCellIdentifier)
            resultsTableview.layer.cornerRadius = viewCornerRadius
            resultsTableview.separatorStyle = .none
            
            movesLimitLabel.text = "Moves limit"
            boardSizeLabel.text = "Board size"
            
            movesLimitLabel.textColor = UIColor.darkGray
            boardSizeLabel.textColor = UIColor.darkGray
            
            setFieldsValues()
            
            setValuesButton.addTarget(self, action: #selector(setValuesButtonTapped(_:)), for: .touchUpInside)
            setValuesButton.setTitle("Set", for: .normal)
            setValuesButton.backgroundColor = .systemGreen
            inputStackView.axis = .vertical
            inputStackView.distribution = .fillProportionally
            
        }
        
        private func setupLayout() {
            let guide = view.safeAreaLayoutGuide
            let horizontalMargin: CGFloat = 16
            let verticalMargin: CGFloat = 16
            let verticalInset: CGFloat = 8
            let horizontalInset: CGFloat = 8
            
            resetButton.translatesAutoresizingMaskIntoConstraints = false
            topContentConstraint = resetButton.topAnchor.constraint(equalTo: guide.topAnchor)
            topContentConstraint.isActive = true
            resetButton.attach(to: guide, right: horizontalInset)
            
            boardView.translatesAutoresizingMaskIntoConstraints = false
            boardView.attach(to: guide, left: horizontalMargin, right: horizontalMargin)
            NSLayoutConstraint.activate(
                [
                    boardView.topAnchor.constraint(equalTo: resetButton.bottomAnchor, constant: verticalInset),
                    boardView.heightAnchor.constraint(equalTo: boardView.widthAnchor, multiplier: 1.0)
                ]
            )
            
            inputStackView.translatesAutoresizingMaskIntoConstraints = false
            inputStackView.attach(to: guide, left: horizontalMargin, right: horizontalMargin)
            inputStackView.topAnchor.constraint(equalTo: boardView.bottomAnchor, constant: verticalInset).isActive = true
            
            resultsTableview.translatesAutoresizingMaskIntoConstraints = false
            resultsTableview.topAnchor.constraint(equalTo: inputStackView.bottomAnchor, constant: verticalInset).isActive = true
            resultsTableview.attach(to: guide, left: horizontalMargin, right: horizontalMargin, bottom: verticalMargin)
        }
        
        private func setup() {
            buildHierarchy()
            configureSubviews()
            setupLayout()
            
            view.backgroundColor = .white
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            setup()
        }
        
        deinit {
            NotificationCenter.default.removeObserver(self)
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
    func updateBoard() {
        setFieldsValues()
        boardView.updateBoard()
        resultsTableview.reloadData()
    }
    
    func update() {
        UIView.animate(withDuration: 0.3) {
            self.resultsTableview.reloadData()
            
            self.boardView.setNeedsDisplay()
        }
    }
    
    func alert(with message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .cancel))
        
        present(alertController, animated: true, completion: nil)
    }
}

extension ChessBoard.View: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.results.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.selectedResult(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Self.resultCellIdentifier, for: indexPath)
        cell.textLabel?.text = presenter.results[indexPath.row]
        return cell
    }
    
}
