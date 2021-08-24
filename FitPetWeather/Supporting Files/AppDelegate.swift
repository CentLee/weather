//
//  AppDelegate.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    let mainVC = WeatherListViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    guard let window = window else { return false }
    window.rootViewController = UINavigationController(rootViewController: mainVC)
    window.makeKeyAndVisible()
    return true
  }

  // MARK: UISceneSession Lifecycle



}

