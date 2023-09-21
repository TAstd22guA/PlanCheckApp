//
//  CheckViewController.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/15.
//

import UIKit
import RealmSwift
import UserNotifications
import Foundation
import Charts

class CheckViewController: UIViewController {
    
    
    let realm = try! Realm()
    var plan: Plan!
    
    var percent: String = ""
    var checkToday: String = ""
    var checkLastDay: String = ""
    var checkSuccess : Int = 0
    var checkFailure : Int = 0
    
    @IBOutlet weak var percentCheck: UILabel!
    
    @IBOutlet weak var checkStart: UILabel!
    
    @IBOutlet weak var checkLast: UILabel!
    
    @IBOutlet weak var pieChart: PieChartView!
    
    @IBAction func checkButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //達成率計算結果値受け入れ
        percentCheck.text = String(percent)
        //開始基準日（今日）の表示
        checkStart.text = String(checkToday)
        //開始基準日（今日）の表示
        checkLast.text = String(checkLastDay)
        
        print(checkToday)
        print(checkLastDay)
        print(checkSuccess)
        print(checkFailure)
        
        // グラフの中央に表示されるテキスト
        pieChart.centerText = "達成率"
        
        // グラフの右下に表示されるテキスト
        //pieChart.chartDescription.text = "このランキングは、今まで食べた果物の中から、\n独断と偏見のみで順位づけしています。"
        
        // データセット
        let entries = [
            PieChartDataEntry(value: Double(checkSuccess), label: "達成"),
            PieChartDataEntry(value: Double(checkFailure), label: "未達成"),
        ]
        let dataSet = PieChartDataSet(entries: entries, label: "項目")
        
        // グラフの値を％表示するかどうか
        pieChart.usePercentValuesEnabled = true
        
        // グラフの色
        dataSet.colors = ChartColorTemplates.vordiplom()
        
        // データのラベル色
        dataSet.valueTextColor = .black
        
        // グラフに設定
        let chartData = PieChartData(dataSet: dataSet)
        pieChart.data = chartData
        
    }
}
