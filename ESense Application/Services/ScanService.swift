//
//  ScanService.swift
//  ESense Application
//
//  Created by Wei Wei on 1/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import CoreBluetooth

class ScanService: NSObject, CBCentralManagerDelegate {
    var scanViewController: ScanViewController!
    // the CBCentralManager object in charge of BLE scanning
    var centralManager : CBCentralManager!
    
    override init(){
        super.init()
    }
    
    required init(scanViewController: ScanViewController){
        self.scanViewController = scanViewController
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    // called when the Bluetooth state is updated
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print(#function, "Bluetooth is On")
        } else {
            print(#function, "Bluetooth is not active")
        }
    }
    
    // called when a BLE device is found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let name = peripheral.name ?? "nil"
        
        // tell if the device found is the eSense
        if name.hasPrefix("eSense-") {
            print(#function, "\(name) found, stop scanning")
            centralManager.stopScan()
            self.scanViewController.deviceFound(name: name)
        }
        else{
            print(#function, "\(name) found, not eSense and keep scanning")
        }
    }
    
    func startScan(){
        print(#function, "start scanning")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScan(){
        print(#function, "stop scanning")
        centralManager.stopScan()
    }
}
