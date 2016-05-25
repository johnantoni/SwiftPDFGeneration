//
//  PDFMustache.swift
//  SwiftPDFGeneration
//
//  Created by John Griffiths on 2016-05-25.
//  Copyright © 2016 Knowstack. All rights reserved.
//

import Foundation

import Mustache
import Quartz

func generateMustachePDF() -> Void {
    // Load the `document.mustache` resource of the main bundle
    
    do {
        let template = try Template(named: "document")
        
        // Let template format dates with `{{format(...)}}`
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        template.registerInBaseContext("format", Box(dateFormatter))
        
        // The rendered data
        let data = [
            "name": "Arthur",
            "date": NSDate(),
            "realDate": NSDate().dateByAddingTimeInterval(60*60*24*3),
            "late": true
        ]
        
        // The rendering: "Hello Arthur..."
        let rendering = try template.render(Box(data))

        let coverPage = MustachePDFPage(hasMargin: true,
                                     title: "This is the cover page title. Keep it short or keep it long",
                                     creditInformation: rendering,
                                     headerText: "Some confidential info",
                                     footerText: "www.knowstack.com",
                                     pageWidth: CGFloat(900.0),
                                     pageHeight: CGFloat(1200.0),
                                     hasPageNumber: true,
                                     pageNumber: 1)
        
        let aPDFDocument = PDFDocument()

        aPDFDocument.insertPage(coverPage, atIndex: 0)

        aPDFDocument.writeToFile("/Users/john/Desktop/test.pdf")

        
    } catch {
        print("Error occured")
    }
}

class MustachePDFPage: BasePDFPage{
    var pdfTitle:NSString = "Default PDF Title"
    var creditInformation = "Default Credit Information"
    var textParagraph = "something"
    
    init(hasMargin:Bool,
         title:String,
         creditInformation:String,
         headerText:String,
         footerText:String,
         pageWidth:CGFloat,
         pageHeight:CGFloat,
         hasPageNumber:Bool,
         pageNumber:Int)
    {
        super.init(hasMargin: hasMargin,
                   headerText: headerText,
                   footerText: footerText,
                   pageWidth: pageWidth,
                   pageHeight: pageHeight,
                   hasPageNumber: hasPageNumber,
                   pageNumber: pageNumber)
        
        self.pdfTitle = title
        self.creditInformation = creditInformation
    }
    
    func drawPDFTitle()
    {
        let pdfTitleX = 1/4 * self.pdfWidth
        let pdfTitleY = self.pdfHeight / 2
        let pdfTitleWidth = 1/2 * self.pdfWidth
        let pdfTitleHeight = 1/5 * self.pdfHeight
        let titleFont = NSFont(name: "Helvetica Bold", size: 30.0)
        
        let titleParagraphStyle = NSMutableParagraphStyle()
        titleParagraphStyle.alignment = NSCenterTextAlignment
        
        let titleFontAttributes = [
            NSFontAttributeName: titleFont ?? NSFont.labelFontOfSize(12),
            NSParagraphStyleAttributeName:titleParagraphStyle,
            NSForegroundColorAttributeName: NSColor.blueColor()
        ]
        
        let titleRect = NSMakeRect(pdfTitleX, pdfTitleY, pdfTitleWidth, pdfTitleHeight)
        self.pdfTitle.drawInRect(titleRect, withAttributes: titleFontAttributes)
        
    }
    
    func drawPDFCreditInformation()
    {
        let pdfCreditX = 1/4 * self.pdfWidth
        let pdfCreditY = self.pdfHeight / 2 - 1/5 * self.pdfHeight
        let pdfCreditWidth = 1/2 * self.pdfWidth
        let pdfCreditHeight = CGFloat(40.0)
        let creditFont = NSFont(name: "Helvetica", size: 15.0)
        
        let creditParagraphStyle = NSMutableParagraphStyle()
        creditParagraphStyle.alignment = NSCenterTextAlignment
        
        let creditFontAttributes = [
            NSFontAttributeName: creditFont ?? NSFont.labelFontOfSize(12),
            NSParagraphStyleAttributeName:creditParagraphStyle,
            NSForegroundColorAttributeName: NSColor.darkGrayColor()
        ]
        
        let creditRect = NSMakeRect(pdfCreditX, pdfCreditY, pdfCreditWidth, pdfCreditHeight)
        self.creditInformation.drawInRect(creditRect, withAttributes: creditFontAttributes)
        
        //self.textParagraph.drawInRect(creditRect, withAttributes: creditFontAttributes)
        
    }
    
    override func drawWithBox(box: PDFDisplayBox) {
        super.drawWithBox(box)
        self.drawPDFTitle()
        self.drawPDFCreditInformation()
    }
    
}
