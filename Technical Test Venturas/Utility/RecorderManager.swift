//
//  RecordManager.swift
//  Technical Test Venturas
//
//  Created by Faizul Karim on 8/11/21.
//

import UIKit
import AVFoundation

struct soundTitle {
   static var title : String = ""
}
class RecorderManager: NSObject, AVAudioRecorderDelegate,AVAudioPlayerDelegate {

    static let shared : RecorderManager = RecorderManager()
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    var audioFileName : URL?
  
    //Mark :- Permission
    func Permission(){
        audioFileName =  getDocumentsDirectory().appendingPathComponent("\(soundTitle.title).m4a")
        recordingSession = AVAudioSession.sharedInstance()
        if (recordingSession.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
                AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                    if granted {
                        print("granted")
                        do {
                            try self.recordingSession.setCategory(AVAudioSession.Category.playAndRecord)
                            try self.recordingSession.setActive(true)
                            try self.recordingSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                            self.startRecording()
                        }
                        catch {
                            print("Couldn't set Audio session category")
                        }
                    } else{
                        print("not granted")
                    }
                })
            }
    }

    //MARK :- Recording
    func startRecording() {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            self.audioRecorder = try AVAudioRecorder(url: audioFileName!, settings: settings)
            self.audioRecorder.delegate = self
            self.audioRecorder.record()
        } catch {
            self.finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        self.audioRecorder.stop()
        self.audioRecorder = nil

        if success {
            print("recorded successfully.")
        } else {
            print("error")
        }
    }
    func recordTapped(){
        if audioRecorder == nil {
            self.Permission()
        } else {
            finishRecording(success: true)
        }
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    //MARK:- Player manager
 private func prepare_play(recordString : String){
         audioFileName =   getDocumentsDirectory().appendingPathComponent("\(recordString).m4a")
            do
             {
                 self.audioPlayer = try AVAudioPlayer(contentsOf: audioFileName!)
                 self.audioPlayer.delegate = self
                 self.audioPlayer.prepareToPlay()
            }
            catch{
                print("Error")
            }
    }
    func play(recordString : String){
        if FileManager.default.fileExists(atPath: getDocumentsDirectory().path)
        {
            self.prepare_play(recordString: recordString)
            self.audioPlayer.play()
            print("Playing")
            
        }
        else
        {
           print("file missing")
        }
    }
    func stopPlay(){
        self.audioPlayer.stop()
    }
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool)
    {
      print("Audio ended")
    }
    
}
