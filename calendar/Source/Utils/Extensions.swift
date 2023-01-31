//
//  Extensions.swift
//  calendar
//
//  Created by Tadeo Durazo on 28/01/23.
//

import Foundation
import Contacts
import SwiftUI

extension CNContact {
    
    func contactImage() -> UIImage {
        
        if self.imageDataAvailable {
            let image = UIImage(data: self.imageData!)
            return image ?? UIImage()
        }
        
        return UIImage(named: "default_contact_image") ?? UIImage()
    }
    
    func fullName() -> String {
        return "\(self.givenName) \(self.middleName) \(self.familyName)"
    }
    
    func birthday() -> String {
        
        if let birthday = self.birthday {
            return Calendar.current.date(from: birthday)!.formatted(date: .long, time: .omitted) as String
        }
        
        return "No birthday available"
    }
    
    func isBirthdayAvailable() -> Bool {
        
        if self.birthday != nil {
            return true
        }
        
        return false
    }
    
    func getNextBirthdayDate() -> Date {
        
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var year = currentDate.year!
        
        if self.isBirthdayAvailable() {
            if currentDate.day! > self.birthday!.day! || currentDate.month! > self.birthday!.month! {
                year = year + 1
            }
        }
        
        let date = Calendar.current.date(from: DateComponents(year: year, month: self.birthday!.month!, day: self.birthday!.day!))
        
        return date!
    }
    
    func getNextBirthdayString() -> String {
        
        let currentDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var year = currentDate.year!
        
        if self.isBirthdayAvailable() {
            if currentDate.day! > self.birthday!.day! || currentDate.month! > self.birthday!.month! {
                year = year + 1
            }
            
            let date = Calendar.current.date(from: DateComponents(year: year, month: self.birthday!.month!, day: self.birthday!.day!))
            
            return date!.formatted(date: .long, time: .omitted)
        }
        
        return "No birthday available"
        
    }
    
    func phoneNumber() -> String {
        
        if let phoneNumber = self.phoneNumbers.first, !phoneNumber.value.stringValue.isEmpty {
            return phoneNumber.value.stringValue
        }
        
        return "No phone number available"
    }
    
}

extension String {
    
    var formatDate: Date {
        let isoDate = self

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = UIDevice.isIPad ? "d MMM yyyy" : "MMM d, yyyy"
        let date = dateFormatter.date(from:isoDate)!
        
        return date
    }
    
    func loadImage() -> UIImage {
        
        do {
            guard let url = URL(string: self) else { return UIImage() }
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        } catch {
            print("Error loading the image \(error)")
        }
        
        return UIImage()
    }

}

extension UIDevice {
    static var isIPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    static var isIPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }
}

