//
//  TransactionsViewController.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 11/05/25.
//


import UIKit

class TransactionsViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var generatePDFButton: UIButton!
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Properties
    private let loadingView = LoadingView()
    private let snackbar = SnackbarView()
    private let viewModel = TransactionViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        registerXIB()
        viewModel.loadTransactions()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        tableView.dataSource = self
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        
        generatePDFButton.addTarget(self, action: #selector(generatePDFTapped), for: .touchUpInside)
        generatePDFButton.layer.cornerRadius = 10
        
    }
    
    private func registerXIB() {
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionTableViewCell")
    }
    
    // MARK: - Bindings
    private func setupBindings() {
        viewModel.isLoading = { [weak self] isLoading in
            DispatchQueue.main.async {
                isLoading ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
            }
           
        }
        
        viewModel.onError = { [weak self] errorMessage in
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
        
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView?.reloadData()
            }
        }
    }
    
    // MARK: - PDF Generation
    @objc private func generatePDFTapped() {
        
        loadingView.show(in: view) // Show loader
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let transactions = self?.viewModel.transactions else { return }
            let pdfData = PDFGenerator.generatePDF(transactions: transactions)
            
            DispatchQueue.main.async {
                self?.loadingView.hide() // Hide loader
                self?.sharePDF(data: pdfData)
            }
        }
    }
    
    // MARK: - Helpers
    private func sharePDF(data: Data) {
        let tempURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("Report_\(Date()).pdf")
        
        do {
            try data.write(to: tempURL)
            let activityVC = UIActivityViewController(
                activityItems: [tempURL],
                applicationActivities: nil
            )
            
            activityVC.completionWithItemsHandler = { [weak self] _, success, _, _ in
                if success {
                    self?.snackbar.show(message: "Saved to Files ✅", in: self!.view)
                }
            }
            
            present(activityVC, animated: true)
        } catch {
            print("PDF Save Error: \(error)")
        }
    }
    
    
    
}

// MARK: - UITableViewDataSource
extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as? TransactionTableViewCell else { return UITableViewCell() }
        let transaction = viewModel.transactions[indexPath.row]
        cell.configure(with: transaction)
        return cell
    }
}
