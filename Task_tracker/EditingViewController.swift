//
//  EditingViewController.swift
//  Task_tracker
//
//  Created by Иван Базаров on 25.07.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class EditingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let Arrays = StructOperation.globalArrays.self
    let Vars = StructOperation.globalVars.self
    static let instance = EditingViewController()
    @IBOutlet weak var NameText: UITextField!
    @IBOutlet weak var CommentaryText: UITextField!
    @IBOutlet weak var AddButton: UIButton!
    let tasks_statuses = ["Новая", "В процессе","Выполнена"]
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var statusesPicker: UIPickerView!
    
    @IBAction func addTaskFuncton(_ sender: Any) {
        
        
        if (NameText.text == "" ) {
            
            alert_Controller(a_title: "Упс", a_message: "Похоже вы не заполнили одно из полей, пожалуйста заполните все необходимые поля.")
            return
            
        }
       
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let curr_status = String(self.tasks_statuses[statusesPicker.selectedRow(inComponent: 0)])
        
        if self.Vars.editing_started {
            self.Arrays.namesArr[self.Vars.index] = NameText.text!
            self.Arrays.datesArr[self.Vars.index] = datePicker.date
            self.Arrays.statusesArr[self.Vars.index] = curr_status
            switch curr_status {
            case "Выполнена": self.Arrays.statusesIntArr[self.Vars.index] = "3"
            case "В процессе": self.Arrays.statusesIntArr[self.Vars.index] = "2"
            case "Новая": self.Arrays.statusesIntArr[self.Vars.index] = "1"
            default: self.Arrays.statusesIntArr[self.Vars.index] = "0"
            }
            self.Arrays.commentariesArr[self.Vars.index] = CommentaryText.text!
            
        }else {
            
        self.Arrays.namesArr.append(NameText.text!)
        self.Arrays.datesArr.append(datePicker.date)
        self.Arrays.statusesArr.append(curr_status)
            switch curr_status {
            case "Выполнена": self.Arrays.statusesIntArr.append("3")
            case "В процессе": self.Arrays.statusesIntArr.append("2")
            case "Новая": self.Arrays.statusesIntArr.append("1")
            default: self.Arrays.statusesIntArr.append("0")
            }
        self.Arrays.commentariesArr.append(CommentaryText.text!)
       }
  
        
        let defaults = UserDefaults.standard
        defaults.set(self.Arrays.namesArr, forKey: "Names")
        defaults.set(self.Arrays.datesArr, forKey: "Dates")
        defaults.set(self.Arrays.statusesArr, forKey: "Statuses")
        defaults.set(self.Arrays.statusesIntArr, forKey: "StatusesInt")
        defaults.set(self.Arrays.commentariesArr, forKey: "Comms")
        
    
        
        let alert = UIAlertController(title: "", message: self.Vars.editing_started ? "Задача отредактирована" : "Задача добавлена", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)

        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        }
        self.Vars.editing_started = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print ("edit_var", self.Vars.editing_started)
        if self.Vars.editing_started {
            NameText.text = self.Vars.name
            CommentaryText.text = self.Vars.commentary
            datePicker.date = self.Vars.date
            print("cur_st_row", Int(self.Arrays.statusesIntArr[self.Vars.index])! - 1)
            statusesPicker.selectRow(Int(self.Arrays.statusesIntArr[self.Vars.index])! - 1, inComponent: 0, animated: true)
            AddButton.setTitle("Изменить", for: .normal)
            
        }else {
            NameText.text = ""
            CommentaryText.text = ""
            datePicker.date = Date()
            AddButton.setTitle("Добавить", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        statusesPicker.delegate = self
        statusesPicker.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alert_Controller(a_title: String, a_message: String) {
        
        let alertController = UIAlertController(title: a_title, message: a_message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tasks_statuses.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tasks_statuses[row]
    }
    
}


