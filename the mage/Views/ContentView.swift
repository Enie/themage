import SwiftUI

struct ContentView: View {
    @State var name: String = ""
    @State var age: Int?
    
    @State private var canFetch: Bool = false
    @State private var animateAge: Bool = true
    @State private var fetchMessage: String?
    
    @FocusState private var isNameFieldFocused: Bool
    
    private let errorMessages: [String] = [
        "Something is blocking my psychic powers",
        "I can't quite make out your age",
        "I'm feeling a bit overwhelmed",
        "I'm sorry, I don't know",
        "I'm feeling a bit confused",
    ]

    var body: some View {
        VStack(spacing: 32) {
            Text("Tell me your name and I will tell you how old you probably are")
                .foregroundStyle(.white)
            TextFieldWithButton(text: $name, placeholder: "Enter your name") { name in
                fetchAgify(for: name)
            } onChange: { _, newName in
                animateAge = true
                fetchMessage = nil
                withAnimation(.easeInOut(duration: 0.2)) {
                    canFetch = newName.count != 0
                }
            }
            .padding(.horizontal, -16)
            VStack() {
                ParticleTextView("I can see your age is most probably...", animate: name.count == 0)
                    .padding([.top])
                ZStack(alignment: .top) {
                    ParticleTextView(fetchMessage ?? "", animate: fetchMessage == nil)
                        .font(.system(size: 32, weight: .bold))
                        .opacity(fetchMessage != nil ? 1 : 0)
                    ParticleTextView("\(age ?? 42)", animate: animateAge)
                        .font(.system(size: 72, weight: .bold))
                        .opacity(fetchMessage == nil ? 1 : 0)
                }
            }
            .foregroundStyle(.white)
        
            Spacer()
        }
        .padding(32)
        .background(.blue)
    }
    
    func fetchAgify(for name: String) {
        guard let url = URL(string: "https://api.agify.io?name=\(name.trimmingCharacters(in: .whitespacesAndNewlines))") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            do {
                let agifyResponse = try JSONDecoder().decode(AgifyResponse.self, from: data)
                DispatchQueue.main.async {
                    self.age = agifyResponse.age
                    self.animateAge = self.age == nil ? true : false
                }
            } catch {
                DispatchQueue.main.async {
                    self.age = nil
                    let randomMessageIndex = Int.random(in: 0..<5)
                    print(randomMessageIndex)
                    self.fetchMessage = errorMessages[randomMessageIndex]
                    self.animateAge = self.age == nil ? true : false
                }
                print(error.localizedDescription)
            }
        }.resume()
    }
}

#Preview {
    ContentView()
}
