//
//  ViewController.swift
//  ESense Application
//
//  Created by Wei Wei on 1/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import UIKit

class ScanViewController: UIViewController {
    @IBOutlet weak var scanStatusLabel: UILabel!
    @IBOutlet weak var startScanButton: UIButton!
    @IBOutlet weak var stopScanButton: UIButton!
    @IBOutlet weak var nextStepButton: UIButton!
    
    var scanService: ScanService!
    var deviceName: String = ""
    var scanState: ScanState = .stopped
    
    enum ScanState: String{
        case scanning = "scanning"
        case stopped = "no device found"
        case found = "device found"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.scanService = ScanService(scanViewController: self)
    }

    @IBAction func startScanPressed(_ sender: Any) {
        print(#function)
        switch self.scanState {
        case .scanning:
            print(#function, "scanning already started")
        case .stopped:
            print(#function, "start scanning")
            // start scanning
            self.setScanState(scanState: .scanning)
            self.scanService.startScan()
        case .found:
            print(#function, "eSense already found")
        }
    }
    
    @IBAction func stopScanPressed(_ sender: Any) {
        print(#function)
        switch self.scanState {
        case .scanning:
            // stop scanning
            self.scanService.stopScan()
            self.setScanState(scanState: .stopped)
        case .stopped:
            print(#function, "scanning already stopped")
        case .found:
            print(#function, "eSense already found")
        }
    }
    
    @IBAction func nextStepPressed(_ sender: Any) {
        print(#function)
        // jump to the next step
        self.performSegue(withIdentifier: "scan2connect", sender: self)
    }
    
    // pass the device name
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "scan2connect" {
            let dstViewController = segue.destination as! ConnectViewController
            dstViewController.deviceName = self.deviceName
        }
    }
    
    // called when an eSense device is found
    func deviceFound(name: String){
        print(#function, "\(name)")
        self.deviceName = name
        self.scanStatusLabel.text = "\(name) found"
        self.setScanState(scanState: .found)
    }
    
    // set the scanState, the label text and enable/disable the buttons
    func setScanState(scanState: ScanState){
        print(#function, scanState)
        self.scanState = scanState
        switch scanState {
        case .scanning:
            self.scanStatusLabel.text = scanState.rawValue
        case .stopped:
            self.scanStatusLabel.text = scanState.rawValue
        case .found:
            self.startScanButton.isEnabled = false
            self.stopScanButton.isEnabled = false
            self.nextStepButton.isEnabled = true
        }
    }
}
