//
//  AppDelegate.swift
//  Flipsy
//
//  Created by Dot on 06/01/2017.
//  Copyright © 2017 Dot. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let app = Coordinator()
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
        window = UIWindow(frame: UIScreen.main.bounds)
        app.setup(window: window)
        
        UIApplication.shared.statusBarView?.backgroundColor = .white
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {}

    func applicationDidEnterBackground(_ application: UIApplication) {}

    func applicationWillEnterForeground(_ application: UIApplication) {}

    func applicationDidBecomeActive(_ application: UIApplication) {}

    func applicationWillTerminate(_ application: UIApplication) {}

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("Oh no, memory!")
    }

}

