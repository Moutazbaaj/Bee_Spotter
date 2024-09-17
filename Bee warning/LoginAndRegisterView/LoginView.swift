//
//  LoginView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 29.06.24.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var hidePassword: Bool = true
    @State private var showForgotPasswordSheet: Bool = false
    @State private var showRegisterView: Bool = false
    @State private var showImpressumView: Bool = false
    @State private var forgotPasswxordEmail: String = ""
    
    @State private var imageOffset: CGFloat = UIScreen.main.bounds.width // Start position off-screen
    @State private var bounce: Bool = true
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color
                LinearGradient(
                    gradient: Gradient(colors: [Color.appYellow, Color.black]),
                    startPoint: .topTrailing, // Black starts from top-right
                    endPoint: .bottomLeading   // Yellow ends at bottom-left
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    VStack {
                        Spacer()
                        
                        Text("Welcome")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.black) // Text color
                        Text("login")
                            .foregroundColor(.appYellow)
                            .padding(.bottom)
                        VStack {
                            ZStack {
                                // Outer circle with shadow
                                Circle()
                                    .stroke(lineWidth: 2) // Adjust the thickness of the circle
                                    .foregroundColor(.appYellow) // The color of the circle
                                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                    .frame(width: 60, height: 60)
                                    .padding()
                                Image("beeLogo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .offset(x: imageOffset, y: bounce ? -30 : 30) // Apply bounce effect
                            }
                            .animation(
                                Animation.easeInOut(duration: 0.6)
                                    .repeatForever(autoreverses: true)
                                    .delay(0.5), value: bounce
                            )
                            .onAppear {
                                // Start animation
                                bounce.toggle()
                                withAnimation(Animation.easeInOut(duration: 5.0).repeatForever(autoreverses: false)) {
                                    imageOffset = -UIScreen.main.bounds.width // Move image to off-screen left
                                }
                            }
                        }
                        Spacer()
                        // Email TextField
                        HStack {
                            Text("Email Address")
                                .foregroundStyle(.black)
                                .padding(.bottom, -50)
                                .padding()
                            Spacer()
                        }
                        TextField("", text: $email)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .padding()
                            .submitLabel(.done) // Shows 'OK' on the return key
                        
                        // Password Field
                        HStack {
                            Text("Password")
                                .foregroundStyle(.black)
                                .padding(.bottom, -50)
                                .padding()
                            Spacer()
                        }
                        
                        HStack {
                            if hidePassword {
                                SecureField("", text: $password)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(15)
                                    .padding()
                                    .submitLabel(.done) // Shows 'OK' on the return key
                            } else {
                                TextField("", text: $password)
                                    .padding()
                                    .background(Color.black)
                                    .cornerRadius(15)
                                    .padding()
                                    .submitLabel(.done) // Shows 'OK' on the return key
                                
                            }
                            
                            Button(action: {
                                hidePassword.toggle()
                            }) {
                                Image(systemName: hidePassword ? "eye.slash" : "eye")
                                    .font(.callout)
                                    .foregroundColor(.black) // Icon color
                                    .padding()
                            }
                        }
                        
                        Spacer()
                        
                        // Log In Button
                        Button("Log In") {
                            authViewModel.login(email: email, password: password)
                        }
                        .padding()
                        .background(Color.black) // Button background color
                        .foregroundColor(.appYellow) // Button text color
                        .cornerRadius(15)
                        
                        // Forgot Password Button
                        Button("Forgot Password?") {
                            showForgotPasswordSheet = true
                        }
                        .padding()
                        .background(Color.appYellow) // Button background color
                        .foregroundColor(.black) // Button text color
                        .cornerRadius(15)
                        .padding(8)
                        .foregroundColor(.appYellow) // Button text color
                        .sheet(isPresented: $showForgotPasswordSheet) {
                            ForgotPasswordSheet(forgotPasswordEmail: $forgotPasswxordEmail)
                                .presentationDetents([.medium])
                        }
                        
                        Divider()
                            .padding()
                        
                        Text("Don't have an account?")
                            .foregroundColor(.appYellow)
                        Button("Register") {
                            showRegisterView.toggle()
                        }
                        .padding()
                        .background(Color.black) // Button background color
                        .foregroundColor(.appYellow) // Button text color
                        .cornerRadius(15)
                        .fullScreenCover(isPresented: $showRegisterView) {
                            RegisterView()
                        }
                        
                        Divider()
                        Button("Impressum") {
                            showImpressumView.toggle()
                        }
                        .padding()
                        .foregroundColor(.appYellow) // Button text color
                        .cornerRadius(15)
                        .sheet(isPresented: $showImpressumView) {
                            ImpressumView()
                                .presentationDetents([.medium, .large])
                        }
                    }
                    .padding()
                }
            }
        }
        .foregroundStyle(.appYellow)
        
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
