//
//  Download.swift
//  SimpleDownload
//
//  Created by Giuliano Pes on 31/10/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class Download: NSObject, URLSessionDownloadDelegate{
    
//variabili generiche
    let id:Int
    var url:URL
    var downloadTask: URLSessionDownloadTask?
    
//variabili per il Test BEREC
    var after2secondsBytes:Double?
    var after12secondsBytes:Double?
    var interval10secondsBytes:Double?
    
//variabili per la stima della velocità
    var bytesOfDataDownloaded:Double?
    var loadBytesDownloaded:Double{//da rimuovere
        get{
            return self.bytesOfDataDownloaded!
        }
        set(value){
            self.bytesOfDataDownloaded = value
            self.test.showEstimatedDownloadSpeed(seconds: self.seconds!)
        }
    }
    
    //
    var bytesExpectedToDownload:Double?
    
    //progress
    var progress:Float?
    var updateProgress:Float{
        get{
            return self.progress!
        }
        set(value){
            self.progress = value
            self.test.updateProgressDownload(download: self)
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
        //
        //solo in questo caso, dopo la stima della velocità di download, si vedrà che file andare a scaricare
        let velocità = test.velocitàDownload!
        self.bytesExpectedToDownload = test.speedToBytes(speed: velocità)
        //self.bytesExpectedToDownload = 209715200.0
    }
    
//Init per la stima della velocità
    init(id: Int,url:URL,seconds:Int, test:Test){
        self.id = id
        self.url = url
        self.test = test
        self.timer = Timer.init()
        self.bytesExpectedToDownload = 524288000.0 //PER 4 SECONDI A 1000Mbps
        self.seconds = seconds
    }
}

//TEST BEREC
extension Download{
    func startTestBerecDownload(){
        self.progress = 0.0
        let conf = URLSessionConfiguration.default
        let session = URLSession(configuration: conf, delegate: self , delegateQueue: OperationQueue.main)
        self.downloadTask = session.downloadTask(with: self.url)
        self.downloadTask!.resume()
        timerSeconds2()
        timerSeconds12()
    }
    
    func timerSeconds2(){
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.bytesAfter2Seconds), userInfo: nil, repeats: false)
    }
    @objc func bytesAfter2Seconds(){
        self.after2secondsBytes = Double(self.progress!)*self.bytesExpectedToDownload!
    }
    
    func timerSeconds12(){
        self.timer = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(self.bytesAfter12Seconds), userInfo: nil, repeats: false)
    }
    @objc func bytesAfter12Seconds(){
        self.downloadTask!.cancel()
        self.after12secondsBytes = Double(self.progress!)*self.bytesExpectedToDownload!
        
        self.interval10secondsBytes = self.after12secondsBytes! - self.after2secondsBytes!
        self.test.showBerecDownloadSpeed()
    }
}

//TEST stima della velocità
extension Download{
    func startEstimate(){
        //dimensione file fissa a 500MB
        self.bytesExpectedToDownload = 524288000.0
        self.progress = 0.0
        let conf = URLSessionConfiguration.default
        let session = URLSession(configuration: conf, delegate: self , delegateQueue: OperationQueue.main)
        self.downloadTask = session.downloadTask(with: self.url)
        self.downloadTask!.resume()
        timerSeconds(seconds: self.seconds!)
    }
    
    func timerSeconds(seconds:Int){
        self.timer = Timer.scheduledTimer(timeInterval: Double(seconds), target: self, selector: #selector(self.stop), userInfo: nil, repeats: false)
    }
    
    @objc func stop(){
        self.downloadTask!.cancel()
        self.loadBytesDownloaded = Double(self.progress!)*self.bytesExpectedToDownload!
    }
}

//METODI DELEGATI
extension Download{
    //Download completato
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        if let _ = downloadTask.error{
            print(downloadTask.error!.localizedDescription)
            //print("Ooops - Upload completato")
        }
        //print("Download completato! \(downloadTask.countOfBytesReceived)")
    }
    //Download in corso
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64){
        self.updateProgress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
}
