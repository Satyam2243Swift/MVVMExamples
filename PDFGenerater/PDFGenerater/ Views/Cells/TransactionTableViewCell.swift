//
//  TransactionTableViewCell.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 12/05/25.
//


import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var narrationLabel: UILabel!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCellStyle()
    }
    
    private func setupCellStyle() {
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.lightGray.cgColor
        containerView.layer.shadowOpacity = 0.1
        
        statusView.layer.cornerRadius = 4
        statusView.clipsToBounds = true
    }
    
    func configure(with transaction: Transaction) {
        dateLabel.text = transaction.date
        narrationLabel.text = transaction.narration
        statusLabel.text = transaction.status
        
        switch transaction.status {
        case "COMPLETED":
            statusView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
            statusLabel.textColor = .systemGreen
        case "PENDING":
            statusView.backgroundColor = .systemOrange.withAlphaComponent(0.2)
            statusLabel.textColor = .systemOrange
        default:
            statusView.backgroundColor = .systemGray5
        }
        
        if let credit = transaction.credit, !credit.isEmpty {
            amountLabel.text = "+₹\(credit)"
            amountLabel.textColor = .systemGreen
        } else if let debit = transaction.debit, !debit.isEmpty {
            amountLabel.text = "-₹\(debit)"
            amountLabel.textColor = .systemRed
        } else {
            amountLabel.text = "N/A"
        }
    }
}
