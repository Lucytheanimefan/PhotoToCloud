//
//  Settings.swift
//  PhotoToCloud iOS
//
//  Created by Lucy Zhang on 5/27/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit

class Settings: NSObject {
    
    static let shared = Settings()
    
    lazy var flickrArgs = {
        return ["is_public":self.is_public.description, "is_friend":self.is_friend.description, "is_family":self.is_family.description, "safety_level":self.safety_level.description]
    }()
    
    private var is_public_val = 0
    var is_public: Int {
        get {
            if let value = UserDefaults.standard.value(forKey: "is_public") as? Int{
                return value
            }
            return is_public_val
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "is_public")
            is_public_val = newValue
        }
    }
    
    private var is_friend_val = 0
    var is_friend: Int{
        get {
            if let value = UserDefaults.standard.value(forKey: "is_friend") as? Int{
                return value
            }
            return is_friend_val
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "is_friend")
            is_friend_val = newValue
        }
    }
    
    private var is_family_val = 0
    var is_family: Int{
        get {
            if let value = UserDefaults.standard.value(forKey: "is_family") as? Int{
                return value
            }
            return is_family_val
            
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "is_family")
            is_family_val = newValue
        }
    }
    
    private var safety_level_val:Int = Constants.Flickr.safe
    
    var safety_level:Int  {
        get {
            if let value = UserDefaults.standard.value(forKey: "safety_level") as? Int{
                return value
            }
            return safety_level_val
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "safety_level")
            safety_level_val = newValue
        }
    }
    
    
}
