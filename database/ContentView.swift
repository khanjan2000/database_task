
import SwiftUI



struct ContentView : View {
    //@State var username: String = ""
    @State var hidden = false
    @State var password: String = ""
    @ObservedObject var emailObj = EmailValidationObj()
    @State var isLinkActive = false
    
    @State var authenticationDidFail: Bool = false
    
    

    var body: some View {
        NavigationView{
        VStack {
            WelcomeText()
            Image("User1Image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 150, height: 150)
                .clipped()
                .cornerRadius(150)
                .padding(.bottom, 75)
            TextField("Email", text: $emailObj.email)
                .padding()
                .background(Color.yellow)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            Text(emailObj.error)
                .foregroundColor(.red)
            ZStack{
                HStack{
            if self.hidden
            {
            TextField("Password", text: $password)
                .padding()
                .background(Color.yellow)
                .cornerRadius(5.0)
                .padding(.bottom, 20)
            } else{
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.yellow)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
            }
                    Button(action: {
                        self.hidden.toggle()
                    }) {
                        Image(systemName: self.hidden ? "eye.fill": "eye.slash.fill")
                            .foregroundColor((self.hidden == true) ? Color.green : Color.secondary)
                    }
                    .offset(x: -50, y: -10)
                
            }
            }
            
            
            NavigationLink(destination : HomeView(), isActive: $isLinkActive){
            Button(action: {
                self.isLinkActive = true
            })
            {
                LoginButtonContent()
            }
            
            
            }
            .disabled(password.isEmpty || emailObj.email.isEmpty)
        }
        .padding()
        }
    }
}

struct WelcomeText : View {
    var body: some View{
        return Text("Welcome")
    }
}

struct LoginButtonContent : View {
    var body: some View{
        return Text("Login")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.green)
            .cornerRadius(15.0)
    }
}

class EmailValidationObj: ObservableObject {
    @Published var email = "" {
        didSet{
            if self.email.isEmpty{
                self.error = "required"
            } else if !self.email.isValidEmail() {
                self.error = "Invalid Email"
            } else {
                self.error = ""
            }
        }
    }
    
    @Published var error = ""
}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
