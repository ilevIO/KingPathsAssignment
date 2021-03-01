//
//  ResultsPreviewView.swift
//  ChessBoardAssignment
//
//  Created by Ilya Yelagov on 3/1/21.
//

import UIKit

class ResultsPreviewView: UIView {
    var results: [String] = .init() {
        didSet {
            updateResults()
        }
    }
    
    var paused = false {
        didSet {
            togglePaused()
        }
    }
    
    var onCancelTapped: (() -> Void)? = nil
    
    //MARK: - Subviews
    private let resultsStackView: UIStackView = .init()
    private let pauseButton: UIButton = .init()
    private let cancelButton: UIButton = .init()
    
    private func togglePaused() {
        if paused {
            pauseButton.setTitle("Resume", for: .normal)
        } else {
            pauseButton.setTitle("Pause", for: .normal)
        }
    }
    
    private func updateResults() {
        if !paused {
            resultsStackView.arrangedSubviews
                .forEach({
                    resultsStackView.removeArrangedSubview($0)
                    $0.removeFromSuperview()
                }
            )
            
            for result in results {
                let resultLabel = UILabel()
                resultLabel.text = result
                resultLabel.adjustsFontSizeToFitWidth = true
                
                resultsStackView.addArrangedSubview(resultLabel)
            }
        }
    }
    
    @objc private func pauseButtonTapped(_ sender: UIButton) {
        paused = !paused
    }
    
    @objc private func cancelButtonTapped(_ sender: UIButton) {
        onCancelTapped?()
    }
    
    //MARK: - Setup
    private func buildHierarchy() {
        addSubview(resultsStackView)
        addSubview(pauseButton)
        addSubview(cancelButton)
    }

    private func configureSubveiws() {
        resultsStackView.axis = .vertical
        resultsStackView.distribution = .equalSpacing
        resultsStackView.spacing = 2
        
        pauseButton.addTarget(self, action: #selector(pauseButtonTapped(_:)), for: .touchUpInside)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        let verticalMargin: CGFloat = 8
        let horizontalMargin: CGFloat = 8
        let verticalInset: CGFloat = 4
        
        resultsStackView.translatesAutoresizingMaskIntoConstraints = false
        resultsStackView.attach(to: self, left: 0, right: 0, top: 0)
        resultsStackView.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -verticalInset).isActive = true
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.attach(to: self, left: horizontalMargin, bottom: verticalMargin)
        
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.attach(to: self, right: horizontalMargin, bottom: verticalMargin)
    }
    
    private func setup() {
        buildHierarchy()
        configureSubveiws()
        setupLayout()
        
        togglePaused()
    }
    
    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
