//
//  EditBeeReportSheetView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 12.07.24.
//

import SwiftUI
import FirebaseFirestore

// ViewModels for managing bee reports and related data
struct EditBeeReportSheetView: View {
    @ObservedObject var beeViewModel: BeeViewModel
    @ObservedObject var reportsViewModel: ReportsViewModel
    
    // Environment objects and dismiss action
    @EnvironmentObject var locationManager: LocationManager
    @Environment(\.dismiss) private var dismiss
    
    // State properties for editing the report details
    @State private var title: String
    @State private var description: String
    @State private var kind: BeeKind
    
    private var bee: FireBee
    
    // Custom initializer to populate the initial state with the selected bee report's data
    init(beeViewModel: BeeViewModel, reportsViewModel: ReportsViewModel, bee: FireBee) {
        self.beeViewModel = beeViewModel
        self.reportsViewModel = reportsViewModel
        self.bee = bee
        _title = State(initialValue: bee.title)
        _description = State(initialValue: bee.description)
        _kind = State(initialValue: BeeKind(rawValue: bee.kind) ?? .honeyBee)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Gradient background
                LinearGradient(
                    gradient: Gradient(colors: [Color.appYellow, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    
                    Text("Edit")
                        .bold()
                        .font(.largeTitle)
                    Text(title)
                        .bold()
                        .font(.subheadline)
                        .foregroundStyle(.appYellow)
                        .frame(width: 200, height: 10)
                    
                    VStack(alignment: .leading) {
                        
                        Text("Title")
                            .foregroundStyle(.black)
                        
                        TextField("", text: $title)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .padding(.bottom)
                            .submitLabel(.done) // Shows 'OK' on the return key
                        
                        Text("Provide a brief and descriptive title to help identify the issue.")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.bottom)

                        Text("Description")
                            .foregroundStyle(.black)
                        
                        TextField("", text: $description)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(15)
                            .foregroundColor(.white)
                            .padding(.bottom)
                            .submitLabel(.done) // Shows 'OK' on the return key
                        
                        Text("Description helps in understanding the context and severity.")
                            .font(.subheadline)
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.bottom)
                        
                        Divider()
                        
                        Spacer()
                        
                        HStack {
                            Spacer()
                            Button("Save") {
                                if let beeId = bee.id {
                                    beeViewModel.editBee(withId: beeId, newTitle: title, newDescription: description, newBeeKind: kind.rawValue)
                                    dismiss()
                                    title = ""
                                    description = ""
                                    print("Bee report updated successfully")
                                } else {
                                    print("Error: Bee ID is nil")
                                }
                            }
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.appYellow)
                            .cornerRadius(15)
                            .disabled(title.isEmpty || description.isEmpty)
                            Spacer()
                        }
                        .padding()
                    }
                    .padding()
                }
//                .navigationTitle("Edit Bee Report")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(trailing: Button("Cancel") {
                    dismiss()
                })
            }
        }
        .foregroundColor(.black)
    }
}

// Preview
struct EditBeeReportSheetView_Previews: PreviewProvider {
    static var previews: some View {
        EditBeeReportSheetView(
            beeViewModel: BeeViewModel(),
            reportsViewModel: ReportsViewModel.shared,
            bee: FireBee(userId: "", userName: "", title: "heloo ", description: "im scared i need help please", address: "unknon address", location: GeoPoint(latitude: 0, longitude: 0), kind: BeeKind.honeyBee.rawValue, timestamp: Timestamp(), editTimestamp: Timestamp())
        )
        .environmentObject(LocationManager())
    }
}
