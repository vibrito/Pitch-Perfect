//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Vinicius Brito on 8/23/15.
//  Copyright (c) 2015 Vinicius. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate
{
    @IBOutlet weak var labelRecordingInProgress: UILabel!
    @IBOutlet weak var labelTapToRecord: UILabel!
    @IBOutlet weak var buttonStop: UIButton!
    @IBOutlet weak var buttonRecord: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        buttonStop.hidden = true
        buttonRecord.enabled = true
        labelTapToRecord.hidden = false
    }

    @IBAction func actionRecordAudio(sender: UIButton)
    {
        println("in recordAudio")
        labelRecordingInProgress.hidden = false
        labelTapToRecord.hidden = true
        buttonStop.hidden = false
        buttonRecord.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let recordingName = "my_audio.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func actionStopRecord(sender: UIButton)
    {
        labelRecordingInProgress.hidden = true
        buttonStop.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if(flag)
        {
            recordedAudio = RecordedAudio(url: recorder.url, string: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else
        {
            println("Recording was not successful")
            buttonRecord.enabled = true
            buttonStop.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

