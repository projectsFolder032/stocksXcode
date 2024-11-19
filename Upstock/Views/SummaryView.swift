//
//  SummaryView.swift
//  Upstock
//
//  Created by Nikita Arora on 17/11/24.
//

import UIKit

class PortfolioSummaryView: UIView {
    
    // MARK: - UI Components
    private let currentValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Current value*"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let currentValueAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let totalInvestmentLabel: UILabel = {
        let label = UILabel()
        label.text = "Total investment*"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let totalInvestmentAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        label.textAlignment = .right
        return label
    }()
    
    private let todaysPnLLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Profit & Loss*"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .darkGray
        return label
    }()
    
    private let todaysPnLAmountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        let stackView = UIStackView(arrangedSubviews: [
            createRow(label: currentValueLabel, valueLabel: currentValueAmountLabel),
            createRow(label: totalInvestmentLabel, valueLabel: totalInvestmentAmountLabel),
            createRow(label: todaysPnLLabel, valueLabel: todaysPnLAmountLabel)
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
  
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16)
        ])
    }
    
    private func createRow(label: UILabel, valueLabel: UILabel) -> UIStackView {
        let rowStackView = UIStackView(arrangedSubviews: [label, valueLabel])
        rowStackView.axis = .horizontal
        rowStackView.distribution = .equalSpacing
        return rowStackView
    }
    
    func configure(with viewModel: HoldingsViewModel) {
        currentValueAmountLabel.text = "₹\(String(format: "%.2f", viewModel.currentValue))"
        totalInvestmentAmountLabel.text = "₹\(String(format: "%.2f", viewModel.totalInvestment))"
        if viewModel.todaysPNL < 0 {
            todaysPnLAmountLabel.textColor = UIColor.systemRed
        } else {
            todaysPnLAmountLabel.textColor = UIColor.systemGreen
        }
        todaysPnLAmountLabel.text = "₹\(String(format: "%.2f", viewModel.todaysPNL))"
    }
}
