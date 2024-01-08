//
//  ViewController.swift
//  audioTest
//

import UIKit
import AVFoundation

class ViewController:  UIViewController {

    @IBOutlet var txt_Data: UITextView!
    @IBOutlet var vw_frame: UIView!
    @IBOutlet var btn_Song: UIButton!
    @IBOutlet var btn_Speak: UIButton!
    
    // Set up the text-to-speech synthesizer
    let synthesizer = AVSpeechSynthesizer()
   
    // Play music from storage
    var audioPlayer1: AVAudioPlayer?
    var audioPlayer2: AVAudioPlayer?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vw_frame.layer.cornerRadius = 15
        vw_frame.layer.shadowColor = UIColor.black.cgColor
        vw_frame.layer.shadowOpacity = 0.5
        vw_frame.layer.shadowOffset = CGSize(width: 0, height: 2)
        vw_frame.layer.shadowRadius = 5
        vw_frame.layer.masksToBounds = false
        
        btn_Song.layer.cornerRadius = 15
        btn_Speak.layer.cornerRadius = 15
        
        // Hide Keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        view.addGestureRecognizer(tap)

       // Add Music to Audio Object
        if let assetURL1 = Bundle.main.url(forResource: "song1", withExtension: "mp3"),
           let assetURL2 = Bundle.main.url(forResource: "song2", withExtension: "mp3") {
            do {
                audioPlayer1 = try AVAudioPlayer(contentsOf: assetURL1)
                audioPlayer2 = try AVAudioPlayer(contentsOf: assetURL2)
            } catch {
                print("Error loading audio files: \(error.localizedDescription)")
            }
        } else {
            print("One or both audio files not found in the app's assets.")
        }

    }
    

    @IBAction func btn_song(_ sender: UIButton) {
        print(#function)
        
        if audioPlayer1!.isPlaying {   // Stop Song 1
            
            audioPlayer1!.stop()
        }else if audioPlayer2!.isPlaying {  // Stop Song 2
            
            audioPlayer2!.stop()
        } else {
            // Ready
            if let player1 = audioPlayer1, let player2 = audioPlayer2 {
               // Setup AVAudioPlayer

                play_song(p1: player1, p2: player2)
                
            } else {
                print("One or both audio players are nil, cannot play.")
            }

        }
 
    }
    
    
    func play_song(p1: AVAudioPlayer, p2: AVAudioPlayer) {
    
        // Run music in backfround
        DispatchQueue.global().async { // Play Song 1
            // This a Fast Song
            p2.prepareToPlay()
            p2.play()
        }
     
        // Run music in backfround
        DispatchQueue.global().async { // Play Song 2
            // This is Slow Song
            p1.prepareToPlay()
            p1.play()
        }
        
    }
    
    
    @IBAction func btn_speak(_ sender: UIButton) {
        
        if synthesizer.isSpeaking {
            // Stop the Speech
            synthesizer.stopSpeaking(at: .immediate)
            }
        else
        {
            // Set up the audio session
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
            } catch {
                print("Failed to set up audio session: \(error)")
            }

            // Get the text to be synthesized from a UILabel
            let text = txt_Data.text!

            // Set up the text-to-speech request
            let speechUtterance = AVSpeechUtterance(string: text)
            
            speechUtterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
            speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")

            // Play the synthesized audio directly
            synthesizer.speak(speechUtterance)
        }
 
    }

}

