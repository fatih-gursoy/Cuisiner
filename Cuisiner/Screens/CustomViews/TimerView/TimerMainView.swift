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
                Spacer()
                if viewModel.isStartTapped {
                    ClockView(viewModel: viewModel)
                        .padding(20)
                } else {
                    VStack() {
                        CustomText(title: "Please set a Cooking Time")
                            .padding()
                        
                        Divider()
                        
                        PickerView(viewModel: viewModel).padding()
                            .onAppear {
                                viewModel.resetTimer()
                            }
                    }
                }
                          
                Spacer()
                
                HStack {
                    
                    Button {
                        viewModel.resetTimer()
                    } label: {
                        TimerButton(buttonType: .reset)
                    }
                    
                    Button {
                        viewModel.isTimerRunning.toggle()
                        if viewModel.isTimerRunning { viewModel.startTimer() }
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
        }
        .onReceive(viewModel.timer) { _ in
            viewModel.runTimer()
        }
    }
    
}

struct TimerMainView_Previews: PreviewProvider {
    
    static var previews: some View {
        TimerMainView(viewModel: TimeViewModel(initialTimeMin: 1))
    }
}


