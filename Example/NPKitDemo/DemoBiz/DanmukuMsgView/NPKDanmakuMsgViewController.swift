//
//  NPKDanmakuMsgViewController.swift
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/11/9.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

import Foundation
import DanmakuKit

class NPKDanmakuMsgViewController: NSObject {
    private var danmakus: [DanmakuCellModel] = []
    private var displayTime: Double = 8
    
    @objc
    public func sendCommonDanmaku(msg: String) {
        let cellModel = NPKDanmakuTextCellModel(msg: msg, cellType: .floating)
        cellModel.displayTime = displayTime
        cellModel.identifier = String(arc4random())
        cellModel.calculateSize()
        
        danmakuView.shoot(danmaku: cellModel)
        danmakus.append(cellModel)
    }
    
    @objc
    public lazy var danmakuView: DanmakuView = {
//        let view = DanmakuView(frame: CGRect(x: 0, y: 36, width: UIScreen.main.bounds.width, height: 40))
        let view = DanmakuView(frame: CGRect(x: 0, y: 36, width: 190, height: 40))
        view.backgroundColor = .clear
        view.delegate = self
        return view
    }()
}

extension NPKDanmakuMsgViewController: DanmakuViewDelegate {
    func danmakuView(_ danmakuView: DanmakuView, didEndDisplaying danmaku: DanmakuCell) {
        guard let model = danmaku.model else { return }
        danmakus.removeAll { (cm) -> Bool in
            return cm.isEqual(to: model)
        }
    }
}
