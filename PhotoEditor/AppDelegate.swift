//
//  AppDelegate.swift
//  PhotoEditor
//
//  Created by Md. Mominul Islam on 6/5/20.
//  Copyright © 2020 Bjit. All rights reserved.
//

import UIKit
import Intents

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    private func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        guard let intent = userActivity.interaction?.intent as? INStartWorkoutIntent else {
            print("AppDelegate: Start Workout Intent - FALSE")
            return false
        }
        print("AppDelegate: Start Workout Intent - TRUE")
        print(intent)
        return true
    }
}

