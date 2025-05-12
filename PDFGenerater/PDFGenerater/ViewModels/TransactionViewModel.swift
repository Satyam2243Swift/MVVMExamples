//
//  TransactionViewModel.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 11/05/25.
//

import Foundation

class TransactionViewModel {
    
    private let apiClient: APIClient
    var transactions: [Transaction] = []
    
    var isLoading: ((Bool) -> Void)?
    var onError: ((String) -> Void)?
    var onDataUpdated: (() -> Void)?
    
    init(apiClient: APIClient = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func loadTransactions() {
        isLoading?(true)
        apiClient.fetchTransactions { [weak self] result in
            switch result {
            case .success(let transactions):
                self?.transactions = transactions
                self?.onDataUpdated?()
                self?.saveToCoreData(transactions) // Saving in Core Data
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                let errorMessage = error.localizedDescription
                self?.onError?(errorMessage)
                self?.loadFromCoreData() // Loading Offline Data
            }
            self?.isLoading?(false)
            
        }
    }
    
    private func saveToCoreData(_ transactions: [Transaction]) {
       
    }
    
    private func loadFromCoreData() {
      
    }
}
