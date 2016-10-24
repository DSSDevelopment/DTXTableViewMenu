//
//  SimpleCustomForm.swift
//  DTXTableViewMenu
//
//  Created by Derek Sanchez on 10/21/16.
//  Copyright © 2016 Dramatech. All rights reserved.
//

import Foundation
import Eureka

enum RowControlType {
    case textField
    case segmentedControl
    case slider
    case binarySwitch
    case stepper
    case datePicker
    case singleSelection
    case multiSelection
    case signatureField
    case pickerView
}

struct FormRow {
    var section: Int
    var label: String
    var type: RowControlType
    var required: Bool
    var placeholder: String?
    var options: [String]?
    var minValue: Float?
    var maxValue: Float?
    
    init(section : Int, label: String, type: RowControlType, required: Bool) {
        self.section = section
        self.label = label
        self.type = type
        self.required = required
        self.placeholder = nil
        self.options = nil
        self.minValue = nil
        self.maxValue = nil
    }
    
    init(section : Int, label: String, type: RowControlType, required: Bool, placeholder: String) {
        self.section = section
        self.label = label
        self.type = type
        self.required = required
        self.placeholder = placeholder
        self.options = nil
        self.minValue = nil
        self.maxValue = nil
    }
    
    init(section : Int, label: String, type: RowControlType, required: Bool, options: [String]) {
        self.section = section
        self.label = label
        self.type = type
        self.required = required
        self.placeholder = nil
        self.options = options
        self.minValue = nil
        self.maxValue = nil
    }
    
    init(section : Int, label: String, type: RowControlType, required: Bool, minValue: Float, maxValue: Float) {
        self.section = section
        self.label = label
        self.type = type
        self.required = required
        self.placeholder = nil
        self.options = nil
        self.minValue = minValue
        self.maxValue = maxValue
    }
}

class SimpleCustomForm {
    private var sections: [String]
    private var rows: [FormRow]
    var FormVC: FormViewController?
    var completion: ((_ success:Bool, _ values:[String : Any])->Void)?
    
    init(withSectionTitles sections:[String], rows:[FormRow], completion: ((_ success:Bool, _ values:[String : Any])->Void)?) {
        self.sections = sections
        self.rows = rows
        if completion != nil {
            self.completion = completion!
        } else {
            self.completion = nil
        }
        buildEurekaForm(sections, rows: rows)
    }
    
    private func rowForLabel(_ label:String) -> FormRow? {
        for row in rows {
            if row.label == label {
                return row
            }
        }
        return nil
    }
    
    private func buildEurekaForm(_ sections:[String], rows:[FormRow]) {
        let newForm = FormViewController()
        for (idx, section) in sections.enumerated() {
            newForm.form +++ Section(section)
            if let formRows = getRows(from: idx)
            {
                for row in formRows {
                    switch row.type {
                    case .textField:
                        newForm.form.allSections[idx] <<< TextRow(row.label) {
                            $0.title = row.label
                            if row.placeholder != nil {
                                $0.placeholder = row.placeholder!
                            }
                        }
                    case .segmentedControl:
                        newForm.form.allSections[idx] <<< SegmentedRow<String>(row.label) {
                            $0.title = row.label
                            if row.options != nil {
                                $0.options = row.options!
                            }
                        }
                    case .slider:
                        newForm.form.allSections[idx] <<< SliderRow(row.label) {
                            $0.title = row.label
                            $0.minimumValue = row.minValue != nil ? row.minValue! : 0
                            $0.maximumValue = row.maxValue != nil ? row.maxValue! : 100
                        }
                    case .binarySwitch:
                        newForm.form.allSections[idx] <<< SwitchRow(row.label) {
                            $0.title = row.label
                        }
                    case .stepper:
                        newForm.form.allSections[idx] <<< StepperRow(row.label) {
                            $0.title = row.label
                            $0.value = 1.0
                        }
                    case .datePicker:
                        newForm.form.allSections[idx] <<< DateRow(row.label) {
                            $0.title = row.label
                            $0.value = Date()
                            let formatter = DateFormatter()
                            formatter.locale = .current
                            formatter.dateStyle = .short
                            $0.dateFormatter = formatter
                        }
                    case .singleSelection:
                        newForm.form.allSections[idx] <<< PushRow<String>(row.label) {
                            $0.title = row.label
                            $0.selectorTitle = row.label
                            $0.options = row.options != nil ? row.options! : ["ERROR: Please pass an array of strings in options."]
                        }
                    case .multiSelection:
                        newForm.form.allSections[idx] <<< MultipleSelectorRow<String>(row.label) {
                            $0.title = row.label
                            $0.selectorTitle = row.label
                            $0.options = row.options != nil ? row.options! : ["ERROR: Please pass an array of strings in options."]
                        }
                    case .signatureField:
                        newForm.form.allSections[idx] <<< SignatureRow(row.label) {
                            $0.title = row.label
                        }
                        break
                    case .pickerView:
                        newForm.form.allSections[idx] <<< PickerRow<String>(row.label) {
                            $0.title = row.label
                            $0.options = row.options != nil ? row.options! : ["ERROR: Please pass an array of strings in options."]
                        }
                    }
                }
            }
        }
        FormVC = newForm
        FormVC?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(save))
    }
    
    private func getRows(from section:Int) ->[FormRow]? {
        return rows.filter({ $0.section == section })
    }
    
    private func getResult() -> (Bool, [String : Any]) {
        var success = true
        var retval = [String : Any]()
        var failureCases = [String: Any]()
        for val in FormVC!.form.values() {
            if val.value == nil {
                if let formrow = rowForLabel(val.key) {
                    success = !(formrow.required)
                    if success == false {
                        failureCases[val.key] = "NIL"
                    }
                }
            } else {
                retval[val.key] = val.value!
            }
        }
        
        /*= FormVC!.form.rows.reduce([String : Any]()) { res, row  in
            if row.baseValue != nil {
                return [row.title!: row.baseValue!]
            } else if let formrow = rowForLabel(row.title!) {
                success = !(formrow.required)
                return [row.title!: "REQUIRED"]
            }
            return [row.title! : "NIL"]
        }*/
        if success == false {
            return(success, failureCases)
        }
        return (success, retval)
    }
    
    @objc func save() {
        let results = getResult()
        print(results.1)
        if results.0 == true {
            completion?(true, results.1)
        } else {
            //failed to save
            completion?(false, results.1)
        }
    }

}
