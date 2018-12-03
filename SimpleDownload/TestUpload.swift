//
//  TestUpload.swift
//  SimpleDownload
//
//  Created by Giuliano Pes on 01/11/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import Foundation

class TestUpload:NSObject, URLSessionDataDelegate{
    
    //variabili generiche
    var id:Int
    var url:URL
    var uploadTask:URLSessionUploadTask?
    
}

//METODI DELEGATI
extension TestUpload{
    
    //Upload completato
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics){
        print("Upload completato")
        /*
         if let _ = task.error{
         print(task.error!.localizedDescription)
         }
         */
    }
    
    //Upload in corso
    public func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64){
        //print("Upload in corso")
        self.updateProgress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    }
}
