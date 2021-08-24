//
//  gConstants.swift
//  FitPetWeather
//
//  Created by SatGatLee on 2021/08/22.
//

import Foundation


var screenWidth: CGFloat = UIScreen.main.bounds.width
var screenHeight: CGFloat = UIScreen.main.bounds.height

public func iPrint(_ objects:Any... , filename:String = #file,_ line:Int = #line, _ funcname:String = #function){ //debuging Print
  #if DEBUG
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "HH:mm:ss:SSS"
  let file = URL(string:filename)?.lastPathComponent.components(separatedBy: ".").first ?? ""
  print("💦info 🦋\(dateFormatter.string(from:Date())) 🌞\(file) 🍎line:\(line) 🌹\(funcname)🔥",terminator:"")
  for object in objects{
    print(object, terminator:"")
  }
  print("\n")
  #endif
}


extension UIImageView {
  func URLString(urlString: String) {
    guard urlString != "" else {
      self.image = UIImage(named: "movieEmpty")
      return
    }
    let url = String(urlString.split(separator: "|")[0]).trimmingCharacters(in: .whitespacesAndNewlines)
    guard let img_url = URL(string: url) else { return }
    
    let resource = ImageResource(downloadURL: img_url, cacheKey: url)
    kf.setImage(with: resource)
  }
}

extension Date {
    
  public var day: Int {
    return Calendar.current.component(.day, from: self)
  }
  
  public var monthName: String {
    let nameFormatter = DateFormatter()
    nameFormatter.dateFormat = "MMM" // format January, February, March, ...
    return nameFormatter.string(from: self)
  }
  
  public var dayName: String {
    let nameFormatter = DateFormatter()
    nameFormatter.dateFormat = "EEE"
    return nameFormatter.string(from: self)
  }
}


public extension UIView {
  func addBottomBorderWithColor(color: UIColor) {
    
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - 2, width: self.frame.size.width, height: 2)
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }
  
  func addTopBorderWithColor(color: UIColor) {
    let border = CALayer()
    border.backgroundColor = color.cgColor
    border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 2)
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
  }
}
