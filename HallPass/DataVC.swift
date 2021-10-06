//
//  DataVC.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import UIKit
import Firebase

class DataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var events = [String]()

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
        cell.textLabel?.text = event
        
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
                    let data = item.data()
                    let created = data["created"] as? Double ?? Double(Date().timeIntervalSince1970)
                    let name = data["name"] as? String ?? "Hello"
                    let isBack = data["isBack"] as? Bool ?? true
                    
                    let date = Date(timeIntervalSince1970: created)
                    
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .long
                    let displayDate = formatter.string(from: date)
                    
                    if isBack {
                        self.events.append("\(name): returned \(displayDate)")
                    }
                    else {
                        self.events.append("\(name): left \(displayDate)")
                    }
                }

                self.myTableView.reloadData()
            }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
