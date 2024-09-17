//
//  ReportsListView.swift
//  Bee warning
//
//  Created by Moutaz Baaj on 01.07.24.
//

import SwiftUI

// View to display a list of user reports
struct ReportsListView: View {
    @ObservedObject var reportsViewModel: ReportsViewModel  // ViewModel to manage the reports
    
    var body: some View {
        VStack {
            if reportsViewModel.userReports.isEmpty {
                Text("There are no Reports History available yet.")
                    .foregroundColor(.gray)
                    .bold()
                    .padding()
            } else {
                List(reportsViewModel.userReports) { report in
                    
                    VStack(alignment: .leading) {
                        // Display the report title
                        Text("Title:")
                            .font(.callout)
                            .fontWeight(.semibold)
                        Text(report.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        
                        Text("Description:")
                            .font(.callout)
                            .fontWeight(.semibold)
                        // Display the report description
                        Text(report.description)
                            .font(.body)
                            .foregroundStyle(.gray)
                            .padding()
                        // Display the bee type
                        HStack {
                            Text("Type:")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text(report.kind)
                                .font(.callout)
                                .foregroundColor(.red)
                        }
                        
                        // Display the report date
                        HStack {
                            Text("Reported on:")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text(report.timestamp.dateValue(), style: .date)
                                .font(.callout)
                        }
                        
                        // Display the report time
                        HStack {
                            Text("Time:")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text(report.timestamp.dateValue(), style: .time)
                                .font(.callout)
                        }
                        
                        // Display the report location
                        HStack {
                            Text("Location:")
                                .font(.callout)
                                .fontWeight(.semibold)
                            Text("\(report.location.latitude), \(report.location.longitude)")
                                .font(.callout)
                                .foregroundColor(.gray)
                        }
                        
                        if report.editTimestamp != nil {
                            
                            HStack {
                                Text("Edited at:")
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .padding()
                                Text(report.editTimestamp!.dateValue(), style: .date)
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                                
                                Text(report.editTimestamp!.dateValue(), style: .time)
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                                
                            }
                            
                            Divider()
                        }
                    }
                    .padding()
                }
                .listStyle(.insetGrouped)
            }
        }
    }
}

#Preview {
    ReportsListView(reportsViewModel: ReportsViewModel())
}
