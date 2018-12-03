//
//  Upload.swift
//  SimpleDownload
//
//  Created by Giuliano Pes on 01/11/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class Upload:NSObject, URLSessionDataDelegate{
    
//variabili generiche
    var id:Int
    var url:URL
    var uploadTask:URLSessionUploadTask?
    
//variabili per il Test BEREC
    var after2secondsBytes:Double?
    var after12secondsBytes:Double?
    var interval10secondsBytes:Double?
    
//variabili per la stima della velocità
    var bytesOfDataUploaded:Double?
    var loadBytesUploaded:Double{
        get{
            return self.bytesOfDataUploaded!
        }
        set(value){
            self.bytesOfDataUploaded = value
            self.test.showEstimatedUploadSpeed(seconds: self.seconds!)
        }
    }
    //
    var bytesExpectedToUpload:Double?
    
    //progress
    var progress:Float?
    var updateProgress:Float{
        get{
            return self.progress!
        }
        set(value){
            self.progress = value
            self.test.updateProgressUpload(upload: self)
        }
    }
    
    var timer:Timer?
    var seconds:Int?
    
    var test:Test
    
//Init per il test BEREC
    init(id: Int, url:URL, test:Test){
        self.id = id
        self.url = url
        self.test = test
        self.timer = Timer.init()
    }
//Init per la stima della velocità
    init(id:Int, url:URL,seconds:Int ,test:Test) {
        self.id = id
        self.url = url
        self.test = test
        self.timer = Timer.init()
        self.seconds = seconds
    }
}
//TEST BEREC
extension Upload{
    func startTestBerecUpload(data:Data){
        self.progress = 0.0
        let conf = URLSessionConfiguration.default
        let session = URLSession.init(configuration: conf, delegate: self as URLSessionDataDelegate?, delegateQueue: OperationQueue.main)
        var request = URLRequest.init(url: self.url)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue("chunked", forHTTPHeaderField: "TE")
        self.bytesExpectedToUpload = Double(data.count)
        self.uploadTask = session.uploadTask(with: request, from: data)
        self.uploadTask!.resume()
        
        timerSeconds2()
        timerSeconds12()
    }
    
    func timerSeconds2(){
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.bytesAfter2Seconds), userInfo: nil, repeats: false)
    }
    @objc func bytesAfter2Seconds(){
        self.after2secondsBytes = Double(self.progress!)*self.bytesExpectedToUpload!
    }
    
    func timerSeconds12(){
        self.timer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(self.bytesAfter12Seconds), userInfo: nil, repeats: false)
    }
    @objc func bytesAfter12Seconds(){
        self.uploadTask!.cancel()
        self.after12secondsBytes = Double(self.progress!)*self.bytesExpectedToUpload!
        
        self.interval10secondsBytes = self.after12secondsBytes! - self.after2secondsBytes!
        self.test.showBerecUploadSpeed()
    }
}

//TEST stima della velocità
extension Upload{
    func startEstimate(data: Data){
        self.progress = 0.0
        let conf = URLSessionConfiguration.default
        let session = URLSession.init(configuration: conf, delegate: self as URLSessionDataDelegate?, delegateQueue: OperationQueue.main)
        var request = URLRequest.init(url: self.url)
        request.httpMethod = "POST"
        request.setValue("Keep-Alive", forHTTPHeaderField: "Connection")
        request.setValue("chunked", forHTTPHeaderField: "TE")
        self.bytesExpectedToUpload = Double(data.count)
        self.uploadTask = session.uploadTask(with: request, from: data)
        self.uploadTask!.resume()
        
        timerSeconds(seconds: self.seconds!)
    }
    
    func timerSeconds(seconds : Int){
        self.timer = Timer.scheduledTimer(timeInterval: Double(seconds), target: self, selector: #selector(self.stop), userInfo: nil, repeats: false)
    }
    @objc func stop(){
        self.uploadTask!.cancel()
        self.loadBytesUploaded = Double(self.updateProgress)*self.bytesExpectedToUpload!
        //self.loadBytesUploaded = Double(self.progress!)*self.bytesExpectedToUpload!
    }
}

//METODI DELEGATI
extension Upload{
        
    //Upload completato
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        if let _ = task.error{
            //print(task.error!.localizedDescription)
            //print("Ooops - Upload completato")
        }
    }
    
    //Upload in corso
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        //print("Upload in corso")
        self.updateProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    }
}
