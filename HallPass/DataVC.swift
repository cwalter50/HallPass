//
//  DataVC.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import UIKit

class DataVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var events = [String]()

    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
