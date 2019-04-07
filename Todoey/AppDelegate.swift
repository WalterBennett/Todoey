//
//  AppDelegate.swift
//  Todoey
//
//  Created by Walter Bennett on 3/21/19.
//  Copyright © 2019 Walter Bennett. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Find out where our REALM file is
        // print(Realm.Configuration.defaultConfiguration.fileURL ?? "No configuration file found")
        
        // Initialize Realm
        do {
            _ = try Realm()
            
        } catch {
            print("Error initialising new Realm, \(error)")
        }
        
        return true
    }



}

