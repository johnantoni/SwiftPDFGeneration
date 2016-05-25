//
//  PDFMustache.swift
//  SwiftPDFGeneration
//
//  Created by John Griffiths on 2016-05-25.
//  Copyright © 2016 Knowstack. All rights reserved.
//

import Foundation

import Mustache

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
        
    } catch {
        print("Error occured")
    }
}

