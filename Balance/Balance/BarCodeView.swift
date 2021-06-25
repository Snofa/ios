//
//  BarCodeView.swift
//  Balance
//
//  Created by student on 22.06.2021.
//

import SwiftUI
import CarBode
import AVFoundation

struct BarCodeView: View {
    @State var valueCode:String = ""
    var body: some View {
           VStack{

            CBScanner(
                    supportBarcode: .constant([.code128]), //Set type of barcode you want to scan
                    scanInterval: .constant(5.0), //Event will trigger every 5 seconds
                mockBarCode: .constant(BarcodeData(value:"4820024700016", type: .code128))
                ){
                    //When you click the button on screen mock data will appear here
                    print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                valueCode = $0.value
                }

           CBScanner(
                   supportBarcode: .constant([.code128]), //Set type of barcode you want to scan
                   scanInterval: .constant(5.0) //Event will trigger every 5 seconds
               ){
                   //When the scanner found a barcode
                   print("BarCodeType =",$0.type.rawValue, "Value =",$0.value)
                   valueCode = $0.value
               }
               onDraw: {
                   print("Preview View Size = \($0.cameraPreviewView.bounds)")
                   print("Barcode Corners = \($0.corners)")

                   let lineWidth = 2

                   let lineColor = UIColor.red

                   let fillColor = UIColor(red: 0, green: 1, blue: 0.2, alpha: 0.4)

                $0.draw(lineWidth: CGFloat(lineWidth), lineColor: lineColor, fillColor: fillColor)
               }
            Text("\(valueCode)")
            if(checkFake(str: valueCode)){
                Text ("Its original")
            }else{
                Text ("Its fake")
            }
            
            
       }
        
    }
    func checkFake(str:String) -> Bool {
        var intArray: [Int] = []
        for chr in str {
            intArray.append(String(chr).toInt() ?? 0)
        }
        if(intArray.count != 13){
            return false
        }
        var index:Int = 1
        var result:Int = 0
        var temp:Int = 0
        for digit in intArray {
            if index % 2 == 0 {
                result += digit
            }
            index += 1
        }
        result = result * 3
        index = 1
        let checkSum = intArray.popLast()
        for digit in intArray {
            if index % 2 != 0 {
                temp += digit
            }
            index += 1
        }
        result = result + temp
        let fisrt: Int = result - (Int(result/10) * 10 )
        
        
        if (10-fisrt == checkSum) {
            return true
        }else{
            return false
        }
    
    }
}
extension String {
    func toInt() -> Int? {
        return Int(self)
    }
}

struct BarCodeView_Previews: PreviewProvider {
    static var previews: some View {
        BarCodeView()
    }
}
