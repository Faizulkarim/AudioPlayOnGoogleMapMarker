//
//  GFunction.swift
//  Technical Test Venturas
//
//  Created by Faizul Karim on 9/11/21.
//

import UIKit

class GFunction: NSObject {
    static let shared   : GFunction = GFunction()
    
    func soundRename(currentName : String, newName: String){
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let documentDirectory = URL(fileURLWithPath: path)
            let originPath = documentDirectory.appendingPathComponent("\(currentName).m4a")
            let destinationPath = documentDirectory.appendingPathComponent("\(newName).m4a")
            try FileManager.default.moveItem(at: originPath, to: destinationPath)
        } catch {
            print(error)
        }
    }
    
    func timeFormatted(_ recordTime: Int) -> String {
          let seconds: Int = recordTime % 60
          let minutes: Int = (recordTime / 60) % 60
          let hours: Int = recordTime / 3600
          return String(format: "%02d:%02d:%02d", hours,minutes, seconds)
      }
}
