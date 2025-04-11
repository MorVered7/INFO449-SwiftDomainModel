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
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
}

////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    
    public init(firstName: String, lastName: String, age: Int){
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
}

////////////////////////////////////
// Family
//
public class Family {
}
