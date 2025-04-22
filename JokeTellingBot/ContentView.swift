//
//  ContentView.swift
//  Joke telling bot
//
//  Created by Billie H on 16/04/25.
//

import SwiftUI
import AVFoundation
struct ContentView: View {
    let synthesiszer = AVSpeechSynthesizer()
    let voices = AVSpeechSynthesisVoice.speechVoices()
    @State var path = NavigationPath()
    @State private var language = "en-GB"
    @State private var name = "Daniel"
    var body: some View {
        NavigationStack{
            VStack(alignment: .center){
                HStack{
                    Spacer()
                    let languages = Array(Set(voices.map(\.language))).sorted()
                    Picker("Language", selection: $language){
                        ForEach(languages, id: \.self){voice in
                            Text(voice)
                                .tag(voice)
                        }
                    }
                    Spacer()
                    Spacer()
                    let name = voices.filter{$0.language == language}.map(\.name)
                    Picker("Name", selection: $name){
                        ForEach(name, id:\.self){name in
                            Text(name)
                                .tag(name)
                        }
                    }
                    Spacer()
                }
                .pickerStyle(.menu)
                Spacer()
                Image(.bot1)
                    .resizable()
                    .scaledToFit()
                Button ("Tell Me A Joke"){
                    Task{
                        await generateJoke()
                    }
                }
                .font(.title.bold())
                .padding(10)
                .buttonStyle(.borderedProminent)
                Spacer()
            }
            .onChange(of: language){
                name = voices.first(where: {$0.language == language})?.name ?? "Daniel"
            }
            
        }
        
    }
    func generateJoke() async{
        guard let joke = Data.jokeList.randomElement()
        else{return}
        do{
            talk(str: joke[0])
            try await Task.sleep(for: .seconds(2))
            talk(str: joke[1])
        }catch{
            print(error.localizedDescription)
        }
    }
    func talk(str : String){
        let utterance = AVSpeechUtterance(string: str)
        utterance.voice = currentVoice
        synthesiszer.speak(utterance)
    }
    var currentVoice:AVSpeechSynthesisVoice?{
        voices.filter{voice in
            voice.language == language && voice.name == name
        }.first
    }
}

#Preview {
    ContentView()
}
