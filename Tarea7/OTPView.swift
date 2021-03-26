//
//  OTPView.swift
//  Tarea7
//
//  Created by Daniel Cubillo on 25/3/21.
//

import SwiftUI
import SCLAlertView
import Amplify

struct OTPView: View {
    @State var number = Int.random(in: 0..<999999)
    @State var timeRemaining: Float = 60.0
    @State var progress: Float = 1.0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @EnvironmentObject var contentVM: ContentViewModel
    
    var body: some View {
        VStack{
            Text(("\(number)"))
            .font(.largeTitle)
            .textContentType(.creditCardNumber)
            .onReceive(timer) { _ in
                                if timeRemaining > 0 {
                                    timeRemaining -= 1
                                    progress=timeRemaining/60
                                }else {
                                    timeRemaining=60
                                    progress=1
                                    number = Int.random(in: 0..<999999)
                                }
                            }//.onReceive
            
            ZStack {
                        Circle()
                            .stroke(lineWidth: 20.0)
                            .opacity(0.3)
                            .foregroundColor(Color.red)
                        
                        Circle()
                            .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                            .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                            .foregroundColor(Color.red)
                            .rotationEffect(Angle(degrees: 270.0))
                            .animation(.linear)
                        Text("\(Int(timeRemaining))")
                            .font(.largeTitle)
                            .bold()
                    }
            .frame(width: 150, height: 150, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .padding(40)
            Button(action: logOut) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Log Out").foregroundColor(Color.white)
                    Spacer()
                }
                }.padding().background(Color.red).cornerRadius(4.0)
        }//VStack
        .environmentObject(self.contentVM)
    }//view
    
    func logOut(){
        Amplify.Auth.signOut() { result in
            //switch result {
            //case .success:
            //    print("Successfully signed out")
                self.contentVM.logged = false
            //case .failure(let error):
            //    print("Sign out failed with error \(error)")
            //    self.contentVM.logged = true
            //}
        }
    }
}

struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView()
    }
}
