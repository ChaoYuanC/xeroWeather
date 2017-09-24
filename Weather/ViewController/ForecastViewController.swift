//
//  ForecastViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

class ForecastViewController: BaseViewController, WeatherVCProtocol {
    
    @IBOutlet var scrollView: UIScrollView!
    
    private let hourlyWidth: CGFloat = 60.0
    private let hourlyHeight: CGFloat = 200.0
    private let hourlyCurveMinY: CGFloat = 35.0
    private let hourlyCurveMaxY: CGFloat = 100.0
    private let hourlyCurveStartX: CGFloat
    private let hourlyCurveHeight: CGFloat
//    private lazy var hourlyUnitHeight: CGFloat = {
//        return self.unit(self.hourlyData)
//    }()

    private var hourlyData: Array<ForecastHourly> = []
    
    required init?(coder aDecoder: NSCoder) {
        self.hourlyCurveStartX = self.hourlyWidth/2
        self.hourlyCurveHeight = self.hourlyCurveMaxY - self.hourlyCurveMinY
        super.init(coder: aDecoder)
    }
    
    var cityId: Int64 = 0 {
        didSet {
            if self.isViewLoaded {
                self.reloadWeather(cityId)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.reloadWeather(cityId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -
    
    func reloadWeather(_ id: Int64) {
//        self.mainSectionView.isHidden = true
//        self.detailSectionView.isHidden = true
        self.hideloadingView(false)
        WebService.sharedInstance.forecaset(id) { (result, message) in
            self.hideloadingView(true)
            if let result = result {
                print(result)
                self.setForecastView(result.hourly)
            } else if let message = message {
                self.showAlerWith(message)
            }
        }
    }

    
    // MARK: - set hourly views
    
    func setForecastView(_ hourlyArray: Array<ForecastHourly>) {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        self.scrollView.contentSize = CGSize(width: self.hourlyWidth *  CGFloat(hourlyArray.count), height: self.hourlyHeight)
        
        for index in 0...hourlyArray.count-1 {
            let hourlyView = HourlyView.fromNib()
            hourlyView.frame = CGRect(x: self.hourlyWidth * CGFloat(index), y: 0.0, width: self.hourlyWidth, height: self.hourlyHeight)
            hourlyView.setHourlyData(hourlyArray[index])
            self.scrollView.addSubview(hourlyView)
        }
        
        let param = self.unitHeightAndMinTemp(hourlyArray)
        self.drawTempCurve(hourlyArray, param.0, minTemp: param.1)
    }


    // MARK: - set bezier
    
    func midPoint(_ p0: CGPoint, _ p1: CGPoint) -> CGPoint {
        return CGPoint(x: (p0.x + p1.x) / 2.0, y: (p0.y + p1.y) / 2.0)
    }
    
    func unitHeightAndMinTemp(_ hourlyData: Array<ForecastHourly>) -> (CGFloat, CGFloat){
        let array = hourlyData.sorted { (hourly0, hourly1) -> Bool in
            return hourly0.main.tempFloat < hourly1.main.tempFloat
        }
        guard let hourlyMin = array.first else {
            return (0.0, 0.0)
        }
        guard let hourlyMax = array.last else {
            return (0.0, 0.0)
        }

        let gap = hourlyMax.main.tempFloat - hourlyMin.main.tempFloat
        return (self.hourlyCurveHeight/CGFloat(gap), CGFloat(hourlyMin.main.tempFloat))
    }
    
    func drawTempCurve(_ hourlyData: Array<ForecastHourly>, _ unitHeight: CGFloat, minTemp: CGFloat) {
        let path = UIBezierPath()
        
        var previousPoint: CGPoint = CGPoint(x: 0, y: 0)
        for index in 0...hourlyData.count - 1 {
            let temp = hourlyData[index].main.tempFloat
            let tempString = hourlyData[index].main.temp
            let y = self.hourlyCurveMaxY - (CGFloat(temp) - minTemp) * unitHeight 
            let x = self.hourlyCurveStartX + self.hourlyWidth * CGFloat(index)
            let point = CGPoint(x: x, y: y)

            // set fist point
            if index == 0 {
                path.move(to: point)
            } else {
                path.move(to: previousPoint)
                path.addQuadCurve(to: point, controlPoint: self.midPoint(previousPoint, point))
            }
            previousPoint = point
            
            // draw dot
            let dotLayer = CAShapeLayer()
            let dotPath = UIBezierPath(roundedRect: CGRect(x: previousPoint.x - 3, y: previousPoint.y - 3, width: 8, height: 8), cornerRadius: 18)
            dotLayer.path = dotPath.cgPath
            dotLayer.strokeColor = UIColor.red.cgColor
            dotLayer.fillColor = UIColor.red.cgColor
            self.scrollView.layer.addSublayer(dotLayer)
            
            // draw temp label
            let tempLabel = UILabel(frame: CGRect(x: previousPoint.x - 30, y: previousPoint.y - 25, width: 60, height: 20))
            tempLabel.textAlignment = .center
            tempLabel.font = UIFont.systemFont(ofSize: 10)
            tempLabel.text = tempString
            self.scrollView.addSubview(tempLabel)
        }
        
        // draw line
        let bezierLineLayer = CAShapeLayer()
        bezierLineLayer.path = path.cgPath
        bezierLineLayer.strokeColor = UIColor.red.cgColor
        bezierLineLayer.fillColor = UIColor.clear.cgColor
        bezierLineLayer.lineWidth = 3
        bezierLineLayer.lineCap = kCALineCapRound
        bezierLineLayer.lineJoin = kCALineJoinRound
        self.scrollView.layer.addSublayer(bezierLineLayer)
    }
    
    func controlPoints(_ p0: CGPoint, _ p1: CGPoint) -> (CGPoint, CGPoint) {
        let midPoint = self.midPoint(p0, p1)
        let controlPoint0 = CGPoint(x: p0.x, y: midPoint.y)
        let controlPoint1 = CGPoint(x: midPoint.x, y: p1.y)
        return (controlPoint0, controlPoint1)
    }
    
    
    
    func test() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 35))   //(x: 60, y: 70) // 30, 52.5
        let p1 = CGPoint(x: 35, y: 30)
        let p2 = CGPoint(x: 52.5, y: 60)

        path.addCurve(to: CGPoint(x: 60, y: 70), controlPoint1: p1, controlPoint2: p2)
        
        let _bezierLineLayer = CAShapeLayer()
        _bezierLineLayer.path = path.cgPath;
        _bezierLineLayer.strokeColor = UIColor.red.cgColor;
        _bezierLineLayer.fillColor = UIColor.clear.cgColor;
        _bezierLineLayer.lineWidth = 3;
        _bezierLineLayer.lineCap = kCALineCapRound;
        _bezierLineLayer.lineJoin = kCALineJoinRound;
        self.scrollView.layer.addSublayer(_bezierLineLayer)
    }
}


