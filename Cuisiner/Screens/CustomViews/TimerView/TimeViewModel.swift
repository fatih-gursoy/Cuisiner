//
//  TimeViewModel.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 25.09.2022.
//

import SwiftUI

class TimeViewModel: ObservableObject {
    
    private var initialTimeMin: Int {
        didSet { timeRemaining = initialTimeMin * 60 }
    }
    
    @Published var timeRemaining: Int = 0
    @Published var isTimerRunning: Bool = false
    @Published var isStartTapped: Bool = false
    @Published var pickerHour: Int = 0 { didSet { updateTimer() } }
    @Published var pickerMinute: Int = 0 { didSet { updateTimer() } }
    
    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var circleProgress: CGFloat {
        return CGFloat(timeRemaining) / CGFloat(initialTimeMin * 60)
    }
    
    init(initialTimeMin: Int) {
        self.initialTimeMin = initialTimeMin
        pickerHour = initialTimeMin / 60
        pickerMinute = initialTimeMin % 60
    }
    
    func updateTimer() {
        initialTimeMin = (pickerHour * 60) + pickerMinute
        resetTimer()
    }
    
    var timeString: String {
        let hour = timeRemaining / 3600
        let minute = timeRemaining / 60 % 60
        let second = timeRemaining % 60
        return NSString(format: "%0.2d:%0.2d:%0.2d", hour, minute, second) as String
    }
    
    func runTimer() {
        if timeRemaining > 0 && isTimerRunning {
            isStartTapped = true
            timeRemaining -= 1
        } else if timeRemaining == 0 {
            resetTimer()
        } else {
            isTimerRunning = false
        }
    }
    
    func resetTimer() {
        isStartTapped = false
        isTimerRunning = false
        timeRemaining = initialTimeMin * 60
    }
    
    
}
