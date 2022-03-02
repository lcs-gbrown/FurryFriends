//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
    
    @State var currentDog: DogImage = DogImage(message: "https://images.dog.ceo/breeds/mastiff-bull/n02108422_3297.jpg", status: "success")
    
    // Keeps track of our list of favourite jokes
    @State var favourites: [DogImage] = []   // empty list to start
    
    // This will let us know whether the current exists as a favourite
    @State var currentImageAddedToFavourites: Bool = false
    
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            RemoteImageView(fromURL: URL(string: currentDog.message)!)
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
            //                      CONDITION                        true   false
                .foregroundColor(currentImageAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    // Only add to the list if it is not already there
                    if currentImageAddedToFavourites == false {
                        
                        // Adds the current joke to the list
                        favourites.append(currentDog)
                        
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
                Text("Another dog!")
            })
                .buttonStyle(.bordered)
            
            
            // Iterate over the list of favourites
            // As we iterate, each individual favourite is
            // accessible via "currentFavourite"
            List(favourites, id: \.self) { currentFavourite in
                Text(currentFavourite.message)
            }
            .navigationTitle("Furry Friends")
            
        }
        
    }
    // MARK: Functions
    // Using the "async" keyword means that this function can potentially
    // be run alongside other tasks that the app needs to do
    func loadNewImage() async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
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
            currentDog = try JSONDecoder().decode(DogImage.self, from: data)
            
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
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
