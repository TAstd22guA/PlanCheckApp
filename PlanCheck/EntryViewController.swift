//
//  EntryViewController.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/14.
//

import UIKit
import RealmSwift


class EntryViewController: UIViewController {
    
    let realm = try! Realm()
    var plan: Plan!
 
    
    @IBOutlet weak var entryTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(plan.title)
        print(plan ?? "")
        entryTitle.text = plan.title
        
    }
    
    @IBAction func entryBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func entryAdd(_ sender: Any) {
        
        let alert = UIAlertController(title: "達成の登録", message: "達成できたを登録してよろしいですか？", preferredStyle: .alert)
        
        let registerAchieve = UIAlertAction(title: "登録", style: .default, handler: { (action) -> Void in
            print("達成 button tapped")
            try! self.realm.write {
                self.plan.attain = 1
                self.realm.add(self.plan, update: .modified)
            }
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAchieve  = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            print("達成　cancel button tapped")
            
        })
        
        alert.addAction(registerAchieve)
        alert.addAction(cancelAchieve)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func entryDrop(_ sender: Any) {
        
        let alert = UIAlertController(title: "達成の登録", message: "達成できなかったを登録してよろしいですか？", preferredStyle: .alert)
        
        let registerUnachieve = UIAlertAction(title: "登録", style: .default, handler: { (action) -> Void in
            print("未達成 button tapped")
            try! self.realm.write {
                self.plan.attain = 2
                self.realm.add(self.plan, update: .modified)
            }
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelUnachieve = UIAlertAction(title: "キャンセル", style: .cancel, handler: { (action) -> Void in
            print("未達成　cancel button tapped")
        })
        
        alert.addAction(registerUnachieve)
        alert.addAction(cancelUnachieve)
        
        self.present(alert, animated: true, completion: nil)
        
    }
}
