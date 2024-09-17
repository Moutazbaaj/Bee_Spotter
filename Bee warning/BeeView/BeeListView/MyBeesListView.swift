//
//  MyBeesListView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 30.06.24.
//

import SwiftUI

/// A view that displays a list of bee reports made by the user.
struct MyBeesListView: View {
    
    // View model to manage the list of bee reports.
    @StateObject private var beeViewModel = BeeViewModel.shared
    @StateObject private var profileViewModel = ProfileViewModel.shared
    
    // Environment object to access the login view model.
    @EnvironmentObject var loginViewModel: AuthViewModel
    
    @State private var showAlert = false // State variable to control the display of the alert.
    @State private var showEditSheet = false // State variable to control the display of the edit sheet.
    @State private var showBeeReportSheet = false  // State to control the visibility of the bee report sheet
    @State private var beeitem: FireBee? // State variable to keep track of the bee to edit or delete.
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                if beeViewModel.myReports.isEmpty {
                    Text("No reports available")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    List(beeViewModel.myReports.sorted(by: { $0.timestamp.dateValue() > $1.timestamp.dateValue() })) { bee in
                        NavigationLink {
                            BeeReportDetailsView(beeViewModel: beeViewModel, bee: bee)
                        } label: {
                            HStack {
                                Image(bee.kind)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .padding(3)
                                    .background(Color.appYellow.opacity(0.9))
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(radius: 10)
                                    .scaledToFit()
                                
                                VStack(alignment: .leading) {
                                    Text(bee.title)
                                        .font(.headline)
                                    Text(bee.kind)
                                        .font(.subheadline)
                                        .foregroundColor(.red)
                                    HStack {
                                        Text(bee.timestamp.dateValue(), style: .date)
                                        Text(bee.timestamp.dateValue(), style: .time)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .swipeActions {
                                Button(role: .destructive) {
                                    beeitem = bee
                                    showAlert = true
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                                
                                Button {
                                    beeitem = bee
                                    showEditSheet = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.appYellow)
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    
                    .onAppear {
                        beeViewModel.fetchMyBees()
                    }
                }
            }
            .navigationTitle("My Reports")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: { showBeeReportSheet = true
            }) {
                Image(systemName: "plus")
            })
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Confirm Delete"),
                    message: Text("Are you sure you want to delete this bee report?\nTip: Report will be deleted automatically in 2 hours"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let bee = beeitem {
                            beeViewModel.deleteBees(withId: bee.id)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .sheet(isPresented: $showEditSheet) {
                if let bee = beeitem {
                    EditBeeReportSheetView(
                        beeViewModel: beeViewModel,
                        reportsViewModel: ReportsViewModel(),
                        bee: bee
                    )
                    .presentationDetents([.medium, .large])
                }
            }
            .sheet(isPresented: $showBeeReportSheet) {
                BeeReportSheetView(beeViewModel: beeViewModel)
                    .presentationDetents([.large])
            }
        }
    }
}

#Preview {
    MyBeesListView()
}
