import AppCore
import SwiftData
import CoreImage

final class DataStorage {
    private let lutsManager = LutsManager()

    static let shared = DataStorage()

    private var swiftDataManager: SwiftDataManager?

    private init() {}

    func addSwiftDataContext(_ context: ModelContext) {
        swiftDataManager = SwiftDataManager(context: context)
    }

    var filtersData: [FilterCICubeData] {
        swiftDataManager?.fetch(FilterCICubeData.self) ?? []
    }

    func configureFiltersDataIfNeeded() {
        let filtersData = filtersData
        print("FiltersData is", filtersData)
        filtersCategories.forEach { category in
            category.filters.forEach { filter in
                if !filtersData.contains(where: { $0.id == filter.id }) {
                    print("\(filter.title) doesn't exist in SwiftData. Trying to create filter data")
                    if let filterData = lutsManager.createDataForCIColorCube(for: filter) {
                        swiftDataManager?.insert(filterData)
                        print("Add filter data for \(filter.title)")
                    } else {
                        print("Can't create data for CIColorCube")
                    }
                } else {
                    print("Filter \(filter.title) exists in SwiftData")
                }
            }
        }
        swiftDataManager?.saveChanges()
    }

    func updateFiltersPreviews(with image: CIImage) async { // TODO: Blocking UI
        filtersCategories = filtersCategories.map { category in
            print("Processing category: \(category.title)")
            let updatedFilters = category.filters.map { filter in
                print("Processing generate filter preview: \(filter.title)")
                return Filter(
                    id: filter.id,
                    title: filter.title,
                    desc: filter.desc,
                    filename: filter.filename,
                    preview: Task.isCancelled ? nil : lutsManager.apply(filter, for: image.downsample(scaleFactor: 0.1)))
            }
            return FilterCategory(title: category.title, desc: category.desc, filters: updatedFilters)
        }
    }


    private(set) var filtersCategories: [FilterCategory] = [
        .init(title: "Film Emulation", desc: "", filters: [
            .init(id: 1, title: "Polatroid 600", desc: "A nostalgic filter mimicking the soft tones and unique vignetting of vintage Polaroid 600 film.", filename: "Polaroid 600"),
            .init(id: 2, title: "Fujix Astia 100F", desc: "Brings out vibrant yet natural colors with smooth tonal transitions, ideal for portraits and landscapes.", filename: "Fuji Astia 100F"),
            .init(id: 3, title: "Fujix Eterna 3513", desc: "A cinematic filter with muted tones and high contrast for a dramatic, filmic look.", filename: "Fuji Eterna 3513"),
            .init(id: 4, title: "Fujix Eterna 8563", desc: "Designed for a balanced, soft color palette with subtle highlights, perfect for storytelling.", filename: "Fuji Eterna 8563"),
            .init(id: 5, title: "Fujix Provia 100F", desc: "Offers rich, vibrant colors and crisp details, ideal for capturing lively scenes.", filename: "Fuji Provia 100F"),
            .init(id: 6, title: "Fujix Sensia 100", desc: "A versatile filter with gentle saturation and a warm tint for everyday photography.", filename: "Fuji Sensia 100"),
            .init(id: 7, title: "Fujix Superia Xtra 400", desc: "Known for its bold colors and enhanced contrast, perfect for dynamic and high-energy shots.", filename: "Fuji Superia Xtra 400"),
            .init(id: 8, title: "Fujix Vivid 8543", desc: "Creates a strikingly vivid color profile with intense saturation, suited for impactful visuals.", filename: "Fuji Vivid 8543"),
            .init(id: 9, title: "Kodex Ektachrome 64", desc: "A retro-inspired filter with cool tones and a fine grain for a vintage aesthetic.", filename: "Kodak Ektachrome 64"),
            .init(id: 10, title: "Kodex Professional Portra 400", desc: "Delivers soft, natural tones with excellent skin color reproduction, great for portraits.", filename: "Kodak Professional Portra 400"),
            .init(id: 11, title: "Kodex Vision 2383", desc: "A cinematic filter with deep shadows and vivid highlights, replicating a classic movie look.", filename: "Kodak Vision 2383"),
            .init(id: 12, title: "LLP Tetrachrome 400", desc: "Features a unique color separation effect, creating a vibrant and experimental style.", filename: "LPP Tetrachrome 400"),
            .init(id: 13, title: "Afga Portrait XPS 160", desc: "A gentle filter with soft pastel tones, designed to enhance skin tones for portrait work.", filename: "Agfa Portrait XPS 160"),
            .init(id: 14, title: "65mm", desc: "Adds a cinematic depth and texture, emulating the look of classic large-format film.", filename: "65MM_FILM_01"),
            .init(id: 15, title: "35mm", desc: "A modern film-inspired filter with a balanced grain and rich contrast, ideal for everyday captures.", filename: "MODERN_FILM_01")
        ]),
        .init(title: "Cinema", desc: "", filters: [
            .init(id: 16, title: "Psycho", desc: "'We all go a little mad sometimes.'", filename: "CINECOLOR_PSYCHO"),
            .init(id: 22, title: "Alien", desc: "'In space, no one can hear you scream.'", filename: "CINECOLOR_ALIEN"),
            .init(id: 17, title: "Blade Runner 2049", desc: "'You’ve never seen a miracle.'", filename: "CINECOLOR_BLADE_RUNNER_2049"),
            .init(id: 18, title: "Clockwork Orange", desc: "'What’s it going to be then, eh?'", filename: "CINECOLOR_CLOCKWORK_ORANGE"),
            .init(id: 19, title: "Jaws", desc: "'You’re gonna need a bigger boat.'", filename: "CINECOLOR_JAWS"),
            .init(id: 20, title: "Saving Private Ryan", desc: "'Earn this.'", filename: "CINECOLOR_SAVING_PRIVATE_RYAN"),
            .init(id: 21, title: "Sin Sity", desc: "'The night is hot as hell.'", filename: "CINECOLOR_SIN_CITY"),
            .init(id: 27, title: "Amelie", desc: "'Times are hard for dreamers.'", filename: "Amelie"),
            .init(id: 28, title: "Aviator", desc: "'The way of the future.'", filename: "Aviator"),
            .init(id: 29, title: "Blade Runner", desc: "'All those moments will be lost in time… like tears in rain.'", filename: "Blade Runner"),
            .init(id: 35, title: "Drive", desc: "'You give me a time and a place, I give you a five-minute window.'", filename: "Drive"),
            .init(id: 42, title: "Godfather", desc: "'I'm gonna make him an offer he can't refuse.'", filename: "Godfather"),
            .init(id: 43, title: "Grand Budapest", desc: "'Rudeness is merely the expression of fear.'", filename: "Grand Budapest"),
            .init(id: 46, title: "Hannibal", desc: "'I’m having an old friend for dinner.'", filename: "Hannibal"),
            .init(id: 47, title: "Her", desc: "'The past is just a story we tell ourselves.'", filename: "Her"),
            .init(id: 48, title: "Mad Max", desc: "'Oh, what a day! What a lovely day!'", filename: "Mad Max"),
            .init(id: 49, title: "The Matrix", desc: "'There is no spoon.'", filename: "Matrix V1"),
            .init(id: 50, title: "The Matrix Reloaded", desc: "'I know kung fu.'", filename: "Matrix V2"),
            .init(id: 52, title: "Moonrise Kingdom", desc: "'I love you, but you don’t know what you’re talking about.'", filename: "Moonrise Kingdom"),
            .init(id: 59, title: "Stranger Things", desc: "'Friends don’t lie.'", filename: "Stranger Things"),
            .init(id: 64, title: "Wonder Woman", desc: "'It’s about what you believe.'", filename: "Wonder Woman"),
            .init(id: 55, title: "Revenant", desc: "'As long as you can still grab a breath, you fight.'", filename: "Revenant"),
            .init(id: 38, title: "Enemy", desc: "'Chaos is order yet undeciphered.'", filename: "Enemy"),
            .init(id: 57, title: "Seven", desc: "'What’s in the box?!'", filename: "Seven"),
        ])
    ]

    let texturesCategories: [TextureCategory] = [
        .init(title: "Glare", textures: [
            .init(title: "Glare 1", filename: "Textures/Glare/1"),
            .init(title: "Glare 2", filename: "Textures/Glare/2"),
            .init(title: "Glare 3", filename: "Textures/Glare/3"),
            .init(title: "Glare 4", filename: "Textures/Glare/4"),
            .init(title: "Glare 5", filename: "Textures/Glare/5"),
            .init(title: "Glare 6", filename: "Textures/Glare/6"),
            .init(title: "Glare 7", filename: "Textures/Glare/7"),
            .init(title: "Glare 8", filename: "Textures/Glare/8"),
            .init(title: "Glare 9", filename: "Textures/Glare/9"),
            .init(title: "Glare 10", filename: "Textures/Glare/10")
        ]),
        .init(title: "VHS", textures: [
            .init(title: "VHS 1", filename: "Textures/VHS-Noise/1"),
            .init(title: "VHS 2", filename: "Textures/VHS-Noise/2"),
            .init(title: "VHS 3", filename: "Textures/VHS-Noise/3"),
            .init(title: "VHS 4", filename: "Textures/VHS-Noise/4"),
            .init(title: "VHS 5", filename: "Textures/VHS-Noise/5"),
            .init(title: "VHS 6", filename: "Textures/VHS-Noise/6"),
            .init(title: "VHS 7", filename: "Textures/VHS-Noise/7"),
            .init(title: "VHS 8", filename: "Textures/VHS-Noise/8"),
            .init(title: "VHS 9", filename: "Textures/VHS-Noise/9"),
            .init(title: "VHS 10", filename: "Textures/VHS-Noise/10")
        ]),
        .init(title: "Grain", textures: [
            .init(title: "Grain 1", filename: "Textures/Grain/grain1"),
            .init(title: "Grain 4", filename: "Textures/Grain/grain4"),
            .init(title: "Grain 5", filename: "Textures/Grain/grain5"),
            .init(title: "Grain 6", filename: "Textures/Grain/grain6"),
            .init(title: "Grain 7", filename: "Textures/Grain/grain7")
        ]),
        .init(title: "Rust", textures: [
            .init(title: "Rust 1", filename: "Textures/Rust/rust1"),
            .init(title: "Rust 2", filename: "Textures/Rust/rust2"),
            .init(title: "Rust 3", filename: "Textures/Rust/rust3"),
            .init(title: "Rust 4", filename: "Textures/Rust/rust4"),
            .init(title: "Rust 5", filename: "Textures/Rust/rust5"),
            .init(title: "Rust 6", filename: "Textures/Rust/rust6"),
            .init(title: "Rust 7", filename: "Textures/Rust/rust7"),
            .init(title: "Rust 8", filename: "Textures/Rust/rust8"),
            .init(title: "Rust 9", filename: "Textures/Rust/rust9"),
            .init(title: "Rust 10", filename: "Textures/Rust/rust10")
        ])
    ]

}


/*
 1.    3Strip: Inspired by the Technicolor three-strip process used in classic films from the 1930s to 1950s.
 2.    70s: Likely inspired by the general aesthetic of films from the 1970s, known for warm tones and naturalistic color palettes.
 3.    Bleach: Possibly a reference to the “bleach bypass” technique used in films like Saving Private Ryan for desaturated, high-contrast visuals.
 4.    Brooklyn: More likely inspired by a regional or urban aesthetic rather than a specific film, but could reference indie films set in Brooklyn.
 5.    Celadon: This filter name suggests a soft, pastel-like palette, which might not directly reference a specific film.
 6.    Chamoisee: A unique earthy color tone, not clearly tied to a film but may evoke vintage or historical styles.
 7.    Cubanismo: Suggests a vibrant, tropical color palette possibly inspired by Cuban cinema or films set in Cuba.
 8.    Duotone: Could reference a visual style used in modern graphic films, but not specific to one film.
 9.    Emulsion: A nod to analog film stock and its characteristic look, referencing the general feel of celluloid film.
 10.    Enemy: Likely inspired by the Denis Villeneuve film Enemy, known for its distinctive yellow-green tint.
 11.    Enhance: Not directly tied to a film, likely a general filter for improving image clarity and vibrancy.
 12.    Fashion: Could be inspired by high-fashion photo shoots, not tied to a specific movie.
 13.    Glacier: Might reflect the cold, blue tones often seen in films set in icy or remote environments.
 14.    Grime: Suggests a gritty, urban aesthetic, potentially referencing films with a dark or raw atmosphere.
 15.    Grit: Similar to “Grime,” it evokes rugged or harsh visuals, possibly inspired by neo-noir or crime dramas.
 16.    Mint: Suggests a soft, pastel green aesthetic, unlikely to be tied to a specific film.
 17.    Ochre: Earthy tones, not directly tied to a film, but it could evoke desert or period settings.
 18.    Punch: A vibrant, high-contrast filter; may not reference a specific film but a general dynamic style.
 19.    Rhythm: May suggest musical or vibrant cinematic styles but isn’t directly tied to a specific film.
 20.    Seven: Clearly inspired by the David Fincher film Se7en, known for its dark, moody, and desaturated tones.
 21.    Spy: Likely inspired by the spy genre, with cold, metallic, or cinematic tones seen in films like James Bond or Tinker Tailor Soldier Spy.
 22.    Summer: Evoking bright, warm tones; not tied to a specific movie but a seasonal aesthetic.
 23.    Teal and Orange: This directly references the popular cinematic color grading style seen in blockbusters for contrast and vibrancy.
 24.    Thriller: Likely inspired by the general thriller genre, with dark and moody tones.
 25.    Vinteo: Possibly referencing vintage film aesthetics but not tied to a specific movie.
 */
