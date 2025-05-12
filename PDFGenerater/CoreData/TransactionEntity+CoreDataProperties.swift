//
//  TransactionEntity+CoreDataProperties.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 12/05/25.
//
//

import Foundation
import CoreData


extension TransactionEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionEntity> {
        return NSFetchRequest<TransactionEntity>(entityName: "TransactionEntity")
    }

    @NSManaged public var date: String?
    @NSManaged public var narration: String?
    @NSManaged public var transactionID: String?
    @NSManaged public var status: String?
    @NSManaged public var credit: String?
    @NSManaged public var debit: String?

}

extension TransactionEntity : Identifiable {

}
