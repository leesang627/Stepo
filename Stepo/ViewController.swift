//
//  ViewController.swift
//  Stepo
//
//  Created by 상욱 이 on 2016. 4. 11..
//  Copyright © 2016년 POSTECH Cite. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion

class ViewController: UIViewController {
    @IBOutlet var playLuckyButton: UIButton!
    @IBOutlet var stopLuckyButton: UIButton!
    @IBOutlet var playUptownButton: UIButton!
    @IBOutlet var stopUptownButton: UIButton!
    
    @IBOutlet var stepsLabel: UILabel!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var spmLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var bpmLabel: UILabel!

    var audioPlayer = AVAudioPlayer()
    var pedometer = CMPedometer()
    var timer = NSTimer()
    
    var counter = 0
    var spmInterval = 15
    var nowSteps = 0
    var oldSteps = 0
    var spm = 0
    var musicBPM = 120
    
    override func viewDidLoad() {
        super.viewDidLoad()
        musicGet("Lucky Strike")
        
        stopLuckyButton.enabled = false
        stopUptownButton.enabled = false
        
        pedometer.startPedometerUpdatesFromDate(NSDate()) {
            (data, error) in
            if error != nil {
                print("There was an error obtaining pedometer data: \(error)")
            } else {
                self.nowSteps = data!.numberOfSteps as Int
                dispatch_async(dispatch_get_main_queue()) {
                    self.stepsLabel.text = "\(self.nowSteps)"
                }
            }
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    func update() {
        if (counter%spmInterval==0){
            spm = (nowSteps-oldSteps)*(60/spmInterval)
            oldSteps = nowSteps
        }
        spmLabel.text="\(spm)"
        timerLabel.text="\(counter)"
        bpmLabel.text="\(musicBPM)"
        rateLabel.text="\(spmToRate(spm, bpm: musicBPM))"
        audioPlayer.rate = spmToRate(spm, bpm: musicBPM)
        counter=counter+1
    }
    
    func spmToRate(spm:Int ,bpm: Int) -> Float{
        let unit=Float(bpm)/11
        return 0.5+0.1*floor(Float(spm)/(2*unit))
    }

    @IBAction func playLucky(sender: AnyObject) {
        musicBPM = 144
        musicGet("Lucky Strike")
        musicPlay()
        playLuckyButton.enabled = false
        stopLuckyButton.enabled = true
    }
    @IBAction func stopLucky(sender: AnyObject) {
        musicStop()
        playLuckyButton.enabled = true
        stopLuckyButton.enabled = false
    }
    @IBAction func playUptown(sender: AnyObject) {
        musicBPM = 116
        musicGet("Uptown Funk")
        musicPlay()
        playLuckyButton.enabled = false
        stopLuckyButton.enabled = true
    }
    @IBAction func stopUptown(sender: AnyObject) {
        musicStop()
        playLuckyButton.enabled = true
        stopLuckyButton.enabled = false
    }
    
    func musicGet(soundName: String)
    {
        let musicName = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(soundName, ofType: "mp3")!)
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer = try AVAudioPlayer(contentsOfURL: musicName)
            audioPlayer.enableRate=true
        }catch {
            print("Error getting the audio file")
        }
    }
    
    func musicPlay ()
    {
        audioPlayer.play()
    }
    
    func musicStop ()
    {
        audioPlayer.stop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

