//
//  ViewController.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/13.
//

import UIKit
import RealmSwift
import UserNotifications
import SwiftUI
import Foundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    //EntryViewControllerへ遷移
    @IBAction func entryButton(_ sender: Any, forEvent event: UIEvent) {
        
        let planArray = try! Realm().objects(Plan.self).sorted(byKeyPath: "date", ascending: true)
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        // 配列からタップされたインデックスのデータを取り出す
        let plan = planArray[indexPath!.row]
        let entrytViewController = self.storyboard?.instantiateViewController(withIdentifier: "Entry") as! EntryViewController
        entrytViewController.plan = plan
        self.present(entrytViewController, animated: true, completion: nil)
        
    }
    
    // Realmインスタンスを取得
    let realm = try! Realm()
    
    // DB内のタスクが格納されるリスト。日付の近い順でソート（昇順）。以降内容をアップデートするとリスト内は自動的に更新。
    var planArray = try! Realm().objects(Plan.self).sorted(byKeyPath: "date", ascending: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.fillerRowHeight = UITableView.automaticDimension
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //searchBarのキャンセルボタンを表示
        searchBar.showsCancelButton = true
        
        //backbutton
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "戻る", style: .plain, target: nil,action: nil)
        self.navigationItem.backBarButtonItem!.tintColor = .white
        
        //rightbutton
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "達成項目", style: .plain, target: self, action: #selector(goCheck))
        self.navigationItem.rightBarButtonItem!.tintColor = .white
        
    }
    
    var checkIndex:Int = 0
    
    //rightbuttonの動作
    @objc func goCheck(_ sender: Any, forEvent event: UIEvent) {
        
        let checkViewController = self.storyboard?.instantiateViewController(withIdentifier: "Check") as! CheckViewController
        
        let allData = realm.objects(Plan.self)
        print("\(allData):Realmに保存した全てのUserレコード")
        
        //期間基準日（今日）
        let dt = Date()
        let dateFormatter = DateFormatter()
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        checkViewController.checkToday = dateFormatter.string(from: dt) + "から"
        
        
        //期間終了日（１ヶ月前）
        let dtLast = Calendar.current.date(byAdding: .day, value: -31, to: dt)!
        
        // DateFormatter を使用して書式とロケールを指定する
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale(identifier: "ja_JP"))
        checkViewController.checkLastDay = dateFormatter.string(from: dtLast) + "まで"
        
        //期間を指定してデータを抽出
        let selectAllData = realm.objects(Plan.self).filter("date >= %@ AND date < %@",dtLast,dt)
        
        // 期間指定の検索結果の件数を取得
        let countAll = Float(selectAllData.count)
        print(countAll)
        
        //期間内で達成した件数
        let success = selectAllData.filter("attain == 1")
        let successCount = Float(success.count)
        print(successCount)
        checkViewController.checkSuccess = Int(successCount)
        
        //期間内で未達成件数
        let failure = selectAllData.filter("attain == 2")
        let failureCount = Float(failure.count)
        print(failureCount)
        checkViewController.checkFailure = Int(failureCount)
        
        //達成率の計算（達成/Check登録済み件数）
        let calc = (successCount / countAll) * 100
        
        checkViewController.percent = String(format: "%.2f",calc)
        
        checkViewController.selectSuccess = success
        checkViewController.selectFailure = failure
        
        self.present(checkViewController, animated: true, completion: nil)
        
    }
    
    //searchBarのキャンセルボタンが押されたときの動作
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        planArray = realm.objects(Plan.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
        
    }
    
    //searchBar（検索バー）の動作設定（カテゴリの一部分合致で表示）
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            planArray = realm.objects(Plan.self).sorted(byKeyPath: "date", ascending: true)
            tableView.reloadData()
        } else {
            planArray = realm.objects(Plan.self).where({$0.category.contains(searchBar.text!)})
            tableView.reloadData()
        }
    }
    
    // データの数（＝セルの数）を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planArray.count
    }
    
    
    // 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        // Cellに値を設定
        let plan = planArray[indexPath.row]
        
        cell.planTitle.text = plan.title
        cell.planContents.text = plan.contents
        
        cell.textLabel?.numberOfLines=0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        let dateString:String = formatter.string(from: plan.date)
        cell.planTime.text = "締切期限" + " : " + dateString
        
        cell.indexPath = indexPath
        //print("セルのindex番号: \(indexPath.row)")
        
        return cell
    }
    
    
    // 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // 削除するタスクを取得
            let plan = self.planArray[indexPath.row]
            
            // ローカル通知をキャンセル
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(plan.id.stringValue)])
            
            // データベースから削除
            try! realm.write {
                self.realm.delete(plan)
                tableView.deleteRows(at: [indexPath], with: .fade)
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
    }
    
    // 入力画面から戻ってきた時に TableView を更新
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //検索結果を表示のままInputViewControllerに遷移。ViewControllerから遷移後、searchbarの検索文字を消去、tableViewをreload
        searchBar.text = ""
        planArray = realm.objects(Plan.self).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    // segue で画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let inputViewController:InputViewController = segue.destination as! InputViewController
        
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.plan = planArray[indexPath!.row]
        } else {
            inputViewController.plan = Plan()
        }
    }
}

