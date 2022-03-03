//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct CatView: View {
    
    // MARK: Stored properties
    // Checks for app activity
    // https://developer.apple.com/documentation/swiftui/environmentvalues
    @Environment(\.scenePhase) var scenePhase
    
    @State var currentCat: CatImage = CatImage(file:"https://purr.objects-us-east-1.dream.io/i/Lpmgh.jpg")
    
    // Keeps track of of favourite images
    @State var favourites: [CatImage] = []
    
    // lets us know whether the current exists as a favourite
    @State var currentImageAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            RemoteImageView(fromURL: URL(string: currentCat.file)!)
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
            //                      CONDITION                        true   false
                .foregroundColor(currentImageAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    // Only add to the list if it is not already there
                    if currentImageAddedToFavourites == false {
                        
                        // Adds the current joke to the list
                        favourites.append(currentCat)
                        
                        // Record that we have marked this as a favourite
                        currentImageAddedToFavourites = true
                        
                    }
                    
                }
            
            Button(action: {
                
                // The Task type allows us to run asynchronous code
                // within a button and have the user interface be updated
                // when the data is ready.
                Task {
                    // Call the function that will get us a new joke!
                    await loadNewImage()
                }
            }, label: {
                Text("Another cat!")
            })
                .buttonStyle(.bordered)
            
            HStack {
                Text("Favourites")
                    .bold()
                    .padding()
                    .font(.title)
                
                Spacer()
            }
            
            // Iterate over the list of favourites
            // As we iterate, each individual favourite is
            // accessible via "currentFavourite"
            List(favourites, id: \.self) { currentFavourite in
                RemoteImageView(fromURL: URL(string: currentFavourite.file)!)
            }
            
            
        
            // React to changes of state for the app (foreground, background, and inactive)
             .onChange(of: scenePhase) { newPhase in

                 if newPhase == .inactive {

                     print("Inactive")

                 } else if newPhase == .active {

                     print("Active")

                 } else if newPhase == .background {

                     print("Background")

                     // Permanently save the list of tasks
                     persistFavourites()

                 }

             }

            // When the app opens, get a new joke from the web service
            .task {
                
           //load new image
                await loadNewImage()
                
                print("loading image")
                
                //Loading favourites from the local device storage
                loadFavourites()
            }
            .navigationTitle("Cutecatpicsforyou")
            .padding()
            
        }
        
    }
    // MARK: Functions
    // Using the "async" keyword means that this function can potentially
    // be run alongside other tasks that the app needs to do
    func loadNewImage() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://aws.random.cat/meow")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Try to fetch a new dog
        // It might not work, so we use a do-catch block
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentDog"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentCat = try JSONDecoder().decode(CatImage.self, from: data)
            
            // Reset the flag that tracks whether the image is a favourite
            currentImageAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block
            // populates
            print(error)
        }
        
    }
    
    // Saves (persists) the data to local storage on the device
    func persistFavourites() {
        
        // Get a URL that points to the saved JSON data containing our list of tasks
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        
        // Try to encode the data in our people array to JSON
        do {
            // Create an encoder
            let encoder = JSONEncoder()
            
            // Ensure the JSON written to the file is human-readable
            encoder.outputFormatting = .prettyPrinted
            
            // Encode the list of favourites we've collected
            let data = try encoder.encode(favourites)
            
            // Actually write the JSON file to the documents directory
            try data.write(to: filename, options: [.atomicWrite, .completeFileProtection])
            
            // See the data that was written
            print("Saved data to documents directory successfully.")
            print("===")
            print(String(data: data, encoding: .utf8)!)
            
        } catch {
            
            print(error.localizedDescription)
            print("Unable to write list of favourites to documents directory in app bundle on device.")
            
        }
        
    }
    
    // Loads favourites from local storage on the device into the list of favourites
    func loadFavourites() {
        
        // Get a URL that points to the saved JSON data containing our list of favourites
        let filename = getDocumentsDirectory().appendingPathComponent(savedFavouritesLabel)
        print(filename)
                
        // Attempt to load from the JSON in the stored / persisted file
        do {
            
            // Load the raw data
            let data = try Data(contentsOf: filename)
            
            // What was loaded from the file?
            print("Got data from file, contents are:")
            print(String(data: data, encoding: .utf8)!)

            // Decode the data into Swift native data structures
            // Note that we use [DadJoke] since we are loading into a list (array)
            // of instances of the DadJoke structure
            favourites = try JSONDecoder().decode([CatImage].self, from: data)
            
        } catch {
            
            // What went wrong?
            print(error.localizedDescription)
            print("Could not load data from file, initializing with tasks provided to initializer.")

        }

        
    }
}
    


struct CatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CatView()
        }
    }
}
