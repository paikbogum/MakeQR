//
//  QRCameraFrameOverlayView.swift
//  CreatePixelQR
//
//  Created by 백현진 on 1/17/25.
//

import UIKit

class QRFrameOverlayView: UIView {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 프레임 색상과 두께 설정
        let frameColor = CustomColor.weakCalendarFontColor.color
        let lineWidth: CGFloat = 4.0
        let cornerLength: CGFloat = 20.0 // 모서리 길이

        // 경로 생성
        let path = UIBezierPath()
        
        // 네모난 프레임의 각 모서리 좌표 계산
        let topLeft = CGPoint(x: rect.minX, y: rect.minY)
        let topRight = CGPoint(x: rect.maxX, y: rect.minY)
        let bottomLeft = CGPoint(x: rect.minX, y: rect.maxY)
        let bottomRight = CGPoint(x: rect.maxX, y: rect.maxY)
        
        // 각 모서리에 경로 추가 (네모 가장자리만)
        // 왼쪽 위
        path.move(to: topLeft)
        path.addLine(to: CGPoint(x: topLeft.x + cornerLength, y: topLeft.y))
        path.move(to: topLeft)
        path.addLine(to: CGPoint(x: topLeft.x, y: topLeft.y + cornerLength))
        
        // 오른쪽 위
        path.move(to: topRight)
        path.addLine(to: CGPoint(x: topRight.x - cornerLength, y: topRight.y))
        path.move(to: topRight)
        path.addLine(to: CGPoint(x: topRight.x, y: topRight.y + cornerLength))
        
        // 왼쪽 아래
        path.move(to: bottomLeft)
        path.addLine(to: CGPoint(x: bottomLeft.x + cornerLength, y: bottomLeft.y))
        path.move(to: bottomLeft)
        path.addLine(to: CGPoint(x: bottomLeft.x, y: bottomLeft.y - cornerLength))
        
        // 오른쪽 아래
        path.move(to: bottomRight)
        path.addLine(to: CGPoint(x: bottomRight.x - cornerLength, y: bottomRight.y))
        path.move(to: bottomRight)
        path.addLine(to: CGPoint(x: bottomRight.x, y: bottomRight.y - cornerLength))
        
        // 경로 색상 및 스타일 설정
        frameColor.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
    }
}
