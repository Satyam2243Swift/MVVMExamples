//
//  Transaction.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 11/05/25.
//

import Foundation

struct Transaction: Codable {
    let date: String
    let narration: String
    let transactionID: String
    let status: String
    let credit: String?
    let debit: String?
    
    // API
    enum CodingKeys: String, CodingKey {
        case date
        case narration
        case transactionID = "transactionId"
        case status
        case credit
        case debit
    }
}
