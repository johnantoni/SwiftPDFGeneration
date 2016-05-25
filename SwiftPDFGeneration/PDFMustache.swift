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

func generateMustachePDF(pdfLocation: String) -> Void {
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

        aPDFDocument.writeToFile(pdfLocation)

        
    } catch {
        print("Error occured")
    }
}

class MustachePDFPage: BasePDFPage{
    var pdfTitle:NSString = "Default PDF Title"
    var mustacheCopy = "Default Credit Information"
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
        
        self.mustacheCopy = creditInformation
    }
    
    func drawPDFMustacheCopy()
    {

        let pdfMustacheX = 1/16 * self.pdfWidth // horizontal placement (1/4 = 0.25 * 400 = 100)
        let pdfMustacheY = 1/2 * self.pdfHeight // vertical placement
        let pdfMustacheWidth = self.pdfWidth - (1/8 * self.pdfWidth) // printable width
        let pdfMustacheHeight = 1/5 * self.pdfHeight // printable height
        let mustacheFont = NSFont(name: "Helvetica", size: 20.0)
        
        let mustacheParagraphStyle = NSMutableParagraphStyle()
        mustacheParagraphStyle.alignment = NSCenterTextAlignment
        
        // add black background to show printable area used by Mustache template
        let mustacheFontAttributes = [
            NSFontAttributeName: mustacheFont ?? NSFont.labelFontOfSize(12),
            NSParagraphStyleAttributeName: mustacheParagraphStyle,
            NSForegroundColorAttributeName: NSColor.whiteColor(),
            NSBackgroundColorAttributeName: NSColor.blackColor()
        ]
        
        let mustacheRect = NSMakeRect(pdfMustacheX, pdfMustacheY, pdfMustacheWidth, pdfMustacheHeight)
        self.mustacheCopy.drawInRect(mustacheRect, withAttributes: mustacheFontAttributes)
        
    }
    
    override func drawWithBox(box: PDFDisplayBox) {
        super.drawWithBox(box)
        self.drawPDFMustacheCopy()
    }
    
}
