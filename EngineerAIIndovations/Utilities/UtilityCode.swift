//
//  UtilityCode.swift
//  EngineerAIIndovations
//
//  Created by bhavan on 19/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

public class UtilityCode {
    
    
    // MARK: - Date Converter
    class func convertDateFormater(_ date: String) -> String{
           
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        
        let getDate = dateFormatter.date(from: date)
        
        dateFormatter.dateFormat = "MMM d, yyyy || h:mm a"
        
        return  dateFormatter.string(from: getDate!)
           
    }
    
    // MARK: - For Showing Activity Indicator
    class func showActivityIndicator (target: UIViewController, title: String? ,activity : ActivityIndicator) {
        
        target.view.addSubview(activity)
        activity.setAnchor(top: target.view.topAnchor , left: target.view.leftAnchor, bottom: target.view.bottomAnchor, right: target.view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0)
        activity.activity.startAnimating()
        activity.label.text = title ?? ""
        
    }
    
    // MARK: - For Removeing Activity Indicator from super vew
    class func hideActivityIndicator (target: UIViewController ,activity : ActivityIndicator) {
        
        activity.label.text = ""
        activity.activity.stopAnimating()
        activity.removeFromSuperview()
       
    }
    
}
