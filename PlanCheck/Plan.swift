//
//  Plan.swift
//  PlanCheck
//
//  Created by mawincommon on 2023/09/13.
//

import RealmSwift

class Plan: Object {
    // 管理用 ID。プライマリーキー
    @Persisted(primaryKey: true) var id: ObjectId
    
    // カテゴリー
    @Persisted var category = ""
    
    // プラン名
    @Persisted var title = ""
    
    // プラン内容
    @Persisted var contents = ""
    
    // 締切期限
    @Persisted var date = Date()
    
    // 達成又は未達成
    @Persisted var attain = 0
    
}
