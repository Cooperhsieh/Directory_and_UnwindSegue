//
//  AddEditFoodTableViewController.swift
//  Directory_and_UnwindSegue
//
//  Created by Cooper on 2020/10/28.
//

import UIKit

class AddEditFoodTableViewController: UITableViewController {
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var symbolTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var dateLabel: UILabel!
    
    var foods: FoodDaiary?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let food = foods {
            dateLabel.text = food.date
            symbolTextField.text = String(food.symbol)
            nameTextField.text = food.name
            descriptionTextField.text = food.description
        }
        
        updateSaveButtonState()

        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let date = dateLabel.text ?? ""
        let symbol = symbolTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        foods = FoodDaiary(date: date, symbol: symbol, name: name, description: description)
    }
    
    
    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = sender.locale
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr = dateFormatter.string(from: sender.date)
        dateLabel.text = dateStr
        
    }
    
    //讓 NavBar 的 Save 按鈕在四個欄位完成輸入後才會亮，user也才能按，否則 save 會顯示灰色不可按
    func updateSaveButtonState () {
        let symbol = symbolTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        
        saveButton.isEnabled =  !symbol.isEmpty && !name.isEmpty && !description.isEmpty
        
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    //按下鍵盤的return可收回鍵盤，詳情看右邊屬性欄的圓點 connection
    @IBAction func returnPressed(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    

    
}
