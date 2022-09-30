//
//  PickerView.swift
//  Cuisiner
//
//  Created by Fatih Gursoy on 26.09.2022.
//

import SwiftUI

struct PickerView: View {
    
    @StateObject var viewModel: TimeViewModel
    
    var body: some View {

        HStack(spacing: 50) {

            HStack {
                
                Picker("", selection: $viewModel.pickerHour) {
                    ForEach(0..<24) {
                        CustomText(title: "\($0)").tag($0)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 50)
                .clipped()
                
                CustomText(title: "hour")
            }
            
            HStack {
                Picker("",selection: $viewModel.pickerMinute) {
                    ForEach(0..<60) {
                        CustomText(title: "\($0)").tag($0)
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
      return CGSize(width: UIView.noIntrinsicMetric,
                    height: super.intrinsicContentSize.height)}
}

struct CustomText: View {
    
    var title: String
    
    var body: some View {
        
        Text(title)
            .font(Font.custom("Gill Sans", size: 24))
    }
}
