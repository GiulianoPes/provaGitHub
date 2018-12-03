//
//  ViewController.swift
//  SimpleDownload
//
//  Created by Giuliano Pes on 31/10/2018.
//  Copyright © 2018 Giuliano Pes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //parte BEREC
    var test:Test?
    //let stringUrl:String = "http://192.168.1.100:81/html/randomData/"
    //let stringUrl:String = "http://192.168.64.2/exampleServer/"
    let stringUrl:String = "http://192.168.1.5/exampleServer/"
    
    
    //parte ping
    var pingTest:PingTest?
    //let urlPing:URL = URL(string: "http://192.168.64.2/exampleServer/")!
    //let urlPing:URL = URL(string: "http://192.168.1.100:81/")!//server nemesys
    //let urlPing:URL = URL(string: "http://192.168.1.5/exampleServer/")!
    let urlPing:URL = URL(string: "http://8.8.8.8/")!
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var mediaLabel: UILabel!
    @IBOutlet weak var varianzaLabel: UILabel!
    
    @IBOutlet weak var pingLabel: UILabel!
    
    @IBOutlet weak var stimaDownloadLabel: UILabel!
    @IBOutlet weak var stimaUploadLabel: UILabel!
    
    @IBOutlet weak var berecDownloadLabel: UILabel!
    @IBOutlet weak var berecUploadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pingTest = PingTest.init(view: self)
    }
    
}
extension ViewController{
    //Avvio in sequenza
    @IBAction func tapMainTest(_ sender: UIButton) {
        self.test = Test.init(view: self, stringUrl: self.stringUrl, sequentialTest: true)
        test!.doEstimatedDownloadTest(seconds: 4)
    }
    
    //
    @IBAction func tapStimaDownload(_ sender: UIButton) {
        self.test = Test.init(view: self, stringUrl: self.stringUrl,sequentialTest: false)
        test!.doEstimatedDownloadTest(seconds: 4)
    }
    
    @IBAction func tapStimaUpload(_ sender: UIButton) {
        self.test = Test.init(view: self, stringUrl: self.stringUrl,sequentialTest: false)
        self.test!.doEstimatedUploadTest(seconds: 4)
    }
    
    @IBAction func tapBerecDownload(_ sender: UIButton) {
        self.test = Test.init(view: self, stringUrl: self.stringUrl,sequentialTest: false)
        self.test!.doDownloadBerecTest()
    }
    
    @IBAction func tapBerecUpload(_ sender: UIButton) {
        self.test = Test.init(view: self, stringUrl: self.stringUrl,sequentialTest: false)
        self.test!.doUploadBerecTest()
    }
    
    @IBAction func tapPing(_ sender: UIButton){
        self.pingTest!.makePing(url: self.urlPing)
    }
    
    @IBAction func tapMultiplePing(_ sender: UIButton){
        self.pingTest!.makePing(url: self.urlPing, ripeti: 10)
    }
}
extension ViewController{
    //
    func showEstimatedDownloadResult(estimatedSpeed: Double){
        DispatchQueue.main.async {
            self.stimaDownloadLabel.text = "Stima Download: \(estimatedSpeed)"
        }
    }
    
    func showEstimatedUploadResult(estimatedSpeed: Double){
        DispatchQueue.main.async {
            self.stimaUploadLabel.text = "Stima Upload: \(estimatedSpeed)"
        }
    }
    
    func showBerecDownloadResult(estimatedSpeed: Double){
        DispatchQueue.main.async {
            self.berecDownloadLabel.text = "BEREC Download: \(estimatedSpeed)"
        }
    }
    
    func showBerecUploadResult(estimatedSpeed: Double){
        DispatchQueue.main.async {
            self.berecUploadLabel.text = "BEREC Upload: \(estimatedSpeed)"
        }
    }
    
    func showResultPingTest(delay: String){
        //print("delay : \(delay)")
        DispatchQueue.main.async {
            self.pingLabel.text = "Ping :\(delay)"
        }
    }
    
    func showPingStat(media:Double,varianza:Double){
        DispatchQueue.main.async{
            self.mediaLabel.text = "Media: \(media)"
            self.varianzaLabel.text = "Varianza: \(varianza)"
        }
    }
}


//aggiornamento dei progressi
extension ViewController{
    //download
    func updateProgressDownload(download: Download){
        switch download.id{
        case 1:
            DispatchQueue.main.async {
                self.label1.text = "\(Int(download.progress!*100))"
            }
            return
        case 2:
            DispatchQueue.main.async {
                self.label2.text = "\(Int(download.progress!*100))"
            }
            return
        case 3:
            DispatchQueue.main.async {
                self.label3.text = "\(Int(download.progress!*100))"
            }
            return
        default:
            print("nessun download associato")
            return
        }
    }
    
    //upload
    func updateProgressUpload(upload: Upload){
        switch upload.id{
        case 1:
            DispatchQueue.main.async {
                self.label1.text = "\(Int(upload.progress!*100))"
            }
            return
        case 2:
            DispatchQueue.main.async {
                self.label2.text = "\(Int(upload.progress!*100))"
            }
            return
        case 3:
            DispatchQueue.main.async {
                self.label3.text = "\(Int(upload.progress!*100))"
            }
            return
        default:
            print("nessun download associato")
            return
        }
    }
}

