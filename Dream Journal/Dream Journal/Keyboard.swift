//
//  Keyboard.swift
//  Dream Journal
//
//  Created by Helal Chowdhury on 7/30/20.
//  Copyright © 2020 Helal. All rights reserved.
//

import Foundation
import SwiftUI

struct Keyboard: ViewModifier {
    @State var offset: CGFloat = 0
    func body(content: Content) -> some View {
        content.padding(.bottom, offset).animation(.spring()).onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main)
                { (noti) in
                    let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.offset = height
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main)
                { (noti) in
                    self.offset = 0
            }
        }
    }
}
