//
//  ChartViewController.swift
//  GJU
//
//  Created by wajdi muhtadi on 8/10/19.
//  Copyright © 2019 wajdi muhtadi. All rights reserved.
//

import UIKit
import Charts
import ValueAnimator
class ChartViewController: UIViewController {
    @IBOutlet var background: UIView!
    @IBOutlet weak var bchart: BarChartView!
    var semesters:[String]? = nil
    var results:[Double]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        var datasets:[IChartDataSet] = []
        for i in 0...(semesters!.count - 1) {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(results![i]))
            let chartDataSet = BarChartDataSet(entries: [dataEntry], label: semesters![i])
            if(i % 2 == 0){
                chartDataSet.setColor(UIColor.init(red: 243.0/255.0, green: 128.0/255.0, blue: 19.0/255.0, alpha: 1.0))
            }else{
                chartDataSet.setColor(UIColor.init(red: 13.0/255.0, green: 135.0/255.0, blue: 201.0/255.0, alpha: 1.0))
            }
            chartDataSet.valueTextColor = UIColor.white
            chartDataSet.valueFormatter = DefaultValueFormatter(decimals: 1)
            chartDataSet.valueFont = .boldSystemFont(ofSize:(CGFloat(60 * 0.85/Double(semesters!.count))))
            datasets.append(chartDataSet)
        }
        let chartData = BarChartData(dataSets: datasets)
        bchart.data = chartData
        bchart.legend.xOffset = 0.0
        bchart.legend.xEntrySpace = 10.0
        bchart.legend.font = .boldSystemFont(ofSize: bchart.legend.font.pointSize)
        bchart.noDataTextColor = UIColor.white
        bchart.xAxis.drawGridLinesEnabled = false
        bchart.xAxis.drawAxisLineEnabled = false
        bchart.rightAxis.drawGridLinesEnabled = false
        bchart.leftAxis.drawGridLinesEnabled = false
        bchart.rightAxis.drawAxisLineEnabled = false
        bchart.leftAxis.drawAxisLineEnabled = false
        bchart.rightAxis.drawLabelsEnabled = false
        bchart.leftAxis.drawLabelsEnabled = false
        bchart.rightAxis.gridColor = UIColor.red
        bchart.legend.textColor = UIColor.white
        bchart.legend.horizontalAlignment = .center
        bchart.xAxis.labelTextColor = UIColor.clear
        if(bchart.leftAxis.axisMinimum < 0){
            bchart.leftAxis.axisMinimum = 0.0
        }
        bchart.chartAnimator.phaseY = bchart.leftAxis.axisMinimum/bchart.leftAxis.axisMaximum
        bchart.legend.form = .circle
        bchart.legend.formSize = 6.0
    }
    @IBAction func outtap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closetap(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        }) { _ in
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.55)
        }, completion: { _ in
            let ani = ValueAnimator.animate("count", from: self.bchart.leftAxis.axisMinimum, to: self.bchart.leftAxis.axisMaximum, duration: 1.5, easing: EaseExponential.easeOut()) { p, v in
                let intValue = v.value
                self.bchart.chartAnimator.phaseY = intValue/(self.bchart.leftAxis.axisMaximum)
                self.bchart.notifyDataSetChanged()
                
            }
            ani.resume()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
