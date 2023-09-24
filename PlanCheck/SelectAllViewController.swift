//
//  SelectAllViewController.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/21.
//

import UIKit
import RealmSwift

class SelectAllViewController: UIViewController {
    
    let realm = try! Realm()
    
    var successAll: Results<Plan>!
    var failureAll: Results<Plan>!
    
    @IBOutlet weak var successLable: UILabel!
    
    @IBOutlet weak var failureLabel: UILabel!
    
    
    @IBAction func selectBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let successAllCount : Int = successAll.count
        var successNumber = successAllCount - 1
        var successText = ""
        
        for i in 0...successNumber {

            //日付の変換
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let successDateString:String = formatter.string(from:successAll[i].date)

            //print(successDateString + "\n" + successAll[i].title)

            var successList = successDateString + "\n" + successAll[i].title + "\n"

            successText.append(successList)

            //Uilabeに表示する
            successLable.text = successText

        }
        
        //maPメソッドで実行した場合
        successLable.text  = successAll.map {"\($0["date"]!)\n\($0["title"]!)"}.joined(separator: "\n")
        
        let failureAllCount : Int = failureAll.count
        var failureNumber = failureAllCount - 1
        var failureText = ""
        

        for i in 0...failureNumber {
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            let failureDateString:String = formatter.string(from:failureAll[i].date)
            
            
            //print(failureDateString + "\n" + failureAll[i].title)
            
            var failureList = failureDateString + "\n" + failureAll[i].title + "\n"
            
            failureText.append(failureList)
            
            failureLabel.text = failureText
            
        }
    }
}


