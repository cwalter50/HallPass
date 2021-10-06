//
//  ViewController.swift
//  HallPass
//
//  Created by Christopher Walter on 10/6/21.
//

import UIKit

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
        if myButton.tag == 3
        {
            myButton.tag = 4
            myButton.setTitle("I'm Back", for: .normal)
            myLabel.text = "\(name) left at \(displayDate)"
        }
        else
        {
            myButton.tag = 3
            myButton.setTitle("I'm Leaving", for: .normal)
            myLabel.text! += "\n\n\(name) returned at \(displayDate)"
            nameTF.text = ""
        }
        
        
        // save data to firebase
        
        
    }
    
    func saveToFirebase()
    {
        
    }
    
    func setupUI()
    {
        myButton.backgroundColor = UIColor.white
        myButton.layer.cornerRadius = 10
    }
    

}

