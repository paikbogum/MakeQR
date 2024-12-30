//
//  TabBarController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/30/24.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var upperLineView: UIView!
    let spacing: CGFloat = 12
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
            self.addTabbarIndicatorView(index: 0, isFirstTime: true)
        }
        
    }
    
    func addTabbarIndicatorView(index: Int, isFirstTime: Bool = false){
        print(index)
        guard let tabView = tabBar.items?[index].value(forKey: "view") as? UIView else {
            return
        }
        if !isFirstTime{
            upperLineView.removeFromSuperview()
        }
        upperLineView = UIView(frame: CGRect(x: tabView.frame.minX + spacing, y: tabView.frame.minY + 0.1, width: tabView.frame.size.width - spacing * 2, height: 2))
        upperLineView.backgroundColor = CustomColor.caldendarFontColor.color
        tabBar.addSubview(upperLineView)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectIndex = tabBar.items?.firstIndex(of: item)!
        addTabbarIndicatorView(index: selectIndex!)
    }
}
