//
//  TableViewController.swift
//  Task_tracker
//
//  Created by Иван Базаров on 23.07.2018.
//  Copyright © 2018 Иван Базаров. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    @IBAction func touchUpInside(_ sender: Any) {
        
        self.Vars.editing_started = false
    }
    @IBOutlet weak var FilterButton: UIBarButtonItem!
    @IBOutlet weak var ExtensionButton: UIBarButtonItem!
    @IBOutlet weak var AddButton: UIBarButtonItem!
    
    let Arrays = StructOperation.globalArrays.self
    let Vars = StructOperation.globalVars.self
    var index_numb = 0
    var temp_namesArr = [String]()
    var temp_statusesArr = [String]()
    var temp_datesArr = [Date]()
    var temp_commsArr = [String]()
    var filter_status = 0
    var sectionTitle = ["Фильтр по статусу задач", "Отмена"]
    var no_tasks_found = ["Не найдено ни одной задачи"]
    var sectionTitle2 = ["Отфильтрованные задачи","Возврат к списку задач"]
    var sectionContent = [["Новая","В процессе","Выполнена"],["Вернуться к списку задач"]]
    var selectedFilter = [false,false]
    
    
    
    @IBAction func Todays_Extension(_ sender: Any) {
        
        let count = self.Arrays.statusesIntArr.count
        var unsolved_dates_arr = [Date]()
        var unsolved_tasks_ind = [Int]()
        for i in 1...self.Arrays.statusesArr.count {
            
            if self.Arrays.statusesArr[i-1] == "Новая" || self.Arrays.statusesArr[i-1] == "В процессе"{
                unsolved_tasks_ind.append(i-1)
            }
        }
        
        for i in 1...count {
            if self.Arrays.statusesArr[i-1] == "Новая" || self.Arrays.statusesArr[i-1] == "В процессе" {
                unsolved_dates_arr.append(self.Arrays.datesArr[i-1])
            }
        }

        if unsolved_tasks_ind.count == 0 {
            alert_Controller(a_title: "Оповещение", a_message: "Все задачи выполнены).")
            return
        }
        let current_date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        let calendar = NSCalendar.current
        var maxed_day = 1000000
        let date1 = calendar.startOfDay(for: current_date)
        for i in 1...unsolved_tasks_ind.count {
      
            let date2 = calendar.startOfDay(for: unsolved_dates_arr[i-1])
            let components = calendar.dateComponents([.day], from: date1, to: date2)
            if components.day! < maxed_day && components.day! > -1{
                maxed_day = components.day!
                self.index_numb = i - 1
            }
        }

        let final_index = unsolved_tasks_ind[self.index_numb]
        let result_date = formatter.string(from: self.Arrays.datesArr[final_index])
        alert_Controller(a_title: "Оповещение", a_message: "Ближайшая невыполненная задача: \(self.Arrays.namesArr[final_index]), Дата:\(result_date). ")
        
    }
    

    @IBAction func FilterTasks(_ sender: Any) {
        if self.Arrays.namesArr.count != 0 {
            self.filter_status = 1
            buttons_setup(status: false)
            tableView.reloadData()
        }else {
            alert_Controller(a_title: "В списке нет ни одной задачи", a_message: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let defaults = UserDefaults.standard
        
        if let names_Arr = defaults.stringArray(forKey: "Names") {
            self.Arrays.namesArr = names_Arr
        }
        if let dates_Arr = defaults.array(forKey: "Dates") as? [Date] {
            self.Arrays.datesArr = dates_Arr
        }
        if let statuses_Arr = defaults.stringArray(forKey: "Statuses") {
            self.Arrays.statusesArr = statuses_Arr
        }
        if let statusesInt_Arr = defaults.stringArray(forKey: "StatusesInt") {
            self.Arrays.statusesIntArr = statusesInt_Arr
        }
        if let comms_Arr = defaults.stringArray(forKey: "Comms") {
            self.Arrays.commentariesArr = comms_Arr
        }
        tableView.estimatedRowHeight = 80.0
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        switch self.filter_status {
        case 1: return sectionTitle.count
        case 2: return 2
        case 0: return 1
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch self.filter_status {
        case 1: return sectionTitle[section]
        case 2: return sectionTitle2[section]
        case 0: return ""
        default: return ""
        }
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.filter_status {
        case 1:
            switch  section {
            case 0:
                return 3
            case 1:
                return 1
            default:
                return 1
            }
        case 2:
            switch section {
            case 0: return self.temp_namesArr.count
            case 1: return 1
            default: return 1
            }
        case 0: return self.Arrays.namesArr.count
        default: return self.Arrays.namesArr.count
        
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        
        switch self.filter_status {
        case 1:
            cell.NameLabel.text = sectionContent[indexPath.section][indexPath.row]
            cell.StatusLabel.text = ""
            cell.DateLabel.text = ""
            cell.CommentaryLabel.text = ""
        case 2:
            if indexPath.section == 0 {
                    cell.NameLabel.text = self.temp_namesArr[indexPath.row]
                    cell.StatusLabel.text = self.temp_statusesArr[indexPath.row]
                    cell.DateLabel.text = formatter.string(from: self.temp_datesArr[indexPath.row])
                    cell.CommentaryLabel.text = self.temp_commsArr[indexPath.row]

            }else {
                cell.NameLabel.text = "Вернуться к списку"
                cell.StatusLabel.text = ""
                cell.DateLabel.text = ""
                cell.CommentaryLabel.text = ""
            }
            
            
        case 0:
            cell.NameLabel.text = self.Arrays.namesArr[indexPath.row]
            cell.StatusLabel.text = self.Arrays.statusesArr[indexPath.row]
            cell.DateLabel.text = formatter.string(from: self.Arrays.datesArr[indexPath.row])
            cell.CommentaryLabel.text = self.Arrays.commentariesArr[indexPath.row]
        default:
            cell.NameLabel.text = self.Arrays.namesArr[indexPath.row]
            cell.StatusLabel.text = self.Arrays.statusesArr[indexPath.row]
            cell.DateLabel.text = formatter.string(from: self.Arrays.datesArr[indexPath.row])
            cell.CommentaryLabel.text = self.Arrays.commentariesArr[indexPath.row]
        
        }
        
       return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if self.filter_status == 0 {
        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить", handler: {(actin, indexPath) -> Void in
            
            self.Arrays.namesArr.remove(at: indexPath.row)
            self.Arrays.datesArr.remove(at: indexPath.row)
            self.Arrays.statusesArr.remove(at: indexPath.row)
            self.Arrays.commentariesArr.remove(at: indexPath.row)
            self.Arrays.statusesIntArr.remove(at: indexPath.row)
            
            let defaults = UserDefaults.standard
            defaults.set(self.Arrays.namesArr, forKey: "Names")
            defaults.set(self.Arrays.datesArr, forKey: "Dates")
            defaults.set(self.Arrays.statusesArr, forKey: "Statuses")
            defaults.set(self.Arrays.statusesIntArr, forKey: "StatusesInt")
            defaults.set(self.Arrays.commentariesArr, forKey: "Comms")
            
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        })
        
        let editAction = UITableViewRowAction(style: .default, title: "Изменить", handler: { (actin, indexPath) -> Void in
            self.Vars.name = self.Arrays.namesArr[indexPath.row]
            self.Vars.date = self.Arrays.datesArr[indexPath.row]
            self.Vars.status = self.Arrays.statusesArr[indexPath.row]
            self.Vars.commentary = self.Arrays.commentariesArr[indexPath.row]
            self.Vars.editing_started = true
            self.Vars.index = indexPath.row
            
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EditingVC") as? EditingViewController
        
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
        })

        deleteAction.backgroundColor = UIColor(red: 202.0/255.0, green: 202.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        
        return [deleteAction,editAction]
        }else {
            return []
        }
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.filter_status == 1 {
            
            switch indexPath.section {
            case 0:
                if indexPath.row == 0 {
                    temp_Arrays_app(status: "Новая")
                }
                if indexPath.row == 1 {
                    temp_Arrays_app(status: "В процессе")
                }
                if indexPath.row == 2 {
                    temp_Arrays_app(status: "Выполнена")
                }
                if self.temp_namesArr.count == 0 {
                    
                    self.filter_status = 0
                    delete_temp_Arr()
                    tableView.reloadData()
                    buttons_setup(status: true)
                    
                    alert_Controller(a_title: "Не найдено ни одной задачи с данным статусом", a_message: "")
                }else {
                    self.filter_status = 2
                    tableView.reloadData()
                }
                
            case 1:
                if indexPath.row == 0 {
                    self.filter_status = 0
                    delete_temp_Arr()
                    tableView.reloadData()
                    buttons_setup(status: true)
                }
                
                
            default:
                self.filter_status = 0
                delete_temp_Arr()
                tableView.reloadData()
                buttons_setup(status: true)
            }
        }
        if filter_status == 2 {
            if indexPath.section == 1 && indexPath.row == 0 {
                self.filter_status = 0
                delete_temp_Arr()
                tableView.reloadData()
                buttons_setup(status: true)
            }
        }
    }
    
    func alert_Controller(a_title: String, a_message: String) {
        
        let alert = UIAlertController(title: a_title, message: a_message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
        
        }
    }
    
    func temp_Arrays_app (status: String){
        if self.Arrays.statusesArr.count != 0 {
            for i in 1...self.Arrays.statusesArr.count {
                if self.Arrays.statusesArr[i-1] == status {
                    self.temp_namesArr.append(self.Arrays.namesArr[i-1])
                    self.temp_statusesArr.append(self.Arrays.statusesArr[i-1])
                    self.temp_datesArr.append(self.Arrays.datesArr[i-1])
                    self.temp_commsArr.append(self.Arrays.commentariesArr[i-1])
                    
                }
            }
        }
    }
    func delete_temp_Arr(){
        self.temp_namesArr.removeAll()
        self.temp_statusesArr.removeAll()
        self.temp_datesArr.removeAll()
        self.temp_commsArr.removeAll()
    }
    func buttons_setup(status: Bool) {
        self.AddButton.isEnabled = status
        self.ExtensionButton.isEnabled = status
        self.FilterButton.isEnabled = status
    }

}
