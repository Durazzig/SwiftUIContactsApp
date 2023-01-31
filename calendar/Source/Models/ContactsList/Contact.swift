//
//  Contact.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import Foundation

struct Contact: Hashable, Codable {
    let title: String
    let body: String
    let createdAt: String
    
    
    func formattedData() {
        print(self)
    }
    
}
