//
//  ViewController.swift
//  DTXTableViewMenu
//
//  Created by Derek Sanchez on 10/21/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var form: SimpleCustomForm?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let pickerOptions = ["Page 1","Page 2","Page 3","Page 4","Page 5","Page 6","Page 7","Page 8","Page 9","Page 10","Page 11","Page 12","Page 13","Page 14","Page 15","Page 16","Page 17","Page 18"]
        
        let rows = [
            FormRow(section: 0, label: "type here:", type: .textField, required: true, placeholder:"enter something!"),
            FormRow(section: 0, label: "sign here:", type: .signatureField, required: true),
            FormRow(section: 0, label: "Gender", type: .segmentedControl, required: true, options:["Male", "Female"]),
            FormRow(section: 0, label: "Percent", type: .slider, required: true),
            FormRow(section: 0, label: "Send me notices by email", type: .binarySwitch, required: true),
            FormRow(section: 0, label: "Count", type: .stepper, required: true),
            FormRow(section: 1, label: "Birthday", type: .datePicker, required: true),
            FormRow(section: 1, label: "Choose One:", type: .singleSelection, required: true, options: ["Monday","Tuesday","Wednesday","Thursday","Friday"]),
            FormRow(section: 1, label: "Choose All That Apply:", type: .multiSelection, required: true, options: ["Chess","Kayaking","Fishing","Video Games","Basketball"]),
            FormRow(section: 1, label: "Which Page?", type: .pickerView, required: true, options: pickerOptions)
        ]
        
        //form = SimpleCustomForm(withSectionTitles: ["Section 1", "Section 2"], rows: rows, completion)
        form = SimpleCustomForm(withSectionTitles: ["Section 1", "Section 2"], rows: rows, completion: { (success, results) in
            if success {
                print("RESULTS: \(results)")
                let successAlert = UIAlertController(title: "Save succcessful!", message: nil, preferredStyle: .alert)
                successAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController!.topViewController!.present(successAlert, animated: true, completion: nil)
            } else {
                let failures = results.keys.joined(separator: ", ")
                let failure = UIAlertController(title: "Please fill in all required fields.", message: failures, preferredStyle: .alert)
                failure.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.navigationController!.topViewController!.present(failure, animated: true, completion: nil)
            }
        })
        self.navigationController!.pushViewController(form!.FormVC!, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

