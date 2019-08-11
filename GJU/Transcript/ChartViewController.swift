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
class ChartViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ChartViewDelegate {
    @IBOutlet var background: UIView!
    @IBOutlet weak var bchart: BarChartView!
    @IBOutlet weak var cv: UICollectionView!
    var semesters:[String]? = nil
    var results:[Double]? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        var datasets:[IChartDataSet] = []
        for i in 0...(semesters!.count - 1) {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(results![i]))
            let chartDataSet = BarChartDataSet(entries: [dataEntry], label: semesters![i])
            if(i % 2 == 0){
                chartDataSet.setColor(UIColor.init(red: 243.0/255.0, green: 128.0/255.0, blue: 19.0/255.0, alpha: 1.0).darker(by: CGFloat(2.5 * Double(i)))!)
            }else{
                chartDataSet.setColor(UIColor.init(red: 13.0/255.0, green: 135.0/255.0, blue: 201.0/255.0, alpha: 1.0).darker(by: CGFloat(2.5 * Double(i)))!)
            }
            chartDataSet.valueTextColor = UIColor.white
            chartDataSet.valueFormatter = DefaultValueFormatter(decimals: 1)
            chartDataSet.valueFont = .boldSystemFont(ofSize:(CGFloat(60 * 0.85/Double(semesters!.count))))
            chartDataSet.highlightAlpha = 0.0
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
        bchart.legend.textColor = UIColor.white
        bchart.legend.horizontalAlignment = .center
        bchart.xAxis.labelTextColor = UIColor.clear
        if(bchart.leftAxis.axisMinimum < 0){
            bchart.leftAxis.axisMinimum = 0.0
        }
        bchart.xAxis.labelTextColor = UIColor.white
        bchart.chartAnimator.phaseY = bchart.leftAxis.axisMinimum/bchart.leftAxis.axisMaximum
        bchart.legend.enabled = false
        bchart.xAxis.labelPosition = .bottom
        bchart.xAxis.drawLabelsEnabled = true
        if(semesters!.count <= 6){
            bchart.xAxis.labelFont = .boldSystemFont(ofSize: 22.0)
        }else{
            bchart.xAxis.labelFont = .boldSystemFont(ofSize:(CGFloat(160 * 0.85/Double(semesters!.count))))
        }
        if(semesters!.count > 10){
            bchart.data?.setDrawValues(false)
        }
        bchart.xAxis.labelCount = semesters!.count
        bchart.xAxis.valueFormatter = IndexAxisValueFormatter(values: Array(1...semesters!.count).map { String($0) })
        bchart.xAxis.granularity = 1
        bchart.dragEnabled = false
        bchart.pinchZoomEnabled = false
        bchart.doubleTapToZoomEnabled = false
        bchart.delegate = self
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        cv.scrollToItem(at: IndexPath.init(row: highlight.dataSetIndex, section: 0), at: .centeredVertically, animated: true)
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
        let ani = ValueAnimator.animate("count", from: self.bchart.leftAxis.axisMinimum, to: self.bchart.leftAxis.axisMaximum, duration: 1.5, easing: EaseExponential.easeOut()) { p, v in
            let intValue = v.value
            self.bchart.chartAnimator.phaseY = intValue/(self.bchart.leftAxis.axisMaximum)
            self.bchart.notifyDataSetChanged()
            
        }
        ani.resume()
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [.preferredFramesPerSecond60,.allowUserInteraction], animations: {
            self.background.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.55)
        }, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return semesters!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chartinfocell", for: indexPath) as! chartinfocell
        cell.count.text = String(indexPath.row + 1)
        cell.name.text = semesters![indexPath.row] + " : " + String(results![indexPath.row])
        if(indexPath.row % 2 == 0){
            cell.orange()
        }else{
            cell.blue()
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv.frame.width - 80, height: 45.0)
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
extension UIColor {
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
