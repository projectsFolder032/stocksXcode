//
//  ViewController.swift
//  Upstock
//
//  Created by Nikita Arora on 17/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    private let viewModel = HoldingsViewModel()
    private let summaryView = PortfolioSummaryView()
    private let tableView = UITableView()
    private let bottomView = UIView()
    private let profitLossButton = UIButton()
    private let profitLossAmountLabel = UILabel()
    private var activityIndicator = UIActivityIndicatorView(style: .large)
    private var isSummaryVisible = false
    private let summaryHeight: CGFloat = 120
    private var summaryHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let topBorder = CALayer()
        topBorder.backgroundColor = UIColor.systemGray4.cgColor
        topBorder.frame = CGRect(x: 0, y: 0, width: bottomView.frame.width, height: 1)
        bottomView.layer.addSublayer(topBorder)
    }

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "Holdings"
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        // Table View
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isHidden = true
        tableView.register(HoldingCell.self, forCellReuseIdentifier: "HoldingCell")
        view.addSubview(tableView)

        // Summary View
        summaryView.translatesAutoresizingMaskIntoConstraints = false
        summaryView.backgroundColor = UIColor(white: 0.95, alpha: 1) // Light grey
        summaryView.layer.cornerRadius = 10
        summaryView.clipsToBounds = true
        view.addSubview(summaryView)

        // Bottom View
        bottomView.backgroundColor = UIColor.init(hexString: "#f5f5f5")
        bottomView.isHidden = true
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomView)

        // Profit & Loss Label and button
        profitLossAmountLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        profitLossAmountLabel.textColor = .red
        profitLossAmountLabel.textAlignment = .right
        profitLossAmountLabel.translatesAutoresizingMaskIntoConstraints = false
       
        profitLossButton.setTitle("Profit & Loss* ▲", for: .normal)
        profitLossButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        profitLossButton.setTitleColor(.black, for: .normal)
        profitLossButton.titleLabel?.textAlignment = .center
        profitLossButton.translatesAutoresizingMaskIntoConstraints = false
        profitLossButton.addTarget(self, action: #selector(toggleSummaryView), for: .touchUpInside)
        bottomView.addSubview(profitLossButton)
        bottomView.addSubview(profitLossAmountLabel)
        
        // Add Constraints
        setupConstraints()
    }

    private func setupConstraints() {
        // Summary View Constraints
        summaryHeightConstraint = summaryView.heightAnchor.constraint(equalToConstant: 0)

        NSLayoutConstraint.activate([
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            // Summary View Constraints
            summaryHeightConstraint,
            summaryView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            summaryView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            summaryView.bottomAnchor.constraint(equalTo: bottomView.topAnchor, constant:0),

            // Table View Constraints
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),

            // Bottom View Constraints
            bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 60),

            // Profit & Loss Label Constraints
            profitLossButton.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            profitLossButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 16),
            
            profitLossAmountLabel.centerYAnchor.constraint(equalTo: bottomView.centerYAnchor),
            profitLossAmountLabel.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -16),
            profitLossAmountLabel.leadingAnchor.constraint(equalTo: profitLossButton.trailingAnchor, constant: 8)
        ])
    }

    @objc private func toggleSummaryView() {
        isSummaryVisible.toggle()

        summaryHeightConstraint.constant = isSummaryVisible ? summaryHeight : 0

        profitLossButton.setTitle(isSummaryVisible ? "Profit & Loss* ▼" : "Profit & Loss* ▲", for: .normal)

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }

    private func fetchData() {
        activityIndicator.startAnimating()
        viewModel.fetchHoldings { [weak self] result in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                switch result {
                case .success:
                    self?.summaryView.configure(with: self!.viewModel)
                    self?.tableView.isHidden = false // Show table view
                    self?.bottomView.isHidden = false
                    self?.configurePnlView()
                    self?.tableView.reloadData()
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func configurePnlView() {
        let totalPNL = viewModel.totalPNL
        let pnlPercent = totalPNL / viewModel.totalInvestment
        
        let formattedPnlPercent = String(format: "%.2f", pnlPercent * 100)
        
        if totalPNL >= 0 {
            let attrText = Utility.getAttrString(s1: "₹\(String(format: "%.2f", totalPNL))", s2: "(\(formattedPnlPercent)%)", color: UIColor.systemGreen, size1: 14, size2: 12)
            profitLossAmountLabel.attributedText = attrText
        } else {
            let attrText = Utility.getAttrString(s1: "₹\(String(format: "%.2f", totalPNL))", s2: "(\(formattedPnlPercent)%)", color: UIColor.systemRed, size1: 14, size2: 12)
            profitLossAmountLabel.attributedText = attrText
        }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.holdings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HoldingCell", for: indexPath) as! HoldingCell
        let holding = viewModel.holdings[indexPath.row]
        cell.configure(with: holding)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
