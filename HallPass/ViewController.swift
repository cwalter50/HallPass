//
//  ViewController.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import UIKit
import Firebase
import simd

class ViewController: UIViewController
{

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var myLabel: UILabel!
    
    var timer: Timer = Timer()
    var timerCount = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupUI()
        myButton.tag = 3
    }
    
    var event: Event = Event()
    
    // button is going to alternate between having a tag 3 and 4 to change states.
    // tag = 3 -> person hasnt left
    // tag = 4 -> person hasnt returned
    @IBAction func buttonTapped(_ sender: UIButton)
    {
        if nameTF.text!.isEmpty
        {
            myLabel.text = "You must enter your name!"
        }
        else
        {
            // get the name from the TF
            let name = nameTF.text!
            // Get the timestamp of when button was tapped
            let timestamp = Date()

            // if button is selected, create a new event
            if myButton.tag == 3
            {
                myButton.tag = 4
                nameTF.isHidden = true
                myButton.setTitle("I'm Back", for: .normal)
                myButton.backgroundColor = UIColor.systemRed

                // make a new Event and save it to global variable event
                event = Event(name: name, timeLeft: Double(timestamp.timeIntervalSince1970))
                
                myLabel.text = event.description
                
                // create a timer to display timeout.
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startTimer), userInfo: nil, repeats: true)
            }
            else
            {
                myButton.tag = 3
                myButton.setTitle("I'm Leaving", for: .normal)
                myButton.backgroundColor = UIColor.systemGreen
                nameTF.text = ""
                nameTF.isHidden = false
                
                // update Event
                event.timeReturned = Double(timestamp.timeIntervalSince1970)
                event.totalTimeOut = event.timeReturned - event.timeLeft
                
                myLabel.text = event.description
                
                // stop timer
                timer.invalidate()
                timerCount = 0
            }
            // save data to firebase
            saveToFirebase()
        }
        
    }
    func saveToFirebase()
    {
        let db = Firestore.firestore()
        let data = ["name": event.name, "timeLeft": event.timeLeft, "timeReturned": event.timeReturned, "totalTimeOut": event.totalTimeOut] as [String : Any]
//        let data = event.toValues()
        
        db.collection("Events").document(event.id).setData(data) {
            err in
            if let error = err {
                print("Error adding document: \(error)")
            }
        }
    }
    
    
    @objc func startTimer()
    {
        timerCount += 1
        
        let timeFormatter = DateComponentsFormatter()
        timeFormatter.allowedUnits = [.hour, .minute, .second]
        timeFormatter.unitsStyle = .full

        let totalTimeOutFormatted = timeFormatter.string(from: TimeInterval(timerCount)) ?? "0"
        
        UIView.performWithoutAnimation {
            self.myButton.setTitle("I'm Back\n\(totalTimeOutFormatted)", for: .normal)
            self.myButton.layoutIfNeeded()
        }

    }
    
    func setupUI()
    {
        // button should be circle
        myButton.backgroundColor = UIColor.systemGreen
        myButton.setTitleColor(UIColor.darkGray, for: .normal)
        let width = UIScreen.main.bounds.width - 100
        myButton.layer.cornerRadius = width / 2
        myButton.layer.borderColor = UIColor.darkGray.cgColor
        myButton.layer.borderWidth = 3
        // allow us to have multiple lines on button title. It is need to show time person is out
        myButton.titleLabel?.lineBreakMode = .byWordWrapping
        myButton.titleLabel?.textAlignment = .center
        
        myLabel.text = ""
    }
    

}

