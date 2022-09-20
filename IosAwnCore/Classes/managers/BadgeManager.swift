//
//  BadgeManager.swift
//  awesome_notifications
//
//  Created by Rafael Setragni on 17/11/21.
//

import Foundation

public class BadgeManager {
    
    let TAG:String = "BadgeManager"
    
    // ************** SINGLETON PATTERN ***********************
    
    static var instance:BadgeManager?
    public static var shared:BadgeManager {
        get {
            BadgeManager.instance =
                BadgeManager.instance ?? BadgeManager()
            return BadgeManager.instance!
        }
    }
    private init(){}
    
    // ********************************************************
    
    private var _badgeAmount:NSNumber = 0

    public var globalBadgeCounter:Int {
        get {
            if !SwiftUtils.isRunningOnExtension() && Thread.isMainThread {
#if ACTION_EXTENSION
                _badgeAmount = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber)
#endif
            }
            else{
                let userDefaults = UserDefaults(suiteName: Definitions.USER_DEFAULT_TAG)
                let badgeCount:Int = userDefaults!.integer(forKey: Definitions.BADGE_COUNT)
                _badgeAmount = NSNumber(value: badgeCount)
            }
            return _badgeAmount.intValue
        }
        
        set {
            _badgeAmount = NSNumber(value: newValue)
            
            if !SwiftUtils.isRunningOnExtension() && Thread.isMainThread {
#if ACTION_EXTENSION
                UIApplication.shared.applicationIconBadgeNumber = newValue
#endif
            }
            else{
                _badgeAmount = NSNumber(value: newValue)
            }
            
            let userDefaults = UserDefaults(suiteName: Definitions.USER_DEFAULT_TAG)
            userDefaults!.set(newValue, forKey: Definitions.BADGE_COUNT)
        }
    }

    public func resetGlobalBadgeCounter() {
        globalBadgeCounter = 0
    }

    public func incrementGlobalBadgeCounter() -> Int {
        globalBadgeCounter += 1
        return globalBadgeCounter
    }

    public func decrementGlobalBadgeCounter() -> Int {
        globalBadgeCounter = max(globalBadgeCounter - 1, 0)
        return globalBadgeCounter
    }

}