//
//  SwiftUIView.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 22.09.2022.
//

import SwiftUI

struct TimerMainView: View {
        
    @StateObject var viewModel: TimeViewModel
    
    var body: some View {
        
        ZStack {
            
            Color("recipeBackground")
                .ignoresSafeArea()
            
            VStack() {
                
                Text("Timer")
                    .font(Font.custom("Gill Sans", size: 30))
                    .fontWeight(.semibold)
                    .padding()
                
                PickerView(selectedHour: $viewModel.pickerHour,
                           selectedMin: $viewModel.pickerMinute)
                .padding()
                
                Spacer()
                
                ClockView(viewModel: viewModel)
                    .padding()
                Spacer()
                HStack {
                    ButtonView(title: "Reset") {
                        viewModel.resetTimer()
                    }
                    
                    ButtonView(title: (viewModel.isTimerRunning ? "Stop" : "Start")) {
                        viewModel.isTimerRunning.toggle()
                    }
                }
            }
            .onReceive(viewModel.timer, perform: { _ in
                viewModel.runTimer()
            })
        }
    }
    
}


struct TimerMainView_Previews: PreviewProvider {
    
    static var previews: some View {
        TimerMainView(viewModel: TimeViewModel(initialTimeMin: 5))
    }
}

struct ButtonView: View {
    
    var title: String
    var action: () -> ()
    
    var body: some View {
        
        Button(action: action, label: {
            Text(title).font(Font.custom("Gill Sans", size: 24))
                .fontWeight(.semibold)
        })
        .frame(width: 125,
               height: 50)
        .background(Color("Dark Red"))
        .foregroundColor(.white)
        .clipShape(Capsule())
        .padding()
    }
}
