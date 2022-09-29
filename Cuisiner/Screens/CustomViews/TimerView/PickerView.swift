//
//  PickerView.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 26.09.2022.
//

import SwiftUI

struct PickerView: View {
    
    @Binding var selectedHour: Int
    @Binding var selectedMin: Int
    
    var body: some View {

        HStack(spacing: 50) {

            HStack {
                Picker("", selection: $selectedHour) {
                    ForEach(0...23, id: \.self) { index in
                        CustomText(title: "\(index)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50)
                .clipped()
                
                CustomText(title: "hour")
            }
            
            HStack {
                Picker("",selection: $selectedMin) {
                    ForEach(0...59, id: \.self) { index in
                        CustomText(title: "\(index)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50)
                .clipped()

                CustomText(title: "min")
            }
        }
    }
}

extension UIPickerView {
   open override var intrinsicContentSize: CGSize {
      return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)}
}

struct CustomText: View {
    
    var title: String
    
    var body: some View {
        
        Text(title)
            .font(Font.custom("Gill Sans", size: 24))
    }
}
