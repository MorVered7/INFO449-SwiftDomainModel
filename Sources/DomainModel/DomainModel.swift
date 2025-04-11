struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount: Int
    var currency: String
    
    static func toUSD(_ curr: String) -> Double {
        switch curr {
        case "USD":
            return 1.0
        case "GBP":
            return 2.0
        case "EUR":
            return 2.0 / 3.0
        case "CAN":
            return 0.8
        default: return 0.0
        }
    }
    
    static func fromUSD(_ curr: String) -> Double {
        switch curr {
        case "USD":
            return 1.0
        case "GBP":
            return 0.5
        case "EUR":
            return 1.5
        case "CAN":
            return 1.25
        default: return 0.0
        }
    }
    
    func acceptableCurrency(curr: String) -> Bool {
        return curr == "USD" || curr == "GBP" || curr == "EUR" || curr == "CAN"
    }
    
    //takes a currency name as a parameter and returns a new Money that contains the converted amount,
    func convert(_ newCurr: String) -> Money {
        if !acceptableCurrency(curr: newCurr) {
            return Money(amount: -1, currency: "Invalid Currency")
        }
        let toUSD = Money.toUSD(self.currency)
        let fromUSD = Money.fromUSD(newCurr)
        
        var temp = Double(self.amount) * toUSD
        temp = temp * fromUSD
        return Money(amount: Int(temp), currency: newCurr)
    }
    func add(_ m2: Money) -> Money {
        //take a Money as a parameter and returns a new Money that contains the addition
        if !acceptableCurrency(curr: m2.currency) {
            return Money(amount: -1, currency: "Invalid Currency")
        }
        //convert both m2 and self to USD
        let m2Rate = Money.toUSD(m2.currency)
        let selfRate = Money.toUSD(self.currency)
        
        let m2USD = Double(m2.amount) * m2Rate
        let selfUSD = Double(self.amount) * selfRate
        
        //add the two and save as result
        var result = m2USD + selfUSD
        
        //convert to m2 original currency
        let fromUSD = Money.fromUSD(m2.currency)
        result = result * fromUSD
        //create a new money with (amount:, currency: m2.currency)
        return Money(amount: Int(result), currency: m2.currency)
    }
    func subtract(_ m2: Money) -> Money {
        if !acceptableCurrency(curr: m2.currency) {
            return Money(amount: -1, currency: "Invalid Currency")
        }
        let m2Rate = Money.toUSD(m2.currency)
        let selfRate = Money.toUSD(self.currency)
        
        let m2USD = Double(m2.amount) * m2Rate
        let selfUSD = Double(self.amount) * selfRate
        
        var result = selfUSD - m2USD
        
        let fromUSD = Money.fromUSD(m2.currency)
        result = result * fromUSD
        
        return Money(amount: Int(result), currency: m2.currency)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    let title: String
    var type: JobType
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    public init(title: String, type: JobType){
        self.title = title
        self.type = type
    }
    
    //calculateIncome (need to deal with double vs int)
    func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case .Hourly(let num):
            return Int(num * Double(hours))
        case .Salary(let num):
            return Int(num)
        }
    }
    //raise(byAmount: Double)
    func raise(byAmount: Double){
        switch type {
        case .Hourly(let num):
            self.type = .Hourly(num + byAmount)
        case .Salary(let num):
            self.type = .Salary(num + UInt(byAmount))
        }
    }
    //raise(byPercent: Double)
    func raise(byPercent: Double){
        switch type {
        case .Hourly(let num):
            self.type = .Hourly((num * byPercent) + num)
        case .Salary(let num):
            self.type = .Salary(UInt(Double(num) * byPercent) + num)
        }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    var job: Job?
    var spouse: Person?
    
    public init(firstName: String, lastName: String, age: Int){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
        self.job = nil
        self.spouse =  nil
    }
    
    //[Person: firstName: Ted lastName: Neward age: 45 job: Salary(1000) spouse: Charlotte]
    func toString() -> String {
        var result = "Person: firstName: \(firstName) lastName: \(lastName) age: \(age)"
        //if job doesnt exist
        if let xjob = job {
            result += "job: \(xjob)"
        }
        //if spouse doesnt exist
        if let xspouse = spouse {
            result += "spouse \(xspouse)"
        }
        return result
    }
    
    ////////////////////////////////////
    // Family
    //
    public class Family {
        var members: [Person]
        
        public init(spouse1: Person, spouse2: Person){
            self.members = []
            if spouse1.spouse == nil && spouse2.spouse == nil {
                spouse1.spouse = spouse2
                spouse2.spouse = spouse1
                self.members = [spouse1, spouse2]
            }
        }
        func haveChild(_ child: Person) -> Bool {
            if members[0].age >= 21 || members[1].age >= 21 {
                members.append(child)
                return true
            }
            return false
        }
        
        func householdIncome() -> Int {
            var income = 0
            for x in members {
                if let job = x.job {
                    income += job.calculateIncome(50)
                }
            }
            return income
        }
    }
}
