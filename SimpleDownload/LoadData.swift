//
//  LoadData.swift
//  SpeedTest
//
//  Created by Giuliano Pes on 20/10/18.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class LoadData{
 
    private var milleMbps:Data?
    private var dieciMbpsX12:Data?
    private var centoMbpsX12:Data?
    private var milleMbpsX12:Data?
    
    init(){
        let path1000Mbps = "Users/giulianopes/Documents/1000Mbps"
        let path10MbpsX12 = "Users/giulianopes/Documents/10MbpsX12"
        let path100MbpsX12 = "Users/giulianopes/Documents/100MbpsX12"
        let path1000MbpsX12 = "Users/giulianopes/Documents/1000MbpsX12"
        
        self.milleMbps = FileManager.default.contents(atPath: path1000Mbps)
        self.dieciMbpsX12 = FileManager.default.contents(atPath: path10MbpsX12)
        self.centoMbpsX12 = FileManager.default.contents(atPath: path100MbpsX12)
        self.milleMbpsX12 = FileManager.default.contents(atPath: path1000MbpsX12)
        
        guard let _ = self.milleMbps else{
            print("1000Mbps non trovato!")
            return
        }
        guard let _ = self.dieciMbpsX12 else{
            print("10MbpsX12 non trovato!")
            return
        }
        guard let _ = self.centoMbpsX12 else{
            print("100MbpsX12 non trovato!")
            return
        }
        guard let _ = self.milleMbpsX12 else{
            print("1000MbpsX12 non trovato!")
            return
        }
    }
    
    //randomData finali
    func get1000Mbps()->Data{
        return self.milleMbps!
    }
    
    func get10MbpsX12()->Data{
        return self.dieciMbpsX12!
    }
    
    func get100MbpsX12()->Data{
        return self.centoMbpsX12!
    }
    
    func get1000MbpsX12()->Data{
        return self.milleMbpsX12!
    }
    
    func getRightConnection(speed:String)->Data{
        switch speed {
            
        case "10MbpsX12":
            return get10MbpsX12()
        case "100MbpsX12":
            return get100MbpsX12()
        case "1000MbpsX12":
            return get1000MbpsX12()
        default:
            print("Default in LoadData")
            return get1000MbpsX12()
        }
    }
}
