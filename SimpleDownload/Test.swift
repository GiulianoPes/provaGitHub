//
//  Test.swift
//  SimpleDownload
//
//  Created by Giuliano Pes on 31/10/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class Test{
    
    var view:ViewController?
    
    var sequentialTest:Bool?
    
    //viene aggiornato alla conclusione di ogni test
    var result: (String,Double)?{
        didSet{
            if let result = result{
                print("\(result.0) \(result.1)")
                sequentialSet(result: result)
            }
        }
    }
    
    var download1:Download?
    var download2:Download?
    var download3:Download?
    
    var upload1:Upload?
    var upload2:Upload?
    var upload3:Upload?
    
    //Tipi di connessioni identificate
    var velocitàDownload:String?
    var velocitàUpload:String?
    
    let stringUrl:String
    
    init(view : ViewController, stringUrl:String, sequentialTest:Bool){
        self.view = view
        self.sequentialTest = sequentialTest
        self.stringUrl = stringUrl
    }
}

//BEREC test in Download
extension Test{
    //durata totale 12 secondi
    func doDownloadBerecTest(){
        
        guard let _ = velocitàDownload else{return}
        let strUrl = "\(self.stringUrl)\(velocitàDownload!)"
        //let strUrl = "http://192.168.1.5/exampleServer/\(velocitàDownload!)"
        let uniqueUrl = URL(string: strUrl)!
        //print(uniqueUrl.description)
        
        self.download1 = Download.init(id: 1,url: uniqueUrl, test: self)
        self.download2 = Download.init(id: 2,url: uniqueUrl, test: self)
        self.download3 = Download.init(id: 3,url: uniqueUrl, test: self)
        
        download1!.startTestBerecDownload()
        download2!.startTestBerecDownload()
        download3!.startTestBerecDownload()
    }
    
    func showBerecDownloadSpeed(){
        if berecDownloadTestIsComplete(){
            let totalBytesReceived:Double = self.download1!.interval10secondsBytes! + self.download2!.interval10secondsBytes! + self.download3!.interval10secondsBytes!
            
            
            //let berecSpeed = ((totalBytesReceived)*8)/10/1000/1000
            let berecSpeed = ((totalBytesReceived)*8)/10/1000
            
            
            //self.view!.showBerecTestResult(berecSpeed: berecSpeed)
            self.view!.showBerecDownloadResult(estimatedSpeed: berecSpeed)
            self.result = ("BEREC download",berecSpeed)
        }
    }
    
    func berecDownloadTestIsComplete()->Bool{
        if let _ = self.download1!.interval10secondsBytes, let _ = self.download2!.interval10secondsBytes, let _ = self.download3!.interval10secondsBytes{
            return true
        }
        return false
        
    }
}

///BEREC test in Upload
extension Test{
    //durata totale 12 secondi
    func doUploadBerecTest(){
        
        guard let _ = velocitàUpload else{return}
        let url = URL(string: self.stringUrl)!
        //let url = URL(string: "http://192.168.1.5/exampleServer/")!
        
        self.upload1 = Upload.init(id: 1,url: url, test: self)
        self.upload2 = Upload.init(id: 2,url: url, test: self)
        self.upload3 = Upload.init(id: 3,url: url, test: self)
        
        let loadData:LoadData = LoadData.init()
        let data:Data = loadData.getRightConnection(speed: velocitàUpload!)
       
        self.upload1!.startTestBerecUpload(data: data)
        self.upload2!.startTestBerecUpload(data: data)
        self.upload3!.startTestBerecUpload(data: data)
    }
    
    func showBerecUploadSpeed(){
        if berecUploadTestIsComplete(){
            let totalBytesSent:Double = self.upload1!.interval10secondsBytes! + self.upload2!.interval10secondsBytes! + self.upload3!.interval10secondsBytes!
            
            //let berecSpeed = ((totalBytesSent)*8)/10/1000/1000
            let berecSpeed = ((totalBytesSent)*8)/10/1000
            
            
            self.view!.showBerecUploadResult(estimatedSpeed: berecSpeed)
            self.result = ("BEREC upload",berecSpeed)
        }
    }
    
    func berecUploadTestIsComplete()->Bool{
        if let _ = self.upload1!.interval10secondsBytes, let _ = self.upload2!.interval10secondsBytes, let _ = self.upload3!.interval10secondsBytes{
            return true
        }
        return false
    }
}
extension Test{
    //metodi di supporto rilevamento banda
    func setBandaDownload(stimaDownload: Double){
        switch stimaDownload{
        case 1.0...10.0:
            //print("10Mbps")
            self.velocitàDownload = "10MbpsX12"
            doEstimatedUploadTest(seconds: 4)
            return
        case 10.0...100.0:
            //print("100Mbps")
            self.velocitàDownload = "100MbpsX12"
            doEstimatedUploadTest(seconds: 4)
            return
        case 100.0...1000.0:
            //print("1000Mbps")
            self.velocitàDownload = "1000MbpsX12"
            doEstimatedUploadTest(seconds: 4)
            return
        default:
            print("ooops")
            return
        }
    }
    func setBandaUpload(stimaUpload: Double){
        switch stimaUpload{
        case 1.0...10.0:
            //print("10Mbps")
            self.velocitàUpload = "10MbpsX12"
            //print("\(velocitàDownload!) \(velocitàUpload!)")
            doDownloadBerecTest()
            return
        case 10.0...100.0:
            //print("100Mbps")
            self.velocitàUpload = "100MbpsX12"
            //print("\(velocitàDownload!) \(velocitàUpload!)")
            doDownloadBerecTest()
            return
        case 100.0...1000.0:
            //print("1000Mbps")
            self.velocitàUpload = "1000MbpsX12"
            //print("\(velocitàDownload!) \(velocitàUpload!)")
            doDownloadBerecTest()
            return
        default:
            print("ooops")
            return
        }
    }
    //str-to-bytes
    func speedToBytes(speed:String)->Double{
        //print("speedToBytes: \(speed)")
        switch speed {
        case "10MbpsX12":
            return 15728640.0
        case "100MbpsX12":
            return 157286400.0
        case "1000MbpsX12":
            return 1572864000.0
        default:
            print("error speedTOBytes")
            return 0.0
        }
    }
    
    func sequentialSet(result: (String,Double)){
        if self.sequentialTest!{
            switch result.0{
            case "stima download":
                //metodo
                setBandaDownload(stimaDownload: result.1)
                return
            case "stima upload":
                //setta i parametri per il Test BEREC
                setBandaUpload(stimaUpload: result.1)
                return
            case "BEREC download":
                doUploadBerecTest()
                return
            case "BEREC upload":
                return
            default:
                print("ooops")
                return
            }
        }else{
            print("test singolo")
        }
    }
}


//stima della velocità in upload
extension Test{
    func doEstimatedUploadTest(seconds: Int){
        let url = URL(string: self.stringUrl)!
        //let url = URL(string: "http://192.168.1.5/exampleServer/")!
        
        self.upload1 = Upload.init(id: 1,url: url, seconds: seconds, test: self)
        self.upload2 = Upload.init(id: 2,url: url, seconds: seconds, test: self)
        self.upload3 = Upload.init(id: 3,url: url, seconds: seconds, test: self)
        
        let loadData:LoadData = LoadData.init()
        let data:Data = loadData.get1000Mbps()//dimensione fissa per 4 secondi a 1Gbps=1000Mbps
        
        self.upload1!.startEstimate(data: data)
        self.upload2!.startEstimate(data: data)
        self.upload3!.startEstimate(data: data)
    }
    
    func updateProgressUpload(upload: Upload){
        self.view!.updateProgressUpload(upload: upload)
    }
    
    func showEstimatedUploadSpeed(seconds: Int){
        if estimatedUploadTestIsComplete(){
            let totalBytesSent:Double = self.upload1!.bytesOfDataUploaded! + self.upload2!.bytesOfDataUploaded! + self.upload3!.bytesOfDataUploaded!
            let estimatedSpeed = ((totalBytesSent)*8)/Double(seconds)/1000/1000
            self.view!.showEstimatedUploadResult(estimatedSpeed: estimatedSpeed)
            self.result = ("stima upload",estimatedSpeed)
        }
    }
    
    func estimatedUploadTestIsComplete()->Bool{
        if let _ = self.upload1!.bytesOfDataUploaded, let _ = self.upload2!.bytesOfDataUploaded, let _ = self.upload3!.bytesOfDataUploaded{
            return true
        }
        return false
    }
}

//stima della velocità in download
extension Test{
    func doEstimatedDownloadTest(seconds: Int){
        let url = URL(string: "\(self.stringUrl)1000Mbps")!//file da 524.288.000
        //let url = URL(string: "http://192.168.1.5/exampleServer/1000Mbps")!//file da 524.288.000
        
        self.download1 = Download.init(id: 1,url: url, seconds: seconds, test: self)
        self.download2 = Download.init(id: 2,url: url, seconds: seconds, test: self)
        self.download3 = Download.init(id: 3,url: url, seconds: seconds, test: self)
        
        self.download1!.startEstimate()
        self.download2!.startEstimate()
        self.download3!.startEstimate()
    }
    
    func updateProgressDownload(download: Download){
        self.view!.updateProgressDownload(download: download)
    }
    
    func showEstimatedDownloadSpeed(seconds: Int){
        if estimatedDownloadTestIsComplete(){
            let totalBytesReceives:Double = self.download1!.bytesOfDataDownloaded! + self.download2!.bytesOfDataDownloaded! + self.download3!.bytesOfDataDownloaded!
            let estimatedSpeed = ((totalBytesReceives)*8)/Double(seconds)/1000/1000
            self.view!.showEstimatedDownloadResult(estimatedSpeed: estimatedSpeed)
            self.result = ("stima download",estimatedSpeed)
        }
    }
    
    func estimatedDownloadTestIsComplete()->Bool{
        if let _ = self.download1!.bytesOfDataDownloaded, let _ = self.download2!.bytesOfDataDownloaded, let _ = self.download3!.bytesOfDataDownloaded{
            return true
        }
        return false
    }
}
