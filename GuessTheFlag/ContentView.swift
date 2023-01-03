//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Orlando Moraes Martins on 20/12/22.
//

import SwiftUI

struct FlagButton: View {
    let number: Int
    let image: String
    let answer: Int
    var showAnimation = false
    let action: () -> ()
    
    @State private var animationAmount = Double.zero
    
    var body: some View{
        Button(action: {
            if self.number == self.answer{
                self.animationAmount += 360
            }
            action()
        }) {
            Image(image)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
                .accessibilityLabel(image, default: "Unknown value")
        }
        .rotation3DEffect(.degrees(number == answer ? self.animationAmount : 0), axis: (x: 0, y: 1, z: 0))
        .opacity(self.showAnimation && number != answer ? 0.25 : 1)
        .scaleEffect(self.showAnimation && number != answer ?  0 : 1, anchor: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        .animation(.default)
    }
}

struct ContentView: View {
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var Countries  = ["France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Spain", "USA"].shuffled()
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var degrees = 3.0
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(Countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        FlagButton(number: number, image: self.Countries[number], answer: correctAnswer){
                            self.flagTapped(number)
                        }
                                            
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(userScore)")
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            userScore += 2
        } else {
            scoreTitle = "Wrong! That''s the flag of \(Countries[number])"
            if userScore == 0{
                userScore = 0
            } else{
                userScore -= 3
                
                if userScore < 0{
                    userScore = 0
                }
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        Countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
