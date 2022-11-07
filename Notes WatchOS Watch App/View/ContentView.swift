//
//  ContentView.swift
//  Notes WatchOS Watch App
//
//  Created by Vlad V on 06.11.2022.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - Property
    
    @State private var notes = [Note]()
    @State private var text: String = ""
    
    //MARK: - Function
    func getDocumentDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    func save(){
        //dump(notes)
        do{
            let data = try JSONEncoder().encode(notes)
            
            let url = getDocumentDirectory().appendingPathComponent("notes")
            
            try data.write(to: url)
        } catch {
            print("Saving Data failed")
        }
    }
    
    func load(){
        DispatchQueue.main.async {
            do{
                let url = getDocumentDirectory().appendingPathComponent("notes")
                
                let data = try Data(contentsOf: url)
                
                notes = try JSONDecoder().decode([Note].self, from: data)
                
            } catch {
                // Nothing
            }
        }
    }
    
    func delete(offsets: IndexSet){
        withAnimation {
            notes.remove(atOffsets: offsets)
            save()
        }
    }
    
    //MARK: - Body
    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 6) {
                TextField("Add New Node", text: $text)
                Button {
                    guard text.isEmpty == false else {return}
                    
                    let note = Note(id: UUID(), text: text)
                    
                    notes.append(note)
                    
                    text = ""
                    
                    save()
                    
                } label: {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 42, weight: .semibold))
                }
                .fixedSize()
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.accentColor)
                //.buttonStyle(BorderedButtonStyle(tint: .accentColor))
            }
            Spacer()
            
            if notes.count >= 1 {
                List{
                    ForEach(0 ..< notes.count, id: \.self) { i in
                        HStack{
                            Capsule()
                                .frame(width: 4)
                                .foregroundColor(.accentColor)
                            Text(notes[i].text)
                                .lineLimit(1)
                                .padding(.leading, 5)
                        }
                    }
                    .onDelete(perform: delete)
                }
            } else {
                Spacer()
                Image(systemName: "note.text")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
                    .opacity(0.25)
                    .padding(20)
                Spacer()
            }
            //Text("\(notes.count)")
            
        }
        .navigationTitle("Notes")
        .onAppear {
            load()
        }
    }
}


//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
