//
//  ConnectViewController.swift
//  ESense Application
//
//  Created by Wei Wei on 1/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController {
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var connectStatusLabel: UILabel!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var nextStepButton: UIButton!
    
    var deviceName = ""
    var connectService: ConnectService!
    
    enum connectState: String{
        case connecting = "connecting"
        case found = "device found, connecting"
        case notfound = "device not found, try again"
        case connected = "connected"
        case disconnected = "disconnected"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(#function, "deviceName = \(self.deviceName)")
        deviceNameLabel.text = self.deviceName
        
        self.connectService = ConnectService(connectViewController: self, deviceName: self.deviceName)
    }
    
    @IBAction func connectPressed(_ sender: Any) {
        print(#function)
        self.connectService.connect()
    }
    
    @IBAction func nextStepPressed(_ sender: Any) {
        print(#function)
        self.performSegue(withIdentifier: "connect2data", sender: self)
    }
    
    // pass the device name and the ESenseManager object
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "connect2data" {
            let dstViewController = segue.destination as! DataCollectionViewController
            dstViewController.deviceName = self.deviceName
            dstViewController.manager = self.connectService.manager
        }
    }
    
    // set the connectState, the label text and enable/disable the buttons
    func setConnectState(connectState: connectState){
        print(#function, connectState)
        // set the label text
        self.connectStatusLabel.text = connectState.rawValue
        // enable/disable the buttons
        switch connectState {
        case .connecting:
            connectButton.isEnabled = false
        case .connected:
            nextStepButton.isEnabled = true
        case .found:
            break
        case .notfound:
            connectButton.isEnabled = true
        case .disconnected:
            connectButton.isEnabled = true
        }
    }
    
    
}
