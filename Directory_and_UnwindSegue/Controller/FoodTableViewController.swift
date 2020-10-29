//
//  FoodTableViewController.swift
//  Directory_and_UnwindSegue
//
//  Created by Cooper on 2020/10/28.
//

import UIKit

class FoodTableViewController: UITableViewController {
    
    var foods = [FoodDaiary]()

    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return foods.count
    }

    //呈現表格
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(FoodTableViewCell.self)", for: indexPath) as! FoodTableViewCell

        let food = foods[indexPath.row]
        
        cell.DateLabel.text = food.date
        cell.nameLabel.text = food.name
        cell.symbolLabel.text = food.symbol
        
        //show grey horizontal edit button
        cell.showsReorderControl = true

        return cell
    }
    
    //讓編輯按鈕點擊進行動作
    @IBAction func editButton(_ sender: Any) {
        let tableViewEditingMode = tableView.isEditing
        tableView.setEditing(!tableViewEditingMode, animated: true)
    }
    
    //「editingStyleForRowAt」用於 delegate 會找到 cell 在編輯中所對應的 row
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // 「commit editingStyle」讓 dataSource 確認是要讓 被點擊的那個 cell 要被編輯還是被移除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
            foods.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            FoodDaiary.saveToFile(foods: foods)
        
            
    }
    
    
    // 「moveRowAt」：告知 dataSource 要將表格內的哪一行進行移動。
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedFood = foods.remove(at: fromIndexPath.row)
        foods.insert(movedFood, at: to.row)
        tableView.reloadData()
        FoodDaiary.saveToFile(foods: foods)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = docDir.appendingPathComponent("foods").appendingPathExtension("plist")
        //可印出來模擬器儲存的路徑
        print(url)
        
        //在 viewDidLoad 載入資料。
        if let savedFoods = FoodDaiary.loadFromFile() {
            foods = savedFoods
        } 
    }


    @IBAction func unwindToFoodTableViewController(segue: UIStoryboardSegue) {
       //設置剛才的saveUnwind ID
        guard segue.identifier == "saveUnwind" else{return}
        
        if let sourceViewController = segue.source as? AddEditFoodTableViewController,
           let food = sourceViewController.foods {
            
            //這邊是 第二頁 cancel 按鈕回來後 會刷新一次table
            if let indexPath = tableView.indexPathForSelectedRow {
               
                foods[indexPath.row] = food
                tableView.reloadRows(at: [indexPath], with: .automatic)
               
            //這邊是 第二頁的 save 按鈕回來會新增一筆資料
            } else {
                foods.insert(food, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        FoodDaiary.saveToFile(foods: foods)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditFood" {
            
            let indexPath = tableView.indexPathForSelectedRow!
            let food = foods[indexPath.row]
            let controller = segue.destination as! UINavigationController
            let addEditFoodTableViewController = controller.topViewController as!
                AddEditFoodTableViewController
            
                addEditFoodTableViewController.foods = food
            
        }
    }

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
