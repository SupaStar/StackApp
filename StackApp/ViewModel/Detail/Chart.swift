//
//  Chart
//  StackApp
//
//  Created by Obed Martinez on 13/10/23
//



import UIKit

class ChartView: UIView {
    
    var y: [Double] = []
    var x: [String] = []
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        UIColor.white.setFill()
        UIRectFill(rect)
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let margin: CGFloat = 20.0
        let graphWidth = rect.width - 2 * margin
        let graphHeight = rect.height - 2 * margin
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1.0)
        context.move(to: CGPoint(x: margin, y: margin))
        context.addLine(to: CGPoint(x: margin, y: margin + graphHeight))
        context.addLine(to: CGPoint(x: margin + graphWidth, y: margin + graphHeight))
        context.strokePath()
        
        // Draw Axis Y
        let maxY = y.max() ?? 0
        let minY = y.min() ?? 0
        for price in stride(from: minY, through: maxY, by: (maxY - minY) / 5) {
            let priceY = margin + graphHeight * CGFloat(1 - (price - minY) / (maxY - minY))
            let priceString = String(format: "%.2f", price)
            priceString.draw(at: CGPoint(x: 5, y: priceY), withAttributes: nil)
        }
        
        // Draw Axis X
//        for (index, xV) in x.enumerated() {
//            let valueX = margin + graphWidth / CGFloat(x.count - 1) * CGFloat(index)
//            if index == 0{
//                xV.draw(at: CGPoint(x: valueX - 20, y: margin + graphHeight + 10), withAttributes: nil)
//            } else{
//                xV.draw(at: CGPoint(x: valueX - 20, y: margin + graphHeight + 5), withAttributes: nil)
//            }
//        }
        
        for (index, xV) in x.enumerated() {
            let valueX = margin + graphWidth / CGFloat(x.count - 1) * CGFloat(index)
            let yPosition = (index == 0 ? margin + graphHeight + 10 : margin + graphHeight + 5)

            // Guarda el estado del contexto actual
            let context = UIGraphicsGetCurrentContext()
            context?.saveGState()

            // Translada y rota el contexto para dibujar verticalmente
            context?.translateBy(x: valueX, y: yPosition)
            context?.rotate(by: -.pi / 2)

            // Dibuja el texto en el contexto transformado
            xV.draw(at: CGPoint(x: 0, y: 0), withAttributes: nil)

            // Restaura el contexto al estado anterior
            context?.restoreGState()
        }
        
        // Draw chart
        context.setStrokeColor(UIColor.blue.cgColor)
        context.setLineWidth(2.0)
        for (index, yV) in y.enumerated() {
            let valueY = margin + graphHeight * CGFloat(1 - (yV - minY) / (maxY - minY))
            let dateX = margin + graphWidth / CGFloat(x.count - 1) * CGFloat(index)
            if index == 0 {
                context.move(to: CGPoint(x: dateX, y: valueY))
            } else {
                context.addLine(to: CGPoint(x: dateX, y: valueY))
            }
        }
        context.strokePath()
    }
}
