//
//  MapWithAudioController.swift
//  Technical Test Venturas
//
//  Created by Faizul Karim on 7/11/21.
//

import UIKit
import GoogleMaps
import UserNotifications

class MapWithAudioController: UIViewController,GMSMapViewDelegate {
    //MARK:- Outlet
    @IBOutlet weak var recordingTime: UILabel!
    @IBOutlet weak var myView: GMSMapView!
    @IBOutlet weak var recordingBackgroundView: UIView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var SoundEditView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleName: UITextField!
    @IBOutlet weak var playPause: UIButton!
    @IBOutlet weak var soundSlide: UISlider!
    @IBOutlet weak var soundName: UILabel!
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var btnRecord: UIButton!
    
    //MARK:- Class Variable
    var timer : Timer?
    var counter = 0
    var markedLocation : CLLocationCoordinate2D?
    override func viewDidLoad() {
        super.viewDidLoad()
        initGoogleMap()
        setupView()
        // Do any additional setup after loading the view.
    }
    //MARK:- Memory Management Method
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("Deinit MapWithAudioController")
    }

    //MARK:- Custom Method
    func recordAlert(){
        let alert = UIAlertController(title: "Voice Record", message: "Please add a voice guide to Compleate add marker", preferredStyle: .alert)
             let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
                 self.record(self)
             })
             alert.addAction(ok)
             let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
             })
             alert.addAction(cancel)
             DispatchQueue.main.async(execute: {
                self.present(alert, animated: true)
        })
        
    }
    

    func initGoogleMap(){
        self.myView.delegate = self
        self.myView.isMyLocationEnabled = true
        let location = GMSCameraPosition.camera(withLatitude: LocationManager.shared.getUserLocation().latitude, longitude: LocationManager.shared.getUserLocation().longitude, zoom: Float(16))
        self.myView.animate(to: location)
    }
    
    func setupView(){
        self.btnRecord.roundCornersToBtn(corners: .allCorners, radius: 40)
        self.recordingBackgroundView.isHidden = true
        self.SoundEditView.isHidden = true
        self.playerView.isHidden = true
        let swipeDown: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(viewSwipeDown))
        swipeDown.direction = .down
        self.playerView.addGestureRecognizer(swipeDown)
        
       
    }
    
    @objc func viewSwipeDown(){
        self.playerView.animHide()
        RecorderManager.shared.audioPlayer.pause()
   }

    func markMyLocation(lat : Double , lng : Double, Title : String){
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        print("location1: \(location)")
        let marker = GMSMarker()
        marker.position = location
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.title = Title
        marker.map = myView
    }


    
    func recordSound() {
        if RecorderManager.shared.audioRecorder == nil {
            let randomInt = Int.random(in: 0...1000)
            soundTitle.title = "Sound\(randomInt)"
            RecorderManager.shared.Permission()
            self.recordingBackgroundView.animShow()
            self.myView.isUserInteractionEnabled = false
            self.btnRecord.setTitle("Stop", for: .normal)
            self.recordingTime.textColor = UIColor.red
            self.timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(prozessTimer), userInfo: nil, repeats: true)
        } else {
            RecorderManager.shared.finishRecording(success: true)
            self.btnRecord.setTitle("Record", for: .normal)
            self.timer?.invalidate()
            self.timer = nil
            self.counter = 0
            self.recordingTime.text = "00:00:00"
            self.ManageSoundEditView()
        }
    }
    
    @objc func prozessTimer() {
        counter += 1
        let totalTime = GFunction.shared.timeFormatted(counter)
        self.recordingTime.text = totalTime
        self.time.text = totalTime
    }
    
    func ManageSoundEditView(){
        self.recordingBackgroundView.isHidden = true
        self.SoundEditView.animShow()
        self.titleName.text = soundTitle.title
    }
    
    //MARK:- Action Method
    @IBAction func record(_ sender: Any) {
        self.recordSound()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.SoundEditView.animShow()
        self.myView.isUserInteractionEnabled = true
    }
    
    @IBAction func Save(_ sender: Any) {
        if soundTitle.title != self.titleName.text! {
            GFunction.shared.soundRename(currentName: soundTitle.title, newName: self.titleName.text!)
        }
        self.markMyLocation(lat: markedLocation!.latitude, lng: markedLocation!.longitude, Title: self.titleName.text!)
        self.SoundEditView.isHidden = true
        self.myView.isUserInteractionEnabled = true
        LocalNotification.shared.notificationPermission()
    }
    
    @IBAction func playPauseAction(_ sender: Any) {
        if RecorderManager.shared.audioPlayer.isPlaying {
            RecorderManager.shared.audioPlayer.pause()
            playPause.setImage(UIImage(named: "play"), for: .normal)
        }else{
            RecorderManager.shared.audioPlayer.play()
            playPause.setImage(UIImage(named: "pause"), for: .normal)
        }
        
    }
    
    @IBAction func ChangeVolume(_ sender: Any) {
        RecorderManager.shared.audioPlayer.volume = soundSlide.value
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        RecorderManager.shared.play(recordString: marker.title!)
        self.soundName.text = marker.title
        self.soundSlide.value = RecorderManager.shared.audioPlayer.volume
        self.playerView.animShow()
        print(marker.title!)
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
      print("You tapped at \(coordinate.latitude), \(coordinate.longitude)")
       markedLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
        recordAlert()
        self.playerView.animHide()
    }

}

