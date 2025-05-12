//
//  PDFGenerator.swift
//  PDFGenerater
//
//  Created by Satyam Dixit on 11/05/25.
//
//

import UIKit

class PDFGenerator {
    static func generatePDF(transactions: [Transaction]) -> Data {
        let pageRect = CGRect(x: 0, y: 0, width: 595, height: 842)
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect)
        
        return renderer.pdfData { context in
            var currentY: CGFloat = 50
            
            // MARK: - Header Design
            func drawHeader() {
                // Logo (Right Aligned)
                if let logo = UIImage(named: "dummy_logo") {
                    let logoWidth: CGFloat = 100
                    let logoHeight: CGFloat = 50
                    let logoX = pageRect.width - logoWidth - 50
                    logo.draw(in: CGRect(x: logoX, y: currentY, width: logoWidth, height: logoHeight))
                }
                
                // User Details
                let userDetails = [
                    "Name: Lisa Iskdo",
                    "Email: iskdo@tmaul.com",
                    "Mobile: 7486005030",
                    "Card Number: ************6217",
                    "Card Type: F9F8D04L",
                    "Address: Delhi"
                ]
                
                currentY += 70
                userDetails.forEach { detail in
                    let attributedString = NSAttributedString(
                        string: detail,
                        attributes: [.font: UIFont.systemFont(ofSize: 12)]
                    )
                    attributedString.draw(at: CGPoint(x: 50, y: currentY))
                    currentY += 20
                }
            }
            
            // MARK: - First Page
            context.beginPage()
            drawHeader()
            
            // MARK: - Table Setup
            let headers = ["Date", "Narration", "Transaction ID", "Status", "Credit", "Debit"]
            currentY += 30
            drawTableRow(context: context, data: headers, yPosition: currentY, isHeader: true)
            currentY += 40
            
            // MARK: - Table Data
            for transaction in transactions {
                // New Page Check
                if currentY > pageRect.height - 100 {
                    context.beginPage()
                    currentY = 50
                    drawHeader()
                    currentY += 150
                    drawTableRow(context: context, data: headers, yPosition: currentY, isHeader: true)
                    currentY += 40
                }
                
                let rowData = [
                    transaction.date,
                    transaction.narration,
                    transaction.transactionID,
                    transaction.status,
                    transaction.credit ?? "-",
                    transaction.debit ?? "-"
                ]
                
                drawTableRow(context: context, data: rowData, yPosition: currentY)
                currentY += 40
            }
        }
    }
    
    // MARK: - Table Row Drawing
    private static func drawTableRow(
        context: UIGraphicsPDFRendererContext,
        data: [String],
        yPosition: CGFloat,
        isHeader: Bool = false
    ) {
        let columnWidths: [CGFloat] = [90, 90, 130, 80, 60, 60] // Increased Credit/Debit width
        var xPosition: CGFloat = 50
        
        for (index, text) in data.enumerated() {
            let width = columnWidths[index]
            let rect = CGRect(x: xPosition, y: yPosition, width: width, height: 40)
            
            // Header Background Color
            if isHeader {
                UIColor.darkGray.withAlphaComponent(0.7).setFill()
                context.fill(CGRect(x: xPosition, y: yPosition, width: width, height: 40))
            }
            
            // Border
            context.cgContext.stroke(rect)
            
            // Text Alignment
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            
            // Font
            let font = isHeader ? UIFont.boldSystemFont(ofSize: 12) : UIFont.systemFont(ofSize: 10)
            let textColor = isHeader ? UIColor.white : UIColor.black
            
            // Text Drawing
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: paragraphStyle
            ]
            
            text.draw(in: rect.insetBy(dx: 5, dy: 5), withAttributes: attributes)
            xPosition += width
        }
    }
}
