//
//  APIClient.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 11/05/25.
//

import Foundation

protocol APIClientProtocol {
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void)
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    func fetchTransactions(completion: @escaping (Result<[Transaction], Error>) -> Void) {
        let url = URL(string: "https://run.mocky.io/v3/972030d5-66d9-40f6-8ec7-1cf842bf1e06")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(NetworkError.requestFailed(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let transactions = try JSONDecoder().decode([Transaction].self, from: data)
                completion(.success(transactions))
            } catch {
                completion(.failure(NetworkError.decodingFailed))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case requestFailed(Error)
    case noData
    case decodingFailed
}
