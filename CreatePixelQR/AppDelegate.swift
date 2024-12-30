//
//  AppDelegate.swift
//  CreatePixelQR
//
//  Created by 백현진 on 11/21/24.
//

import UIKit
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    static var window: UIWindow { (UIApplication.shared.delegate?.window!)! }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        KakaoSDK.initSDK(appKey: "01687814a44533474df65ffe2e42686c")
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: MainViewController())
        self.window?.rootViewController = navigationController
        
        self.window?.makeKeyAndVisible()
        
        //탭바 배경색 변경
        if #available(iOS 15.0, *) {
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            //바꾸고 싶은 색으로 backgroundColor를 설정
            UITabBar.appearance().backgroundColor = CustomColor.darkModeDarkGrayColor.color
            UITabBar.appearance().tintColor = CustomColor.caldendarFontColor.color
            UITabBar.appearance().unselectedItemTintColor = .white
        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

