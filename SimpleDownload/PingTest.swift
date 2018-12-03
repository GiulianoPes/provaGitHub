//
//  PingTest.swift
//  SimpleDownload
//
//  Created by Giuliano Pes on 01/11/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class PingTest: NSObject, URLSessionDataDelegate {
    
    let view:ViewController
    
    var pingResult:[Double]{
        didSet{
            self.view.showPingStat(media: getMedia(), varianza: getVarianza())
        }
    }

    init(view:ViewController){
        self.view = view
        self.pingResult = [Double]()
    }
    
    //variabili temporali per cronometro
    /*
    var startTime:Date?
    var stopTime:Date?
    var timeInterval:TimeInterval?
    */
    
    func makePing(url:URL){
        let conf = URLSessionConfiguration.default
        //conf.timeoutIntervalForResource = 1
        //conf.timeoutIntervalForRequest = 1
        let session = URLSession.init(configuration: conf, delegate: self as URLSessionDelegate, delegateQueue: OperationQueue.main)
        var request = URLRequest.init(url: url)
        //request.httpMethod = "GET"
        request.httpMethod = "HEAD"
        //request.httpBody = nil
        //request.setValue("chunked", forHTTPHeaderField: "TE")
        //request.setValue("0", forHTTPHeaderField: "Content-Length")
        
        session.dataTask(with: request).resume()
        
        //self.startTime = Date.init()
    }
    
    func makePing(url:URL, ripeti: Int){
        for i in 1...ripeti{
            print("ping \(i)")
            usleep(1000000)
            makePing(url: url)
            
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        
        
        //Tempo calcolato attraverso la metrica di SWIFT4
        let taskInterval = metrics.taskInterval.duration.description
        
        //Tempo calcolato attraverso cronometro
        //self.stopTime = Date.init()
        //self.timeInterval = DateInterval.init(start: self.startTime!, end: self.stopTime!).duration
        
        if task.error != nil{
            if let e = task.error as? URLError{
                print(e.code)
            }
        }
        
        if let httpResponse = task.response as? HTTPURLResponse {
            if httpResponse.statusCode == 200{
                print("Server raggiunto - nessuno errore")
                print("Metrica \(Double(taskInterval)!*1000)")
                //self.timeInterval = DateInterval.init(start: self.startTime!, end: self.stopTime!).duration
                //print("Cronometro \((Double(self.timeInterval!.description))!*1000)")
                
                self.view.showResultPingTest(delay: String(taskInterval))
                self.pingResult.append(Double(String(taskInterval))!)
            }else{
                print(httpResponse.statusCode)
                
            }
        }
        
        /*
        self.view.showResultPingTest(delay: String(taskInterval))
        self.pingResult.append(Double(String(taskInterval))!)
        */
        //self.stopTime = Date.init()
        //self.timeInterval = DateInterval.init(start: self.startTime!, end: self.stopTime!).duration
    }
    
    func stampaPingResult(){
        for i in 0..<self.pingResult.count{
            print(self.pingResult[i])
        }
    }
    
    func getMedia()->Double{
        var media:Double = 0.0
        let numberValue:Int = self.pingResult.count
        
        for i in 0..<numberValue{
            media += self.pingResult[i]
        }
        return media/Double(numberValue)
    }
    
    func getVarianza()->Double{
        let media = getMedia()
        //var varianza:Double = 0.0
        var varianzaPow:Double = 0.0
        let numberValue:Int = self.pingResult.count
        
        for i in 0..<numberValue{
            varianzaPow += pow(self.pingResult[i]-media, 2.0)
        }
        return varianzaPow/Double(numberValue)
    }
}
