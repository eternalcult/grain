import Foundation
import CoreImage

struct Filter: Identifiable {
    let id = UUID()
    let title: String
    /// Название .cube файла
    let filename: String
    let preview: CGImage?

    init(title: String, filename: String, preview: CGImage? = nil) {
        self.title = title
        self.filename = filename
        self.preview = preview
    }
}

struct FilterCategory: Identifiable {
    let id = UUID()
    let title: String
    let desc: String
    let filters: [Filter]
}




var filtersCategories: [FilterCategory] = [
    .init(title: "Film Emulation", desc: "", filters: [
        .init(title: "Polatroid 600", filename: "Polaroid 600"),
        .init(title: "Fujix Astia 100F", filename: "Fuji Astia 100F"),
        .init(title: "Fujix Eterna 3513", filename: "Fuji Eterna 3513"),
        .init(title: "Fujix Eterna 8563", filename: "Fuji Eterna 8563"),
        .init(title: "Fujix Provia 100F", filename: "Fuji Provia 100F"),
        .init(title: "Fujix Sensia 100", filename: "Fuji Sensia 100"),
        .init(title: "Fujix Superia Xtra 400", filename: "Fuji Superia Xtra 400"),
        .init(title: "Fujix Vivid 8543", filename: "Fuji Vivid 8543"),
        .init(title: "Kodex Ektachrome 64", filename: "Kodak Ektachrome 64"),
        .init(title: "Kodex Professional Portra 400", filename: "Kodak Professional Portra 400"),
        .init(title: "Kodex Vision 2383", filename: "Kodak Vision 2383"),
        .init(title: "LLP Tetrachrome 400", filename: "LPP Tetrachrome 400"),
        .init(title: "Afga Portrait XPS 160", filename: "Agfa Portrait XPS 160")
    ]),
    .init(title: "Cinema", desc: "", filters: [
        .init(title: "Blade Runner 2049", filename: "CINECOLOR_BLADE_RUNNER_2049")
    ])
]

