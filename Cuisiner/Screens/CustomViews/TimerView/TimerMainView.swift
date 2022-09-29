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
                    
                    Button {
                        viewModel.resetTimer()
                    } label: {
                        TimerButton(buttonType: .reset)
                    }
                    
                    Button {
                        viewModel.isTimerRunning.toggle()
                    } label: {
                        if viewModel.isTimerRunning {
                            TimerButton(buttonType: .pause)
                        } else {
                            viewModel.isStartTapped
                            ? TimerButton(buttonType: .resume)
                            : TimerButton(buttonType: .start)
                        }
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
        TimerMainView(viewModel: TimeViewModel(initialTimeMin: 1))
    }
}


