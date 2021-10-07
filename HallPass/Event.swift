//
//  Event.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import Foundation
import Firebase

struct Event: CustomStringConvertible
{
    var id: String // this will be a unique ID
    var name: String
    var timeLeft: Double // this will be a double value of time since 1970. Firebase does not store Dates
    var timeReturned: Double // this will be a double value of time since 1970
    var totalTimeOut: Double // timeReturned - timeLeft
    
    init()
    {
        id = UUID().uuidString
        name = "Doc Walter"
        timeLeft = Double(Date().timeIntervalSince1970)
        timeReturned = timeLeft
        totalTimeOut = timeReturned - timeLeft
    }
    
    init(name: String, timeLeft: Double) {
        self.id = UUID().uuidString
        self.name = name
        self.timeLeft = timeLeft
        self.timeReturned = timeLeft
        self.totalTimeOut = timeReturned - timeLeft
    }
    
    
    // Firestore database init..
    init(document: DocumentSnapshot)
    {
        let snapshotValue = document.data() ?? [String: Any]()
        timeLeft = snapshotValue["timeLeft"] as? Double ?? 0.0
        timeReturned = snapshotValue["timeReturned"] as? Double ?? 0.0
        name = snapshotValue["name"] as? String ?? "Doc"
        id = document.documentID
        totalTimeOut = snapshotValue["totalTimeOut"] as? Double ?? 0.0
    }
    
    func toValues() -> [String:Any] {
        return ["id": id,
                "name": name,
                "timeLeft": timeLeft,
                "timeReturned": timeReturned,
                "totalTimeOut": totalTimeOut
        ]
    }
    
    
    var description: String
    {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        
        let timeLeftDate = Date(timeIntervalSince1970: timeLeft)
        let timeLeftFormatted = formatter.string(from: timeLeftDate)
        
        let timeReturnedDate = Date(timeIntervalSince1970: timeReturned)
        let timeReturnedFormatted = formatter.string(from: timeReturnedDate)
        
        
        let totalTime = Int(totalTimeOut)
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.unitsStyle = .full

        let totalTimeOutFormatted = timeFormatter.string(from: TimeInterval(totalTime))!
        
        if totalTimeOut == 0
        {
            return "\(self.name)\nTime Left: \(timeLeftFormatted)\nHas NOT returned"
        }
        else
        {
            return "\(self.name): \(totalTimeOutFormatted)\nTime Left: \(timeLeftFormatted)\nTime Returned:\(timeReturnedFormatted)"
        }
        
    }
    
    
}
