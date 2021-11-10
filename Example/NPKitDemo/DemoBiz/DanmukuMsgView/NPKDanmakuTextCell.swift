//
//  NPKDanmakuTextCell.swift
//  NPKitDemo_Example
//
//  Created by JinglongBi on 2021/11/9.
//  Copyright © 2021 jinglong.bi@me.com. All rights reserved.
//

import UIKit
import DanmakuKit

class NPKDanmakuTextCell: DanmakuCell {

    required init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willDisplay() {
        
    }
    
    override func displaying(_ context: CGContext, _ size: CGSize, _ isCancelled: Bool) {
        guard let model = model as? NPKDanmakuTextCellModel else { return }
        let text = NSString(string: model.text)
        context.setLineWidth(1)
        context.setLineJoin(.round)
        context.setStrokeColor(UIColor.red.cgColor)
        context.saveGState()
        context.setTextDrawingMode(.stroke)
        let attributes: [NSAttributedString.Key: Any] = [.font: model.font, .foregroundColor: UIColor.red]
        text.draw(at: .zero, withAttributes: attributes)
        context.restoreGState()
        
        context.setTextDrawingMode(.fill)
        text.draw(at: .zero, withAttributes: attributes)
    }
    
    override func didDisplay(_ finished: Bool) {
        
    }
}
