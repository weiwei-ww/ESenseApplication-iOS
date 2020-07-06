//
//  DataCollectionViewController.swift
//  ESense Application
//
//  Created by Wei Wei on 2/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import UIKit

class DataCollectionViewController:UIViewController, UITextFieldDelegate {
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var imuStateLabel: UILabel!
    @IBOutlet weak var audioStatusLabel: UILabel!
    @IBOutlet weak var fileNameTextField: UITextField!
    
    var imuService: ImuService!
    var audioService: AudioService!
    var deviceName: String = "eSense-0000"
    var manager: ESenseManager!
    
    var imuState: ImuState = .stopped
    var audioState: AudioState = .stopped
    
    enum ImuState: String {
        case collecting = "collecting data"
        case writing = "writing data"
        case stopped = "stopped"
    }
    
    enum AudioState: String {
        case recording = "recording"
        case stopped = "stopped"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        print(#function, "deviceName = \(self.deviceName)")
        
        self.deviceNameLabel.text = deviceName
        self.fileNameTextField.delegate = self
        
        self.imuService = ImuService(manager: self.manager)
        self.audioService = AudioService()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.fileNameTextField.resignFirstResponder()
        return true
    }
    
    @IBAction func startPressed(_ sender: Any) {
        print(#function)
        // set the file name using the current timestamp
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        var fileId = dateFormatter.string(from: date)
        if self.fileNameTextField.text != "" {
            fileId += " - \(self.fileNameTextField.text!)"
        }
        
        // start IMU and audio recording
        self.startImu(fileId: fileId)
        self.startAudio(fileId: fileId)
    }
    
    @IBAction func stopPressed(_ sender: Any) {
        print(#function)
        self.stopImu()
        self.stopAudio()
    }
    
    // set the imuState and the label text
    func setImuState(imuState: ImuState){
        print(#function, imuState)
        self.imuState = imuState
        self.imuStateLabel.text = imuState.rawValue
    }
    
    func startImu(fileId: String){
        print(#function)
        switch self.imuState {
        case .collecting:
            print(#function, "already collecting IMU data")
        case .writing:
            print(#function, "still writing IMU data")
        case .stopped:
            self.setImuState(imuState: .collecting)
            self.imuService.start(fileId: fileId)
        }
    }
    
    func stopImu(){
        print(#function)
        switch self.imuState {
        case .collecting:
            self.setImuState(imuState: .writing)
            // stop collecting IMU data
            self.imuService.stop()
            // write IMU data to file
            self.imuService.write()
            self.setImuState(imuState: .stopped)
        case .writing:
            print(#function, "still writing IMU data")
        case .stopped:
            print(#function, "IMU already stopped")
        }
    }
    
    // set the audioState and the label text
    func setAudioState(audioState: AudioState){
        print(#function, audioState)
        self.audioState = audioState
        self.audioStatusLabel.text = audioState.rawValue
    }
    
    func startAudio(fileId: String){
        print(#function)
        switch self.audioState {
        case .recording:
            print(#function, "audio recording already started")
        case .stopped:
            self.setAudioState(audioState: .recording)
            self.audioService.start(fileId: fileId)
        }
    }
    
    func stopAudio(){
        print(#function)
        switch self.audioState {
        case .recording:
            self.audioService.stop()
            self.setAudioState(audioState: .stopped)
        case .stopped:
            print(#function, "audio recording already stopped")
        }
    }
}
