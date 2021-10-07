//
//  DataVC.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import UIKit
import Firebase

class DataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var events = [Event]()

    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        myTableView.dataSource = self
        myTableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadFromFirebase()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        let event = events[indexPath.row]
        cell.textLabel?.text = event.description
        
        return cell
    }
    
    
    func loadFromFirebase()
    {
        let db = Firestore.firestore()
            db.collection("Events").addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else { print("Error fetching document: \(error!)")
                    return
                }
                self.events.removeAll()
                
                let documentData = document.documents
                
                for item in documentData
                {
//                    let event = Event(document: item)
                    // create a standard event and fill it with the values...
                    var event = Event()
                    event.id = item.documentID
                    
                    let data = item.data() // This is a [String:Any] Dictionary

                    event.timeReturned = data["timeReturned"] as? Double ?? 0.0
                    event.timeLeft = data["timeLeft"] as? Double ?? 0.0
                    event.totalTimeOut = data["totalTimeOut"] as? Double ?? 0.0
                    event.name = data["name"] as? String ?? "Doc"
                
                    self.events.append(event)
                }
                
                // sort events
                self.events = self.events.sorted(by: { $0.timeLeft > $1.timeLeft })

                self.myTableView.reloadData()
            }
    }

}
