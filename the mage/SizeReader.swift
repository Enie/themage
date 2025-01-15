// solution from Stack Overlow
// https://stackoverflow.com/a/66822461/1912421

import SwiftUI

extension View {
    func sizeReader(size: @escaping (CGSize) -> Void) -> some View {
        return self
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .preference(key: ContentSizeReaderPreferenceKey.self, value: geometry.size)
                        .onPreferenceChange(ContentSizeReaderPreferenceKey.self) { newValue in size(newValue) }
                }
                .hidden()
            )
    }
}

struct ContentSizeReaderPreferenceKey: PreferenceKey {
    static var defaultValue: CGSize { get { return CGSize() } }
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) { value = nextValue() }
}
