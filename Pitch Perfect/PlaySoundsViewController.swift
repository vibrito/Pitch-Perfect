//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Vinicius Brito on 8/26/15.
//  Copyright (c) 2015 Vinicius. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController
{
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    @IBAction func actionPlaySlowAudio(sender: UIButton)
    {
        playAudio(0.5)
    }
    
    @IBAction func actionPlayFastAudio(sender: UIButton)
    {
        playAudio(1.5)
    }
    
    @IBAction func actionChipmunkAudio(sender: UIButton)
    {
        playAudioWithViariablePitch(1000)
    }

    @IBAction func actionDarthVaderAudio(sender: AnyObject)
    {
        playAudioWithViariablePitch(-1000)
    }
    
    @IBAction func actionStop(sender: UIButton)
    {
        stopAndResetAll()
    }
    
    func playAudio (speed: Float)
    {
        stopAndResetAll()
        
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func playAudioWithViariablePitch (pitch: Float)
    {
        stopAndResetAll()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func stopAndResetAll()
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
}
