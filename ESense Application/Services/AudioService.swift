//
//  AudioService.swift
//  ESense Application
//
//  Created by Wei Wei on 3/7/20.
//  Copyright © 2020 Wei Wei. All rights reserved.
//

import Foundation
import AVFoundation

class AudioService {
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    
    init(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default,options:.allowBluetooth)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { granted in
                if granted {
                    print(#function, "audio recording persmission granted")
                } else {
                    print(#function, "audio recording permission denied")
                    fatalError("Audio recording permission denied!")
                }
            }
        } catch {
            print(#function, error)
        }
    }
    
    func start(fileId: String){
        print(#function)
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileUrl = documentDirectory.appendingPathComponent("\(fileId).m4a")
        print(#function, "audio recording will be saved to \(fileUrl.path)")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 8000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
            self.audioRecorder.record()
        } catch {
            print(#function, error)
        }
    }
    
    func stop(){
        print(#function)
        self.audioRecorder.stop()
    }
}
