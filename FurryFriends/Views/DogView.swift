//
//  ContentView.swift
//  FurryFriends
//
//  Created by Russell Gordon on 2022-02-26.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Stored properties
   
    @State var currentImage: DogImage = DogImage(id: "",
                                                 message: "https://images.dog.ceo/breeds/mastiff-bull/n02108422_3297.jpg",
                                                 status: "success")
    //Pass in property of structure to image address
    @State var currentURL = URL(string: "https://images.dog.ceo/breeds/mastiff-bull/n02108422_3297.jpg")
    
    //Keeps track of favourites
    @State var favourites: [DogImage] = []
    
    // Check if current image is already favourite
    @State var currentImageAddedToFavourites: Bool = false
    
    // Address for main image
    // Starts as a transparent pixel – until an address for an animal's image is set
//    @State var currentImage = URL(string: "https://www.russellgordon.ca/lcs/miscellaneous/transparent-pixel.png")!
//
    // MARK: Computed properties
    var body: some View {
        
        VStack {
            
            // Shows the main image
            RemoteImageView(fromURL: currentURL!)
            
            // Push main image to top of screen
            Spacer()
            
            Image(systemName: "heart.circle")
                .font(.largeTitle)
                //                      CONDITION                        true   false
                .foregroundColor(currentImageAddedToFavourites == true ? .red : .secondary)
                .onTapGesture {
                    
                    // Only add to the list if it is not already there
                    if currentImageAddedToFavourites == false {
                        
                        // Adds the current joke to the list
                        favourites.append(currentImage)
                        
                        // Record that we have marked this as a favourite
                        currentImageAddedToFavourites = true

                    }
                    
                }


        }
        // Runs once when the app is opened
//        .task {
//
//            // Example images for each type of pet
//            let remoteCatImage = "https://purr.objects-us-east-1.dream.io/i/JJiYI.jpg"
//            let remoteDogImage = "https://images.dog.ceo/breeds/labrador/lab_young.JPG"
//
//            // Replaces the transparent pixel image with an actual image of an animal
//            // Adjust according to your preference ☺️
//            currentImage = URL(string: currentURL)
//
//        }
        .navigationTitle("Furry Friends")
        
    }
    
    // MARK: Functions
    
    //loads new images
    func loadNewImage () async {
        // Assemble the URL that points to the endpoint
        let url = URL(string: "https://images.dog.ceo/breeds/mastiff-bull/n02108422_3297.jpg")!
        
        // Define the type of data we want from the endpoint
        // Configure the request to the web site
        var request = URLRequest(url: url)
        // Ask for JSON data
        request.setValue("application/json",
                         forHTTPHeaderField: "Accept")
        
        // Start a session to interact (talk with) the endpoint
        let urlSession = URLSession.shared
        
        // Generate new image, in case of failure use do catch
        do {
            
            // Get the raw data from the endpoint
            let (data, _) = try await urlSession.data(for: request)
            
            // Attempt to decode the raw data into a Swift structure
            // Takes what is in "data" and tries to put it into "currentJoke"
            //                                 DATA TYPE TO DECODE TO
            //                                         |
            //                                         V
            currentImage = try JSONDecoder().decode(DogImage.self, from: data)
            
            // Reset the flag that tracks whether the current joke
            // is a favourite
            currentImageAddedToFavourites = false
            
        } catch {
            print("Could not retrieve or decode the JSON from endpoint.")
            // Print the contents of the "error" constant that the do-catch block sees
            print(error)
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
