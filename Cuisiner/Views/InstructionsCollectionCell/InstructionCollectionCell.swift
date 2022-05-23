//
//  InstructionCollectionCell.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 17.05.2022.
//

import UIKit
import Lottie

class InstructionCollectionCell: UICollectionViewCell {

    static let identifier = String(describing: InstructionCollectionCell.self)
    
    @IBOutlet private weak var bottomView: UIView!
    @IBOutlet private weak var instructionText: UITextView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var startButton: UIButton!
    
    private var animationView: AnimationView?
    private var timer = Timer()
    private var totalSecond = 0
    private var runTime = 0
    private var isTimerRunning = false
    
    func configure(instruction: Instruction?) {
        
        guard let instruction = instruction else { return }
        instructionText.text = instruction.text
                
        if let totalMinute = instruction.time {
            totalSecond = totalMinute * 60
            runTime = totalSecond
        }
        
        configureTimer(totalSec: totalSecond)
        configureAnimation()

    }
    
    func configureAnimation() {
        
        animationView = .init(name: "cooking")
        animationView?.loopMode = .loop
        animationView?.contentMode = .scaleAspectFit
        animationView?.animationSpeed = 0.5
        bottomView.addSubview(animationView!)
        
    }
    
    func configureTimer(totalSec: Int) {
                
        let hour = totalSec / 3600
        let min = totalSec / 60 % 60
        let second = totalSec % 60
        
        let timeText = NSString(format: "%0.2d:%0.2d:%0.2d", hour, min, second)
        self.timerLabel.text = String(describing: timeText)
        
    }
    
    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        isTimerRunning = true
    }
    
    @objc func updateTime() {
                
        if runTime > 0 {
            runTime -= 1
            configureTimer(totalSec: runTime)
        } else {  
            timerReset()
        }
    }
    
    
    @IBAction func startClicked(_ sender: Any) {
                
        if isTimerRunning == false {
            self.runTimer()
            startButton.setTitle("Pause", for: .normal)
            animationView?.play()

        } else {
            timer.invalidate()
            isTimerRunning = false
            startButton.setTitle("Resume", for: .normal)
            animationView?.pause()
        }
    }
    
    @IBAction func resetClicked(_ sender: Any) {
        timerReset()
    }
    
    func timerReset() {
        
        timer.invalidate()
        isTimerRunning = false
        startButton.setTitle("Start", for: .normal)
        animationView?.stop()
        runTime = totalSecond
        configureTimer(totalSec: runTime)
    }
    
    
}
