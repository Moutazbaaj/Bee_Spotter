//
//  AllCommentsView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 08.08.24.
//

import SwiftUI

struct AllCommentsView: View {
    @ObservedObject var beeViewModel: BeeViewModel
    
    // Environment object to access the login view model.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var showAlert = false // State variable to control the display of the alert.
    @State private var commentToDelete: FireComment? // State to hold the comment to delete
    @State private var commentText: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var bee: FireBee
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if !beeViewModel.comments.isEmpty {
                        ForEach(beeViewModel.comments
                            .sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                        ) { comment in
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack {
                                        ZStack {
                                            // Outer circle with shadow
                                            Circle()
                                                .stroke(lineWidth: 1) // Adjust the thickness of the circle
                                                .foregroundColor(.appYellow) // The color of the circle
                                                .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                                .frame(width: 55, height: 55)
                                            
                                            AsyncImage(url: beeViewModel.profileImageURLs[comment.userId]) { phase in
                                                switch phase {
                                                case .empty:
                                                    ProgressView()
                                                        .frame(width: 50, height: 50)
                                                case .success(let image):
                                                    image
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 50, height: 50)
                                                        .clipShape(Circle())
                                                case .failure:
                                                    Image(systemName: "person.circle.fill")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                default:
                                                    Image(systemName: "person.circle.fill")
                                                        .resizable()
                                                        .frame(width: 50, height: 50)
                                                }
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.top)
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(comment.username)
                                                .fontWeight(.bold)
                                                .foregroundColor(Color(from: comment.color))
                                            if authViewModel.user?.id == comment.userId {
                                                Text("You")
                                                    .fontWeight(.thin)
                                                    .foregroundColor(.gray)
                                            }
                                        }
                                        
                                        Text(comment.text)
                                            .font(.body)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                Text("\(comment.timestamp.dateValue(), style: .date) - \(comment.timestamp.dateValue(), style: .time)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .swipeActions {
                                // Check if the comment belongs to the current user
                                if authViewModel.user?.id == comment.userId {
                                    Button(role: .destructive) {
                                        commentToDelete = comment
                                        showAlert = true
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                            }
                        }
                    } else {
                        Text("There are no comments yet")
                            .font(.callout)
                            .foregroundStyle(.gray)
                            .padding()
                    }
                }
                
                // Add Comment Section
                HStack {
                    TextField("Add a comment...", text: $commentText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.send)
                        .onSubmit {
                            submitComment()
                        }
                    Button(action: {
                        submitComment()
                    }) {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.black)
                            .font(.title2)
                    }
                    .disabled(commentText.isEmpty)
                }
                .padding()
                .background(
                    Rectangle()
                        .foregroundColor(.appYellow)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                )
                .padding(.bottom, 2)
                .navigationTitle("Comments")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Cancel") {
                    dismiss()
                })
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Confirm Delete"),
                        message: Text("Are you sure you want to delete this Comment?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let comment = commentToDelete {
                                beeViewModel.deleteComment(withId: comment.id)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .foregroundStyle(.appYellow)
        }
    }
    
    private func submitComment() {
        guard !commentText.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        // Add the comment
        beeViewModel.addComment(toBeeId: bee.id ?? "", commentText: commentText, username: authViewModel.user?.username ?? "currentUser", color: authViewModel.user?.color ?? "black")
        commentText = ""
    }
}
