//
//  ClockView.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 26.09.2022.
//

import SwiftUI

struct ClockView: View {
    
    @StateObject var viewModel: TimeViewModel
    
    var body: some View {
                    
        ZStack {
            
            Text(viewModel.timeString)
                .fontWeight(.semibold)
                .font(Font.custom("Gill Sans", size: 28))
                .padding()
            
            Circle()
                .stroke(Color(.gray).opacity(0.2),
                        style: StrokeStyle(lineWidth: 30, lineCap: .round))
            
            Circle()
                .trim(from: 0, to: viewModel.circleProgress)
                .stroke(RadialGradient(colors: [.white, .red],
                                       center: .center, startRadius: 30, endRadius: 200)
                        ,style: StrokeStyle(lineWidth: 30, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut, value: true)
        }
        .frame(minWidth: 250, maxWidth: 350)
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(viewModel: TimeViewModel(initialTimeMin: 1))
    }
}
