//
//  AppDelegate.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/16.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.rootViewController = UINavigationController.init(rootViewController: ViewController.init())
        self.window?.makeKeyAndVisible()
        self.window?.backgroundColor = UIColor.white
        
        return true
    }




}

