//
//  HoldingsViewModel.swift
//  Upstock
//
//  Created by Nikita Arora on 17/11/24.
//

import UIKit

class HoldingsViewModel {
    
    private(set) var holdings: [Holding] = []
    
    var currentValue: Double {
        holdings.reduce(0) { $0 + ($1.ltp * Double($1.quantity)) }
    }
    
    var totalInvestment: Double {
        holdings.reduce(0) { $0 + ($1.avgPrice * Double($1.quantity)) }
    }
    
    var totalPNL: Double {
        currentValue - totalInvestment
    }
    
    var todaysPNL: Double {
        holdings.reduce(0) { $0 + (($1.close - $1.ltp) * Double($1.quantity)) }
    }
    
    func fetchHoldings(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkingManager.shared.fetchHoldings { [weak self] result in
            switch result {
            case .success(let holdings):
                self?.holdings = holdings
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getAttrString(s1: String, s2: String, color: UIColor) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(
            string: "\(s1)",
            attributes: [
                .foregroundColor: color,
                .font: UIFont.systemFont(ofSize: 14, weight: .semibold)
            ]
        )
        attributedText.append(
            NSAttributedString(
                string: "\(s2)",
                attributes: [
                    .foregroundColor: color,
                    .font: UIFont.systemFont(ofSize: 12)
                ]
            )
        )
        
        return attributedText
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
