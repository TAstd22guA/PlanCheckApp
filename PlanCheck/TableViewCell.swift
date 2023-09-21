//
//  TableViewCell.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/15.
//

import UIKit
import RealmSwift
import UserNotifications
import SwiftUI

class TableViewCell: UITableViewCell {

    @IBOutlet weak var planTitle: UILabel!
    
    @IBOutlet weak var planContents: UILabel!
    
    @IBOutlet weak var planTime: UILabel!
     
    var indexPath = IndexPath()
    
    @IBAction func entryButton(_ sender: UIButton) {
//        print(indexPath.row)
//        let planArray = try! Realm().objects(Plan.self).sorted(byKeyPath: "date", ascending: true)
//        let plan = planArray[indexPath.row]
//        print(plan.title)
//        print(plan.contents)
//        print(plan.id)
    
   
    }
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
