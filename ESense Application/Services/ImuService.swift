//
//  imuService.swift
//  ESense Application
//
//  Created by Wei Wei on 2/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import Foundation

class ImuService:ESenseSensorListener, ESenseEventListener {
    let sr: UInt8 = 100
    let defaultConfig = ESenseConfig(
        accRange: ESenseConfig.AccRange.G_4,
        gyroRange: ESenseConfig.GyroRange.DEG_1000,
        accLPF: ESenseConfig.AccLPF.DISABLED,
        gyroLPF: ESenseConfig.GyroLPF.DISABLED)
    
    var fileName = "nil"
    var manager: ESenseManager
    var eventList = [ESenseEvent]()
    
    init(manager: ESenseManager){
        self.manager = manager
        // set the default config
        while (!self.manager.setSensorConfig(self.defaultConfig)){
            print(#function, "setting default config failed, trying again")
            sleep(1)
        }
        // set the intervals
        let minConn = 7, maxConn = 27
        while (!self.manager.setAdvertisementAndConnectiontInterval(100, 150, minConn, maxConn)){
            print(#function, "setting intervals failed, trying again")
            sleep(1)
        }
        // set the event listener
        while (!self.manager.registerEventListener(self)){
            print(#function, "registering event listener failed, trying again")
            sleep(1)
        }
        // read the intervals
        while (!self.manager.getAdvertisementAndConnectionInterval()){
            print(#function, "reading intervals failed, trying again")
            sleep(1)
        }
    }
    
    // process the IMU data received
    func onSensorChanged(_ evt: ESenseEvent) {
//        print(#function)
        self.eventList.append(evt)
//        let acc = evt.convertAccToG(config: self.defaultConfig)
//        let gyro = evt.convertGyroToDegPerSecond(config: self.defaultConfig)
//        print(#function, acc)
//        print(#function, gyro)
    }
    
    func onBatteryRead(_ voltage: Double) {
        print(#function)
    }
    
    func onButtonEventChanged(_ pressed: Bool) {
        print(#function)
    }
    
    func onAdvertisementAndConnectionIntervalRead(_ minAdvertisementInterval: Int, _ maxAdvertisementInterval: Int, _ minConnectionInterval: Int, _ maxConnectionInterval: Int) {
        print(#function, minAdvertisementInterval, maxAdvertisementInterval, minConnectionInterval, maxConnectionInterval)
    }
    
    func onDeviceNameRead(_ deviceName: String) {
        print(#function)
    }
    
    func onSensorConfigRead(_ config: ESenseConfig) {
        print(#function)
    }
    
    func onAccelerometerOffsetRead(_ offsetX: Int, _ offsetY: Int, _ offsetZ: Int) {
        print(#function)
    }
    
    // start collecting IMU data
    func start(fileId: String){
        print(#function, fileId)
        self.fileName = "\(fileId).csv"
        if (self.manager.registerSensorListener(self, hz: self.sr) != SamplingStatus.STARTED){
            fatalError("registerSensorListener failed")
        }
    }
    
    // stop collection IMU data
    func stop(){
        print(#function)
        self.manager.unregisterSensorListener()
    }
    
    //  write IMU data to file
    func write(){
        print(#function)
        
        // set the file name
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let filePath = documentDirectory.appendingPathComponent(self.fileName).path
        print(#function, "write to file \(filePath)")
        
        // save the IMU data to a string
        var content = "timestamp, acc0, acc1, acc2, gyro0, gyro1, gyro2\n"
        for event in self.eventList {
            // format the timestamp to be more readable
            let timestamp = event.getTimestamp()
            let timestampStr = "\(timestamp)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd[HH:mm:ss.SSS]"
            let date = Date(timeIntervalSince1970: Double(timestamp) / 1000)
            let formattedTimeStampStr = dateFormatter.string(from: date)
            // convert the IMU data to string
            let acc = event.convertAccToG(config: self.defaultConfig)
            let gyro = event.convertGyroToDegPerSecond(config: self.defaultConfig)
            let dataStr = "\(acc[0]),\(acc[1]),\(acc[2]),\(gyro[0]),\(gyro[1]),\(gyro[2])"
            
            // append the string to content
            content += "\(timestampStr),\(dataStr),\(formattedTimeStampStr)\n"
        }
        
        // write the string to file
        do {
            try content.write(toFile: filePath, atomically: false, encoding: .utf8)
        } catch {
            print(#function, error)
        }
            
    
    }
}
