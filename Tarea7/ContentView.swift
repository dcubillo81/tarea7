//
//  ContentView.swift
//  Tarea7
//
//  Created by Daniel Cubillo on 25/3/21.
//

import SwiftUI
import LocalAuthentication
import Amplify
import SCLAlertView

class ContentViewModel: ObservableObject {
    @Published var logged = false
    
    func isLogged()->Bool{
        return logged
    }
}


struct ContentView: View {
    @State private var username = ""
    @State private var password = ""
    @State var logged = false
    @StateObject var contentVM = ContentViewModel()
    
    var body: some View {
        NavigationView{
            if contentVM.isLogged() == false{
        VStack{
            Image("bac")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            TextField("Username", text: $username)
                .padding()
                .cornerRadius(4.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 15, trailing: 0))
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                    .padding()
                    .cornerRadius(4.0)
                    .padding(.bottom, 10)
                    .autocapitalization(.none)
            
            if getBiometricStatus(){
                Button(
                    action: authenticateUser,
                    label:{
                        Image (systemName: LAContext().biometryType == .faceID ? "faceid" : "touchid")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                )
            }
            
            
            Button(action: signIn) {
                HStack(alignment: .center) {
                    Spacer()
                    Text("Ingresar").foregroundColor(Color.white)
                    Spacer()
                }
                }.padding().background(Color.red).cornerRadius(4.0)
            
            HStack{
                Text("Primera vez que ingresa?")
                    .foregroundColor(.gray)
                NavigationLink(destination: newuserView()) {
                    Text("Registrarse Aquí")
                        .foregroundColor(.blue)
                }//NavigationLink
            }//HStack
        }//VStack
        }else
        {OTPView()}
        }//NavigationView
        .onAppear { self.fetchCurrentAuthSession() }
        .navigationBarTitle("Welcome")
        .environmentObject(self.contentVM)
        
    }//View
    
    func signIn() {
        Amplify.Auth.signIn(username: username, password: password) { result in
            switch result {
            
            case .success:
                print("\(username) signed in")
                DispatchQueue.main.async {
                    self.contentVM.logged = true
                    print("Login In")
                }
                
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    SCLAlertView().showError("Error", subTitle: error.errorDescription) // Error

                }
            }
        }
            
    }//signIn
    
    //FACEID
    func getBiometricStatus()->Bool{
        let scanner = LAContext()
        // Biometry is available on the device
        if scanner.canEvaluatePolicy(.deviceOwnerAuthentication, error: .none){return true }
        return false
    }
    //FACEID
    func authenticateUser(){
        let scanner = LAContext()
        scanner.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                            localizedReason: "To Unlock"){(status, error) in
            if error != nil{
                print("Error")
                print(error!.localizedDescription)
    return }
            withAnimation(.easeOut){self.contentVM.logged = true}
        }
    }
    
    //VERIFICA QUE ESTA INICIADA LA SESION EN AMPLIFY
    func fetchCurrentAuthSession() {
        Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
                
                if session.isSignedIn {
                    self.contentVM.logged = true
                }
                
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }//fetchCurrentAuthSession
    
    
    
    
}//ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
