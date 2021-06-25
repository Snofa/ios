//
//  ChartView.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import SwiftUI
import SwiftUICharts

struct ChartView: View {
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Invoice>

    let month = [1,2,3,4,5,6,7,8,9,10,11,12]
    @State var pickMonth = Calendar.current.component(.month, from: Date())

    var body: some View {
        NavigationView{
        Form {
            
            Section(header: Text("Chart month")){
                Picker("Month", selection: $pickMonth)  {
                    ForEach(month,id: \.self ){ temp in
                        Text(getMonthName(numberOfMonth: temp)).tag(temp)
                    }

                }
                LineChartView(data: balanceForMonth(pickMonth: pickMonth), title: getMonthName(numberOfMonth: pickMonth))
                    .padding(.leading, 65.0)  // error when no trasaction
            }
            Section(header: Text("Chart year")){

                BarChartView(
                    data: ChartData(values:balanceForYear()),
                    title: "Bar chart"
                )
                .padding(.leading, 65.0)
                
            }
        
        }
        }
        .padding(2.0)
}
    
    
    func balanceForYear() -> [(month:String , balance: Double)] {
        var results:[(month: String,balance: Double)] = []
        var result: Double = 0.0
      
        for m in month {
            result = balanceForMonth(pickMonth: m).last ?? 0.00
            results += [(getMonthName(numberOfMonth: m), result)]
        }
        
        return results
    }
    
    
    
    func balanceForMonth(pickMonth:Int) -> Array<Double> {
        var result: Double = 0.0
        var results: [Double] = []
        for task in tasks {
            let calendarDate = Calendar.current.dateComponents([.day, .month, .year], from: task.date ?? Date())
            if calendarDate.year == Calendar.current.component(.year, from: Date()) {
                if(calendarDate.month == pickMonth){
                    if task.type == "income" {
                        result += task.money
                    }else {
                        result -= task.money
                    }
                    results += [result]
                    
                }
                
            }
            
            
        }
    
        return results
    }
    
    func getMonthName(numberOfMonth: Int) -> String {
        switch numberOfMonth {
        case 1: return "Junuary"
        case 2: return "February"
        case 3: return "March"
        case 4: return "April"
        case 5: return "May"
        case 6: return "June"
        case 7: return "Jule"
        case 8: return "August"
        case 9: return "September"
        case 10: return "October"
        case 11: return "November"
        case 12: return "December"
        default:
            return "Error"
        }
        
    }
  
  
        }
    
    


struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}
