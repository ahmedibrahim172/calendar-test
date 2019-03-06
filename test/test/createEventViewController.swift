//
//  createEventViewController.swift
//  test
//
//  Created by bata on 3/5/19.
//  Copyright © 2019 bata. All rights reserved.
//

import UIKit


class createEventViewController: UIViewController {
    
    @IBOutlet weak var datelbl: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var detailsField: UITextView!
    @IBOutlet weak var titleField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     datePicker?.datePickerMode = .dateAndTime
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func valueChanged(_ sender: UIDatePicker, forEvent event: UIEvent) {
        datelbl.text = "\(sender.date)"
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        let newNote = MyNotes(context: context)
        newNote.title=titleField.text
        newNote.details=detailsField.text
    
         newNote.date_save=NSDate() as Date
        
        
        do{
            ad.saveContext()
            print("saved")
            print(titleField.text!)
            print(detailsField.text!)
            titleField.text=""
            detailsField.text=""
        }
        catch{
            print("error")
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
