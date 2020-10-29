//
//  FoodDiary.swift
//  Directory_and_UnwindSegue
//
//  Created by Cooper on 2020/10/28.
//

import Foundation

struct FoodDaiary: Codable {
    var date: String
    var symbol: String
    var name: String
    var description: String
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("food").appendingPathExtension("plist")
    
    static func loadFromFile () -> [FoodDaiary]? {
        guard let data = try? Data(contentsOf: archiveURL) else { return nil }
        let decoder = PropertyListDecoder()
        return try? decoder.decode(Array<FoodDaiary>.self, from: data)
        
    }
    
    
    //這個 load 不到資料
//    static func loadFromFile () -> [Self]? {
//            let propertyDecoder = PropertyListDecoder()
//            let url = FoodDaiary.documentsDirectory.appendingPathExtension("foods")
//            if let data = try? Data(contentsOf: url), let foods = try? propertyDecoder.decode([Self].self, from: data){
//                return foods
//            } else{
//                return nil
//            }
//
//        }
    
    
    //can use Self = FoodDiary
    static func saveToFile(foods: [FoodDaiary]){
        let propertyEncoder = PropertyListEncoder()
        let data = try? propertyEncoder.encode(foods)
        try? data?.write(to: archiveURL, options: .noFileProtection)
           
    }
    
    
    //假資料用
    static func loadFoodDiary () -> [FoodDaiary] {
        return [FoodDaiary(date: "2020-10-30" , symbol: "🍇", name: "Grape", description: "Good Food to eat"),
                FoodDaiary(date: "2020-10-31", symbol: "🌽", name: "Corn", description: "Yumm"),
                FoodDaiary(date: "2020-11-01", symbol: "🥑", name: "Avocado", description: "I don't like")
        ]
    }
    
    
    
    
    
}


