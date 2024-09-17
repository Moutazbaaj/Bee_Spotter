//
//  BeeReportDetailsView.swift
//  FireBee warning
//
//  Created by Moutaz Baaj on 05.07.24.
//

import SwiftUI
import CoreLocation

struct BeeReportDetailsView: View {
    @EnvironmentObject var authViewModel: AuthViewModel    // View model to manage user data for committing.
    @EnvironmentObject var locationManager: LocationManager  // Environment object for location management
    
    @ObservedObject var beeViewModel: BeeViewModel
    @State private var isLiked = false
    @State private var showMoreInfoSheet = false
    
    @State private var showBeeKindSheet = false
    @State private var selectedBeeKind: BeeKind? // State variable to manage the selected bee kind
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // The bee report to display.
    var bee: FireBee
    
    // Environment value to dismiss the view.
    @Environment(\.dismiss) private var dismiss
    
    @State private var commentText: String = ""
    
    @FocusState private var isCommentFieldFocused: Bool // State variable to track if the comment field is focused
    
    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        // Display the location image of the bee sighting
                        MapImageView(latitude: bee.location.latitude, longitude: bee.location.longitude)
                        
                        Text("Buzz Alert near \(bee.address)! 🐝")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .fontWeight(.bold)
                            .padding()
                        HStack {
                            Text("""
        A \(bee.kind) was spotted buzzing around \(bee.address). 🌸 Don't bee alarmed, but it might be time to put on your bee hat! Stay safe and keep buzzing. 🐝
        """)
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .padding()
                            
                            Button(action: {
                                showMoreInfoSheet = true
                            }) {
                                Image(systemName: "info.bubble")
                                    .foregroundStyle(.red)
                            }
                            .sheet(isPresented: $showMoreInfoSheet) {
                                BeeReportInfoSheet(beeViewModel: beeViewModel, bee: bee)
                                    .presentationDetents([.medium, .large])
                            }
                            .padding()
                        }
                        
                        Divider()
                        Text("Title")
                            .foregroundStyle(.appYellow)
                            .padding(.leading)
                            .padding(.top)
                        
                        Text(bee.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Text("Description")
                            .foregroundStyle(.appYellow)
                            .padding(.leading)
                            .padding(.top)
                        
                        Text(bee.description)
                            .font(.title3)
                            .foregroundStyle(.gray)
                            .padding()
                        
                        Divider()
                        
                        HStack {
                            
                            Text("by:")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding(.leading)
                                .foregroundStyle(.gray)
                            
                            Divider()
                            
                            ZStack {
                                // Outer circle with shadow
                                Circle()
                                    .stroke(lineWidth: 1) // Adjust the thickness of the circle
                                    .foregroundColor(.appYellow) // The color of the circle
                                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                    .frame(width: 27, height: 27)
                                
                                AsyncImage(url: beeViewModel.profileImageURLs[bee.userId]) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 25, height: 25)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 25, height: 25)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    default:
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    }
                                }
                            }
                            
                            VStack(alignment: .leading) {
                                if authViewModel.user?.id == bee.userId {
                                    Text("You")
                                        .fontWeight(.bold)
                                        .foregroundColor(.appYellow)
                                } else {
                                    Text(bee.userName)
                                        .fontWeight(.bold)
                                    .foregroundColor(.appYellow)}
                            }
                            
                        }
                        
                        Divider()
                        
                        HStack {
                            Image("beeLogo")
                                .resizable()
                                .frame(width: 25, height: 25)
                            
                            Text(bee.kind)
                                .font(.callout)
                                .bold()
                                .foregroundColor(.red)
                            
                            Spacer()
                            
                            Image(systemName: "hand.thumbsup")
                                .foregroundColor(.black)
                            Text("\(bee.likes)")
                                .foregroundStyle(.black)
                            
                            Divider()
                            
                            Image(systemName: "text.bubble.fill")
                                .foregroundColor(.black)
                            Text("\(beeViewModel.comments.count)")
                                .font(.callout)
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .background(
                            Rectangle()
                                .foregroundColor(.appYellow)
                                .cornerRadius(10)
                                .shadow(radius: 10)
                        )
                        .padding(.horizontal, 8)
                        
                        Divider()
                        
                        // Last 3 comments view
                        CommentsSummaryView(beeViewModel: beeViewModel, bee: bee)
                            .padding()
                            .id("commentsSection") // identifier to the comments section
                        
                        Spacer()
                        
                    }
                    .navigationTitle("Bee Report")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing:
                                            Button(action: {
                        showBeeKindSheet = true
                        selectedBeeKind = BeeKind(rawValue: bee.kind)
                    }) {
                        Image(systemName: "info.circle")
                            .imageScale(.large)
                    }
                    )
                    .sheet(item: $selectedBeeKind) { beeKind in
                        BeeKindDetailView(beeKind: beeKind)
                            .presentationDetents([.medium, .large])
                    }
                    .onChange(of: isCommentFieldFocused) {_, focused in
                        if focused {
                            withAnimation {
                                proxy.scrollTo("commentsSection", anchor: .bottom)
                            }
                        }
                    }
                    .onTapGesture {
                        // Dismiss the keyboard when tapping outside of the TextField
                        isCommentFieldFocused = false
                    }
                }
                // Add Comment Section
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .focused($isCommentFieldFocused)
                        .submitLabel(.send)
                        .onSubmit {
                            submitComment(proxy: proxy)
                        }
                    
                    HStack {
                        Button(action: {
                            submitComment(proxy: proxy)
                        }) {
                            Image(systemName: "paperplane.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                        .disabled(commentText.isEmpty)
                        
                        // Check if the bee report is liked
                        if !isLiked {
                            Button(action: {
                                beeViewModel.updateBeeLikeStatus(withId: bee.id ?? "", shouldLike: true)
                                isLiked = true
                            }) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(.black)
                                    .font(.title2)
                            }
                        } else {
                            Button(action: {
                                beeViewModel.updateBeeLikeStatus(withId: bee.id ?? "", shouldLike: false)
                                isLiked = false
                            }) {
                                ZStack {
                                    Image(systemName: "hand.thumbsup.fill")
                                        .foregroundColor(.yellow)
                                        .font(.title2)
                                    Image(systemName: "hand.thumbsup")
                                        .foregroundColor(.black)
                                        .font(.title2)
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(
                    Rectangle()
                        .foregroundColor(.appYellow)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                )
                .padding(.bottom, 2)
            }
            
        }
        
        .onAppear {
            beeViewModel.startTimer(for: bee)
            
            if let beeId = bee.id {
                beeViewModel.fetchComments(forBeeId: beeId)
                beeViewModel.fetchLikeStatus(for: beeId) { liked in
                    isLiked = liked
                }
            }
            
            // Fetch profile image URL for the bee's user
            beeViewModel.fetchUserProfileImageURL(for: bee.userId)
        }
    }
    
    private func submitComment(proxy: ScrollViewProxy) {
        guard !commentText.trimmingCharacters(in: .whitespaces).isEmpty else {
            // Optionally show an alert or some other UI feedback
            return
        }
        
        beeViewModel.addComment(toBeeId: bee.id ?? "", commentText: commentText, username: authViewModel.user?.username ?? "currentUser", color: authViewModel.user?.color ?? "black")
        commentText = ""
        
        // Scroll to the appropriate comment after adding a comment
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            proxy.scrollTo("commentsSection", anchor: .bottom)
        }
    }
}
