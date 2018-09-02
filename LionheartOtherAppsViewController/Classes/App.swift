//
//  App.swift
//  LionheartOtherAppsViewController
//
//  Created by Dan Loewenherz on 3/1/18.
//

import Foundation

struct App {
    var affiliateCode: String?
    var name: String
    var rating: Decimal?
    var numberOfRatings: Int?
    var imageURLString: String?
    var imageURL: URL? {
        guard let urlString = imageURLString else {
            return nil
        }
        
        return URL(string: urlString)
    }
    
    var urlString: String?
    var url: URL? {
        guard var urlString = urlString else {
            return nil
        }
        
        if let affiliateCode = affiliateCode {
            urlString += "&at=\(affiliateCode)"
        }
        
        return URL(string: urlString)
    }
    
    var starString: String? {
        guard let rating = rating else {
            return nil
        }
        
        var value = ""
        let starRating = NSDecimalNumber(decimal: rating)
        
        for i in 0..<5 {
            if starRating.floatValue - Float(i) > -0.5 {
                value += "★"
            } else {
                value += ""
            }
        }
        
        return value
    }
    
    var detailText: String {
        guard let numberOfRatings = numberOfRatings,
            let starString = starString else {
                return "No reviews"
        }
        
        let plural: String
        if numberOfRatings == 1 {
            plural = ""
        } else {
            plural = "s"
        }
        
        return "\(starString) \(numberOfRatings) review\(plural)"
    }
    
    init?(payload: [String: Any], affiliateCode: String?) {
        guard let appNameString = payload["trackName"] as? String,
            let appName = appNameString.components(separatedBy: "-").first else {
                return nil
        }
        
        self.affiliateCode = affiliateCode
        name = appName
        rating = (payload["averageUserRating"] as? NSNumber)?.decimalValue
        numberOfRatings = payload["userRatingCount"] as? Int
        imageURLString = payload["artworkUrl100"] as? String
        urlString = payload["trackViewUrl"] as? String
    }
}
