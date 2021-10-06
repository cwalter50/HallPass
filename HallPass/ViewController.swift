//
//  ViewController.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import UIKit
import Firebase

class ViewController: UIViewController
{

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        myButton.tag = 3
    }
    
    
    @IBAction func buttonTapped(_ sender: UIButton)
    {
        // get the name from the TF
        let name = nameTF.text!
        // Get the timestamp of when button was tapped
        let timestamp = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        let displayDate = formatter.string(from: timestamp)
        
        // change the buttons text to I'm Back or I'm Leaving
        var isBack = false
        if myButton.tag == 3
        {
            myButton.tag = 4
            myButton.setTitle("I'm Back", for: .normal)
            myLabel.text = "\(name) left at \(displayDate)"
            isBack = false
        }
        else
        {
            myButton.tag = 3
            myButton.setTitle("I'm Leaving", for: .normal)
            myLabel.text! += "\n\n\(name) returned at \(displayDate)"
            nameTF.text = ""
            isBack = true
        }
        
        
        // save data to firebase
        saveToFirebase(name: name, date: timestamp, isBack: isBack)
        
        
    }
    
    func saveToFirebase(name: String, date: Date, isBack: Bool)
    {
        let db = Firestore.firestore()
        let date = Double(date.timeIntervalSince1970)
        let data = ["name": name, "created": date, "isBack": isBack] as [String : Any]
        db.collection("Events").addDocument(data: data) {
            err in
            if let error = err {
                print("Error adding document: \(error)")
            }
        }
    }
    
    func setupUI()
    {
        myButton.backgroundColor = UIColor.white
        myButton.layer.cornerRadius = 10
    }
    

}

