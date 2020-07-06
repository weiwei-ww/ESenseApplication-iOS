//
//  ConnectSerivce.swift
//  ESense Application
//
//  Created by Wei Wei on 2/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import Foundation

class ConnectService:ESenseConnectionListener {
    var connectViewController: ConnectViewController
    var deviceName: String
    var manager: ESenseManager!
    
//    let defaultConfig = ESenseConfig(
//        accRange: ESenseConfig.AccRange.G_4,
//        gyroRange: ESenseConfig.GyroRange.DEG_1000,
//        accLPF: ESenseConfig.AccLPF.DISABLED,
//        gyroLPF: ESenseConfig.GyroLPF.DISABLED)
    
    init(connectViewController: ConnectViewController, deviceName: String){
        self.connectViewController = connectViewController
        self.deviceName = deviceName
        self.manager = ESenseManager(deviceName: deviceName, listener: self)
    }
    
    func onDeviceFound(_ manager: ESenseManager) {
        print(#function)
        self.connectViewController.setConnectState(connectState: .found)
    }
    
    func onDeviceNotFound(_ manager: ESenseManager) {
        print(#function)
        self.connectViewController.setConnectState(connectState: .notfound)
    }
    
    func onConnected(_ manager: ESenseManager) {
        print(#function)
        // wait the eSense to be ready
        self.manager.setDeviceReadyHandler {_ in
            self.manager.removeDeviceReadyHandler()
            self.connectViewController.setConnectState(connectState: .connected)
        }
    }
    
    func onDisconnected(_ manager: ESenseManager) {
        print(#function)
        self.connectViewController.setConnectState(connectState: .disconnected)
    }
    
    // connect to eSense
    func connect() {
        self.connectViewController.setConnectState(connectState: .connecting)
        let timeout = 1000
        let connectResult = self.manager.connect(timeout: timeout)
        print(#function, "connectResult=\(connectResult)")
    }
    
}
