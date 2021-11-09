//
//  NPKDanmakuTextCellModel.swift
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/11/9.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

import Foundation
import DanmakuKit

class NPKDanmakuTextCellModel: DanmakuCellModel, Equatable {
    
    var identifier = ""
    
    var text = ""
    
    var font = UIFont.systemFont(ofSize: 15)
    
    var offsetTime: TimeInterval = 0
    
    var cellClass: DanmakuCell.Type {
        return NPKDanmakuTextCell.self
    }
    
    var size: CGSize = .zero
    
    var track: UInt?
    
    var displayTime: Double = 8
    
    var type: DanmakuCellType = .floating
    
    var isPause = false
    
    func calculateSize() {
        size = NSString(string: text).boundingRect(with: CGSize(width: CGFloat(Float.infinity
            ), height: 20), options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil).size
    }
    
    static func == (lhs: NPKDanmakuTextCellModel, rhs: NPKDanmakuTextCellModel) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    func isEqual(to cellModel: DanmakuCellModel) -> Bool {
        return identifier == cellModel.identifier
    }
    
    init(msg: String, cellType: DanmakuCellType) {
        text = msg
        type = cellType
    }
}
