//
//  ContentView.swift
//  2026_12_02_ButtonsWithAnimationSymbols-Spampinato
//
//  Created by patron on 2/12/26.
//

import SwiftUI

//make image name a variable that can be changed
//make text name a variable that can be changed
//create an index of 0, 1, 2
//use if-else-statement to decide weather pattern for us


struct ContentView: View {
    //define state variable
    @State private var weatherImage = ""
    @State private var weatherMessage = ""
    @State private var weatherIndex: Int = 0
    
    var body: some View {
        VStack {
            Image(systemName:
                    "weatherImage")
            .resizable()
            .aspectRatio(
                contentMode: .fit)
            .symbolEffect(
                .breathe)
            .frame(
                width: 200, height: 200)
            .foregroundStyle(
                Color.orange)
            .padding()
            
            Text("weatherMessage")
                .font(.largeTitle)
                .fontWeight(.medium)
                .foregroundStyle(.blue)
                .padding()
            
            //Create a button
            Button("Weather for Tomorrow") {
                //code the behavior of the button
                if weatherIndex == 0 {
                    weatherImage = "sun.max.fill"
                    weatherMessage = "It will be sunny tomorrow"
                    weatherIndex = 1
                } else if weatherIndex == 1 {
                    weatherImage = "cloud.sun.rain.fill"
                    weatherMessage = "It will be raining tomorrow"
                    weatherIndex = 2
                } else {
                    weatherImage = "cloud.snow.fill"
                    weatherMessage = "It will be snowy tomorrow"
                    weatherIndex = 0
                }
                
                
            }
        }
        .buttonStyle(.borderedProminent)
        .padding()
    } //End VStack
    
    #Preview {
        ContentView()
    }
}
