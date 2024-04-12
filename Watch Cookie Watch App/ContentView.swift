import SwiftUI

struct ContentView: View {
    var body: some View {
        List {
            Button("Unwanted Cookie") {
                Task {
                    try await unwantedCookie()
                }
            }
            
            Button("Cross Domain Cookie") {
                Task {
                    try await crossDomainCookie()
                }
            }
            
            Button("Clear Cookies") {
                clearCookie()
            }
        }
    }
}

#Preview {
    ContentView()
}
