import SwiftUI
import WidgetKit

private let widgetGroupId = "group.com.miniadimlar.app.widgets"

struct BabyStatusEntry: TimelineEntry {
  let date: Date
  let hasSession: Bool
  let babyName: String
  let emptyMessage: String
  let feedingAt: Date?
  let feedingDetail: String
  let feedingMlOptions: [Int]
  let diaperAt: Date?
  let diaperDetail: String
  let sleepAt: Date?
  let sleepDetail: String
  let isSleeping: Bool
  let canAddFeeding: Bool
  let canAddDiaper: Bool
  let canManageSleep: Bool
}

struct BabyStatusProvider: TimelineProvider {
  func placeholder(in context: Context) -> BabyStatusEntry {
    BabyStatusEntry(
      date: Date(),
      hasSession: true,
      babyName: "Bebek",
      emptyMessage: "",
      feedingAt: Date().addingTimeInterval(-3900),
      feedingDetail: "Anne sütü",
      feedingMlOptions: [60, 90, 120],
      diaperAt: Date().addingTimeInterval(-8100),
      diaperDetail: "Islak",
      sleepAt: Date().addingTimeInterval(-2700),
      sleepDetail: "Uyuyor",
      isSleeping: true,
      canAddFeeding: true,
      canAddDiaper: true,
      canManageSleep: true
    )
  }

  func getSnapshot(in context: Context, completion: @escaping (BabyStatusEntry) -> Void) {
    completion(loadEntry())
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<BabyStatusEntry>) -> Void) {
    completion(Timeline(entries: [loadEntry()], policy: .after(Date().addingTimeInterval(15 * 60))))
  }

  private func loadEntry() -> BabyStatusEntry {
    let data = UserDefaults(suiteName: widgetGroupId)
    return BabyStatusEntry(
      date: Date(),
      hasSession: data?.bool(forKey: "hasSession") ?? false,
      babyName: data?.string(forKey: "babyName") ?? "Bebek",
      emptyMessage: data?.string(forKey: "emptyMessage") ?? "Uygulamayı açın",
      feedingAt: date(data?.object(forKey: "feedingAt")),
      feedingDetail: data?.string(forKey: "feedingDetail") ?? "",
      feedingMlOptions: feedOptions(data),
      diaperAt: date(data?.object(forKey: "diaperAt")),
      diaperDetail: data?.string(forKey: "diaperDetail") ?? "",
      sleepAt: date(data?.object(forKey: "sleepAt")),
      sleepDetail: data?.string(forKey: "sleepDetail") ?? "",
      isSleeping: data?.bool(forKey: "isSleeping") ?? false,
      canAddFeeding: data?.bool(forKey: "canAddFeeding") ?? false,
      canAddDiaper: data?.bool(forKey: "canAddDiaper") ?? false,
      canManageSleep: data?.bool(forKey: "canManageSleep") ?? false
    )
  }

  private func date(_ value: Any?) -> Date? {
    if let number = value as? NSNumber, number.int64Value > 0 {
      return Date(timeIntervalSince1970: TimeInterval(number.int64Value) / 1000)
    }
    if let text = value as? String, let millis = Int64(text), millis > 0 {
      return Date(timeIntervalSince1970: TimeInterval(millis) / 1000)
    }
    return nil
  }

  private func feedOptions(_ data: UserDefaults?) -> [Int] {
    let defaults = [60, 90, 120]
    let values = [
      intOption(data?.object(forKey: "feedOption1")),
      intOption(data?.object(forKey: "feedOption2")),
      intOption(data?.object(forKey: "feedOption3")),
    ].compactMap { $0 }
    var result: [Int] = []
    for value in values + defaults {
      let clamped = min(300, max(10, value))
      if !result.contains(clamped) {
        result.append(clamped)
      }
      if result.count == 3 { break }
    }
    return result
  }

  private func intOption(_ value: Any?) -> Int? {
    if let number = value as? NSNumber {
      return number.intValue
    }
    if let text = value as? String {
      return Int(text)
    }
    return nil
  }
}

struct BabyStatusWidgetView: View {
  @Environment(\.widgetFamily) private var family
  let entry: BabyStatusEntry

  var body: some View {
    if !entry.hasSession {
      Text(entry.emptyMessage)
        .font(.headline)
        .multilineTextAlignment(.center)
        .containerBackground(.fill.tertiary, for: .widget)
    } else {
      switch family {
      case .systemSmall:
        small
      case .systemMedium:
        medium
      case .systemLarge:
        large
      case .accessoryCircular, .accessoryInline, .accessoryRectangular:
        lockScreen
      default:
        medium
      }
    }
  }

  private var small: some View {
    VStack(alignment: .leading, spacing: 10) {
      header
      statusLine("Son Beslenme", entry.feedingAt, entry.feedingDetail)
      amountRow(Array(entry.feedingMlOptions.prefix(2)))
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  private var medium: some View {
    VStack(alignment: .leading, spacing: 10) {
      header
      statusLine("Son Beslenme", entry.feedingAt, entry.feedingDetail)
      amountRow(entry.feedingMlOptions)
      HStack(spacing: 8) {
        actionButton("Islak", uri: "grownestwidget://diaper?type=wet", enabled: entry.canAddDiaper)
        actionButton("Kirli", uri: "grownestwidget://diaper?type=dirty", enabled: entry.canAddDiaper)
        actionButton(entry.isSleeping ? "Uyandı" : "Uyku Başladı", uri: "grownestwidget://sleep", enabled: entry.canManageSleep)
      }
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  private var large: some View {
    VStack(alignment: .leading, spacing: 12) {
      header
      statusCard("Son Beslenme", entry.feedingAt, entry.feedingDetail)
      amountRow(entry.feedingMlOptions)
      statusCard("Son Bez Değişimi", entry.diaperAt, entry.diaperDetail)
      HStack(spacing: 8) {
        actionButton("Islak", uri: "grownestwidget://diaper?type=wet", enabled: entry.canAddDiaper)
        actionButton("Kirli", uri: "grownestwidget://diaper?type=dirty", enabled: entry.canAddDiaper)
        actionButton("Karışık", uri: "grownestwidget://diaper?type=both", enabled: entry.canAddDiaper)
      }
      HStack(spacing: 8) {
        statusLine("Son Uyku", entry.sleepAt, entry.sleepDetail)
        actionButton(entry.isSleeping ? "Uyandı" : "Uyku Başladı", uri: "grownestwidget://sleep", enabled: entry.canManageSleep)
      }
    }
    .containerBackground(.fill.tertiary, for: .widget)
  }

  private var lockScreen: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text("Beslenme \(relative(entry.feedingAt))").font(.headline)
      Text("Bez \(relative(entry.diaperAt))")
      Text(entry.isSleeping ? "Uyuyor" : "Uyandı")
    }
    .widgetURL(URL(string: "grownestwidget://open"))
    .containerBackground(.fill.tertiary, for: .widget)
  }

  private var header: some View {
    HStack {
      Text("GÜNLÜK ÖZET")
        .font(.caption.bold())
        .foregroundStyle(Color(red: 0.16, green: 0.46, blue: 0.54))
      Spacer()
      Text("Bugün").font(.caption.bold()).foregroundStyle(.secondary)
    }
  }

  private func statusLine(_ title: String, _ date: Date?, _ detail: String) -> some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title).font(.caption2.bold()).foregroundStyle(.secondary).lineLimit(1)
      Text(clockWithRelative(date)).font(.caption.bold()).lineLimit(1)
      if !detail.isEmpty {
        Text(detail).font(.caption2).foregroundStyle(.secondary).lineLimit(1)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private func statusCard(_ title: String, _ date: Date?, _ detail: String) -> some View {
    statusLine(title, date, detail)
      .padding(10)
      .background(Color(red: 0.92, green: 0.96, blue: 1.0))
      .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
  }

  private func amountRow(_ values: [Int]) -> some View {
    HStack(spacing: 6) {
      ForEach(values, id: \.self) { value in
        actionButton("\(value)", uri: "grownestwidget://feeding?ml=\(value)", enabled: entry.canAddFeeding)
      }
    }
  }

  @ViewBuilder
  private func actionButton(_ title: String, uri: String, enabled: Bool) -> some View {
    if #available(iOSApplicationExtension 17, *), enabled {
      Button(intent: BackgroundIntent(url: URL(string: uri), appGroup: widgetGroupId)) {
        Text(title)
          .font(.caption.bold())
          .lineLimit(1)
          .minimumScaleFactor(0.75)
          .frame(maxWidth: .infinity, minHeight: 38)
      }
      .buttonStyle(.borderedProminent)
      .controlSize(.large)
    } else {
      Text(title)
        .font(.caption.bold())
        .lineLimit(1)
        .minimumScaleFactor(0.75)
        .foregroundStyle(enabled ? .primary : .secondary)
        .frame(maxWidth: .infinity, minHeight: 38)
        .contentShape(Rectangle())
        .widgetURL(URL(string: uri))
    }
  }

  private func relative(_ date: Date?) -> String {
    guard let date else { return "--" }
    let minutes = max(0, min(9999, Int(Date().timeIntervalSince(date) / 60)))
    if minutes < 60 { return "\(minutes) dk önce" }
    return "\(minutes / 60) saat \(String(format: "%02d", minutes % 60)) dk önce"
  }

  private func clockWithRelative(_ date: Date?) -> String {
    guard let date else { return "--" }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "tr_TR")
    formatter.dateFormat = "HH:mm"
    return "\(formatter.string(from: date))  (\(relative(date)))"
  }
}

@main
struct BabyStatusWidget: Widget {
  let kind = "BabyStatusWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: BabyStatusProvider()) { entry in
      BabyStatusWidgetView(entry: entry)
    }
    .configurationDisplayName("MiniAdımlar")
    .description("Son bez, beslenme ve uyku durumunu gösterir.")
    .supportedFamilies([
      .systemSmall,
      .systemMedium,
      .systemLarge,
      .accessoryCircular,
      .accessoryInline,
      .accessoryRectangular,
    ])
  }
}
