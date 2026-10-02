// The probe (first hands-on test, T-S1): proves the App Group the free team signed, writes a marker into it,
// registers the "Lab" location in Files, and shows whether the File Provider extension has run (its own marker).
import FileProvider
import SwiftUI

@main
struct LabApp: App {
    var body: some Scene {
        WindowGroup { ProbeView() }
    }
}

struct ProbeView: View {
    @State private var lines: [String] = ["checking..."]

    var body: some View {
        NavigationStack {
            List(lines, id: \.self) { Text($0).font(.system(.footnote, design: .monospaced)) }
                .navigationTitle("Lab probe")
                .task { await check() }
                .refreshable { await check() }
        }
    }

    private func check() async {
        var out: [String] = []
        let group = Bundle.main.object(forInfoDictionaryKey: "LabAppGroup") as? String ?? "(no LabAppGroup)"
        out.append("group: \(group)")
        if let box = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) {
            out.append("group container: yes")
            do {
                try "app ran \(Date())".write(to: box.appendingPathComponent("app-marker"), atomically: true, encoding: .utf8)
                out.append("app-marker: written")
            } catch {
                out.append("app-marker: FAILED \(error.localizedDescription)")
            }
            let fp = (try? String(contentsOf: box.appendingPathComponent("fp-marker"), encoding: .utf8)) ?? "absent"
            out.append("fp-marker: \(fp)")
        } else {
            out.append("group container: NO (the group was not granted)")
        }
        let domain = NSFileProviderDomain(identifier: NSFileProviderDomainIdentifier("lab"), displayName: "Lab")
        do {
            try await NSFileProviderManager.add(domain)
            out.append("Files location \"Lab\": added")
        } catch {
            out.append("Files location: FAILED \(error.localizedDescription)")
        }
        lines = out
    }
}
