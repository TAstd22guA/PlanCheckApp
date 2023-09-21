//
//  InputViewController.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/13.
//

import UIKit
import RealmSwift

class InputViewController: UIViewController {
    
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let realm = try! Realm()
    var plan: Plan!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 内容の枠線のカラー
        contentsTextView.layer.borderColor = UIColor.black.cgColor
        // 内容の枠線の幅
        contentsTextView.layer.borderWidth = 1.0
        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGesture)
        
        categoryTextField.text = plan.category
        titleTextField.text = plan.title
        contentsTextView.text = plan.contents
        datePicker.date = plan.date
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //カテゴリ、タイトル、内容がないときはRealmにはaddしない
        //カテゴリが空白がどうか確認
        if self.categoryTextField.text! != "" {
            
            //タイトルと内容が空白かどうか確認
            if(self.titleTextField.text! != "" && self.contentsTextView.text != ""){
                
                //カテゴリ、タイトル、内容が入力されていれば、Realmに追加
                try! realm.write {
                    self.plan.category = self.categoryTextField.text!
                    self.plan.title = self.titleTextField.text!
                    self.plan.contents = self.contentsTextView.text
                    self.plan.date = self.datePicker.date
                    self.realm.add(self.plan, update: .modified)
                    
                    setNotification(plan: plan)
                }
                
            }
            
        }
        
        super.viewWillDisappear(animated)
    }
    
    // タスクのローカル通知を登録
    func setNotification(plan: Plan) {
        let content = UNMutableNotificationContent()
        // タイトルと内容を設定(中身がない場合メッセージ無しで音だけの通知になるので「(xxなし)」を表示)
        if plan.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = plan.title
        }
        if plan.contents == "" {
            content.body = "(内容なし)"
        } else {
            content.body = plan.contents
        }
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: plan.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(plan.id.stringValue), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
    }
    
    @objc func dismissKeyboard(){
        // キーボードを閉じる
        view.endEditing(true)
    }
    
}
