//
//  Bee_warning_Widget.swift
//  Bee warning Widget
//
//  Created by Moutaz Baaj on 20.08.24.
//

import WidgetKit
import SwiftUI

struct BeeEntry: TimelineEntry {
    let date: Date
    let beeKind: BeeKind
}

struct BeeWidgetEntryView: View {
    var entry: BeeProvider.Entry
    
    var body: some View {
        VStack {
            Text("🐝")
            Text(entry.beeKind.wedgitDescription)
                .foregroundStyle(.black)
                .shadow(color: .appYellow, radius: 0.5)
                .font(.callout)
                .bold()
                .multilineTextAlignment(.center)
        }
        .containerBackground(.appYellow.opacity(0.9), for: .widget)
    }
}

struct BeeWidget: Widget {
    let kind: String = "BeeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: BeeProvider()) { entry in
            BeeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Bee Types")
        .description("Show different facts about a Bee type.")
        .supportedFamilies([.systemMedium])
    }
}

struct BeeProvider: TimelineProvider {
    func placeholder(in context: Context) -> BeeEntry {
        BeeEntry(date: Date(), beeKind: .honeyBee)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BeeEntry) -> Void) {
        let entry = BeeEntry(date: Date(), beeKind: .honeyBee)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<BeeEntry>) -> Void) {
        var entries: [BeeEntry] = []
        let currentDate = Date()
        
        for (index, beeKind) in BeeKind.allCases.enumerated() {
            let entryDate = Calendar.current.date(byAdding: .second, value: index * 10, to: currentDate)!
            let entry = BeeEntry(date: entryDate, beeKind: beeKind)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct BeeWidget_Previews: PreviewProvider {
    static var previews: some View {
        BeeWidgetEntryView(entry: BeeEntry(date: Date(), beeKind: .honeyBee))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
