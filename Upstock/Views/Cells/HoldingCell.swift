//
//  HoldingCell.swift
//  Upstock
//
//  Created by Nikita Arora on 17/11/24.
//

import UIKit

class HoldingCell: UITableViewCell {
    // MARK: - UI Components
    private let symbolLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let ltpLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let netQtyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let pnlLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.setContentHuggingPriority(.required, for: .vertical)

        return label
    }()

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        // Add subviews
        contentView.addSubview(symbolLabel)
        contentView.addSubview(ltpLabel)
        contentView.addSubview(netQtyLabel)
        contentView.addSubview(pnlLabel)

        // Set constraints
        NSLayoutConstraint.activate([
            // Symbol Label
            symbolLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            symbolLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            // LTP Label
            ltpLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            ltpLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            // Net Quantity Label
            netQtyLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 8),
            netQtyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            netQtyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // P&L Label
            pnlLabel.topAnchor.constraint(equalTo: ltpLabel.bottomAnchor, constant: 8),
            pnlLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            pnlLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    // MARK: - Configure Cell
    func configure(with holding: Holding) {
        symbolLabel.text = holding.symbol
//        ltpLabel.text = "LTP: ₹\(String(format: "%.2f", holding.ltp))"
        
        ltpLabel.attributedText = Utility.getAttrString(s1: "LTP: ", s2: "₹\(String(format: "%.2f", holding.ltp))", color: UIColor.lightGray, color2: UIColor.darkGray, size1: 14, size2: 15)
        
        netQtyLabel.attributedText = Utility.getAttrString(s1: "NET QTY: ", s2: "\(holding.quantity)", color: UIColor.lightGray, color2: UIColor.darkGray, size1: 14, size2: 15)

        let pnlVal = (holding.ltp - holding.avgPrice) * Double(holding.quantity)
        let pnlStr = (String(format: "%.2f", pnlVal))
        
        var attributedText1: NSAttributedString?
        if pnlVal >= 0 {
            attributedText1 = Utility.getAttrString(s1: "P&L: ", s2: "₹\(pnlStr)", color: .lightGray, color2: UIColor.init(hexString: "#60b290"), size1: 14, size2: 15)
        } else {
            attributedText1 = Utility.getAttrString(s1: "P&L: ", s2: "₹\(pnlStr)", color: .lightGray, color2: UIColor.init(hexString: "#cb5a5f"), size1: 14, size2: 15)
        }
        
        pnlLabel.attributedText = attributedText1
    }
}


