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
        setupCardStyle()
    }

    private func setupCardStyle() {
        // Card style
        containerView.layer.cornerRadius = 14
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowOffset = CGSize(width: 0, height: 6)
        containerView.layer.shadowRadius = 4
        containerView.backgroundColor = .white

        // Rounded badge
        statusView.layer.cornerRadius = 6
        statusView.clipsToBounds = true
    }

    func configure(with transaction: Transaction) {
        dateLabel.text = transaction.date
        narrationLabel.text = transaction.narration
        statusLabel.text = transaction.status.uppercased()

        // Status Color
        switch transaction.status.uppercased() {
        case "COMPLETED":
            statusView.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.3)
            statusLabel.textColor = .systemGreen
        case "PENDING":
            statusView.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.3)
            statusLabel.textColor = .systemOrange
        default:
            statusView.backgroundColor = UIColor.systemGray4
            statusLabel.textColor = .darkGray
        }

        // Amount
        if let credit = transaction.credit, !credit.isEmpty {
            amountLabel.text = "+₹\(credit)"
            amountLabel.textColor = .systemGreen
        } else if let debit = transaction.debit, !debit.isEmpty {
            amountLabel.text = "-₹\(debit)"
            amountLabel.textColor = .systemRed
        } else {
            amountLabel.text = "₹0.00"
            amountLabel.textColor = .gray
        }
    }
}
