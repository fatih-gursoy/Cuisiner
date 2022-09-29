//
//  CustomButton.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 28.09.2022.
//

import SwiftUI

struct TimerButton: View {
         
    enum Style {
        case start
        case pause
        case resume
        case reset

        var title: String {
            switch self {
            case .start : return "Start"
            case .pause : return "Pause"
            case .resume: return "Resume"
            case .reset: return "Reset"
            }
        }
    }
    
    var buttonType: Style

    var body: some View {
        
        Text(buttonType.title).font(Font.custom("Gill Sans", size: 24))
            .fontWeight(.semibold)
            .frame(width: 125,height: 50)
            .background(Color("Dark Red"))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
    }
}

