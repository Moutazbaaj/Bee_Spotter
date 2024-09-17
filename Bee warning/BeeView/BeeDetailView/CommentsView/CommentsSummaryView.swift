//
//  CommentsSummaryView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 08.08.24.
//

import SwiftUI

struct CommentsSummaryView: View {
    @ObservedObject var beeViewModel: BeeViewModel
    
    // Environment object to access the login view model.
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var bee: FireBee
    
    @State private var showAllCommentsSheet = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Comments:")
                    .bold()
                    .foregroundStyle(.appYellow)
                
                Spacer()
                
                    Button(action: {
                        showAllCommentsSheet = true
                    }) {
                        Text("Show All")
                            .font(.subheadline)
                            .foregroundStyle(.red)
                            .bold()
                            .shadow(color: .appYellow, radius: 10)
                    }
                    .sheet(isPresented: $showAllCommentsSheet) {
                        AllCommentsView(beeViewModel: beeViewModel, bee: bee)
                            .presentationDetents([.medium])
                    }
            }
            
            if !beeViewModel.comments.isEmpty {
                // Display the last 4 comments
                ForEach(beeViewModel.comments
                        //                .filter { $0.beeId == bee.id }
                    .sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })
                    .prefix(4)
                ) { comment in
                    VStack(alignment: .leading) {
                        HStack {
                            ZStack {
                                // Outer circle with shadow
                                Circle()
                                    .stroke(lineWidth: 1) // Adjust the thickness of the circle
                                    .foregroundColor(.appYellow) // The color of the circle
                                    .shadow(color: .white, radius: 10) // White shadow to create the "raised" effect
                                    .frame(width: 27, height: 27)
                                
                                AsyncImage(url: beeViewModel.profileImageURLs[comment.userId]) { phase in
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
                            HStack {
                                if authViewModel.user?.id == comment.userId {
                                    Text("You")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(from: comment.color))
                                } else {
                                    Text(comment.username)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(from: comment.color))
                                }
                            }
                            
                            Text(comment.text)
                                .font(.body)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                        
                        Divider()
                    }
                    .padding(.bottom, 5)
                }
            } else {
                Text("There are no comments yet")
                    .font(.callout)
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
    }
}
