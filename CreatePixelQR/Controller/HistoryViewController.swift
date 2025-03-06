//
//  HistoryViewController.swift
//  CreatePixelQR
//
//  Created by 백현진 on 12/18/24.
//
import UIKit

class HistoryViewController: UIViewController {
    let halfSizeTransitioningDelegate = HalfSizeTransitioningDelegate()
    
    let cellName = "HistoryTableViewCell"
    let cellReuseIdentifier = "HistoryTableViewCell"
    
    var historyItems: [QRHistory] = []
    var filteredItems: [QRHistory] = []
    
    var filterCase: Int = 0
    
    @IBOutlet var historyView: HistoryView!
    private let emptyStateView = UIView()
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        historyView.historySetting()
        self.historyItems = QRHistoryManager.shared.loadHistory()
        
        filterData(for: 0)
        
        setupEmptyStateView()
        updateEmptyStateVisibility()
        
        historyView.filterButton.showsMenuAsPrimaryAction = true
        historyView.filterButton.menu = createMenu()
        
        setupRefreshControl()
    }
    
    // RefreshControl 설정
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.tintColor = CustomColor.backgroundColor.color // 로딩 인디케이터 색상 설정
        refreshControl.attributedTitle = NSAttributedString(string: "데이터 새로고침 중...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        
        // TableView에 RefreshControl 연결
        historyView.historyTableView.refreshControl = refreshControl
    }
    
    // 실제 데이터 리로드 메서드
    @objc private func refreshTableView() {
        self.historyItems = QRHistoryManager.shared.loadHistory()
        print("🔄 테이블 뷰 새로고침 시작")
        
        // 인디케이터 표시
        refreshControl.beginRefreshing()
        
        // 2초간 가짜 데이터 로딩 시뮬레이션 (예: API 호출)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.filterData(for: self.filterCase)
            self.refreshControl.endRefreshing() // 로딩 인디케이터 종료
            print("✅ 새로고침 완료")
        }
    }
    
    func createMenu() -> UIMenu {
        let actionArray: [UIAction] = [
            UIAction(title: "스캔한 QR만 보기", image: UIImage(systemName: "qrcode.viewfinder"), handler: { [weak self] _ in
                self?.filterScannedData()
            }),
            UIAction(title: "제작한 QR만 보기", image: UIImage(systemName: "qrcode"), handler: { [weak self] _ in
                self?.filterGenerateData()
            }),
            
            UIAction(title: "전체 보기", image: nil, handler: { [weak self] _ in
                self?.resetData()
            })
        ]
        
        return UIMenu(title: "QR 필터", children: actionArray)
    }
    
    func registerXib() {
        let nibName = UINib(nibName: cellName, bundle: nil)
        historyView.historyTableView.register(nibName, forCellReuseIdentifier: cellReuseIdentifier)
        historyView.historyTableView.delegate = self
        historyView.historyTableView.dataSource = self
    }
    
    // MARK: Empty State View 설정
    private func setupEmptyStateView() {
        emptyStateView.backgroundColor = .clear
        emptyStateView.isHidden = true // 초기 상태는 숨김
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        // 레이블 추가
        let messageLabel = UILabel()
        messageLabel.text = "아직 기록이 없습니다! 😭"
        messageLabel.textColor = CustomColor.backgroundColor.color
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.addSubview(messageLabel)
        
        // UIView 추가
        view.addSubview(emptyStateView)
        
        // AutoLayout 설정
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: historyView.historyTableView.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: historyView.historyTableView.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalTo: historyView.historyTableView.widthAnchor),
            emptyStateView.heightAnchor.constraint(equalTo: historyView.historyTableView.heightAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor)
        ])
    }
    
    // MARK: Empty State View 업데이트
    private func updateEmptyStateVisibility() {
        emptyStateView.isHidden = !filteredItems.isEmpty
    }
    
    func formatDateWithAmPm(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy-MM-dd a hh:mm"
        return dateFormatter.string(from: date)
    }
    
    // 데이터 필터링
    func filterData(for category: Int) {
        switch category {
        case 0:
            filterCase = 0
            filteredItems = historyItems
        case 1:
            filterCase = 1
            filteredItems = historyItems.filter { $0.type == .wifi }
        case 2:
            filterCase = 2
            filteredItems = historyItems.filter { $0.type == .url }
        case 3:
            filterCase = 3
            filteredItems = historyItems.filter { $0.type == .phone }
        case 4:
            filterCase = 4
            filteredItems = historyItems.filter { $0.type == .text }
        case 5:
            filterCase = 5
            filteredItems = historyItems.filter { $0.type == .email }
        default:
            filteredItems = []
        }
        
        // 날짜 순 정렬 (최신 항목이 상단)
        reloadTableViewData()
    }
    
    
    
    func reloadTableViewData() {
        filteredItems.sort { $0.date > $1.date }
        historyView.historyTableView.reloadData()
    }
    
    func filterScannedData() {
        filteredItems = historyItems.filter { $0.action == .scanned }
        
        // 날짜 순 정렬 (최신 항목이 상단)
        reloadTableViewData()
    }
    
    func filterGenerateData() {
        filteredItems = historyItems.filter { $0.action == .generated }
        
        // 날짜 순 정렬 (최신 항목이 상단)
        reloadTableViewData()
    }
    
    func resetData() {
        filteredItems = historyItems
        // 날짜 순 정렬 (최신 항목이 상단)
        reloadTableViewData()
        
    }
    
    
    
    func parseWiFiData(_ data: String) -> (ssid: String, password: String, security: String, hidden: Bool)? {
        guard data.hasPrefix("WIFI:") else { return nil }
        
        let components = data
            .replacingOccurrences(of: "WIFI:", with: "")
            .components(separatedBy: ";")
        
        var ssid = ""
        var password = ""
        var security = "WPA" // 기본값
        var hidden = false
        
        for component in components {
            if component.hasPrefix("S:") {
                ssid = component.replacingOccurrences(of: "S:", with: "")
            } else if component.hasPrefix("P:") {
                password = component.replacingOccurrences(of: "P:", with: "")
            } else if component.hasPrefix("T:") {
                security = component.replacingOccurrences(of: "T:", with: "")
            } else if component.hasPrefix("H:") {
                hidden = component.replacingOccurrences(of: "H:", with: "") == "true"
            }
        }
        return (ssid, password, security, hidden)
    }
    
    @IBAction func caseSegmentControlTapped(_ sender: UISegmentedControl) {
        filterData(for: sender.selectedSegmentIndex)
        
        if sender.selectedSegmentIndex != 0 {
            historyView.filterButton.isEnabled = false
        } else {
            historyView.filterButton.isEnabled = true
        }
        
        updateEmptyStateVisibility()
    }
    
    // MARK: 액션 메서드
    func showDetails(for index: Int) {
        let target = filteredItems[index]
        let alertController = UIAlertController(
            title: "자세히 보기",
            message: """
             타입: \(target.type.rawValue)
             내용: \(target.content)
             날짜: \(formatDateWithAmPm(date: target.date))
             """,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(title: "닫기", style: .cancel))
        present(alertController, animated: true)
    }
    
    func deleteItem(at index: Int) {
        // 데이터 삭제
        let target = filteredItems[index]
        QRHistoryManager.shared.deleteSpecificHistory(by: target.id)
        filteredItems.remove(at: index)
        
        // TableView 갱신
        historyView.historyTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        
        self.historyItems = QRHistoryManager.shared.loadHistory()
        historyView.historyTableView.reloadData()
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryTableViewCell", for: indexPath) as! HistoryTableViewCell
        let target = filteredItems[indexPath.row]
        let stringTarget = String(describing: target.type)
        
        //cell.mainLabel.text = target.content
        cell.typeLabel.text = target.type.rawValue
        
        if target.action == .generated {
            cell.dateLabel.text = "생성 날짜: \(formatDateWithAmPm(date: target.date))"
        } else {
            cell.dateLabel.text = "탐지 날짜: \(formatDateWithAmPm(date: target.date))"
            cell.dateLabel.textColor = CustomColor.backgroundColor.color
        }
        
        cell.typeImageView.image = UIImage(named: stringTarget + "White32px")
        
        if target.type == .wifi, let wifiInfo = parseWiFiData(target.content) {
            cell.mainLabel.text = """
        SSID: \(wifiInfo.ssid)
        비밀번호: \(wifiInfo.password)
        암호화: \(wifiInfo.security)
        """
        } else {
            cell.mainLabel.text = target.content
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let targetType = filteredItems[indexPath.row].type
        let target = filteredItems[indexPath.row].content
        
        let detailAction = UIContextualAction(style: .normal, title: "QR 만들기") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            //self.showDetails(for: indexPath.row)
            
            if targetType == .wifi {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeWifiViewController") as? MakeWifiViewController else { return }
                
                nextVC.receiveWifiData = target
                //nextVC.categoryCase = destination
                self.navigationController?.pushViewController(nextVC, animated: true)
            } else {
                guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "MakeQRViewController") as? MakeQRViewController else { return }
                
                nextVC.categoryCase = targetType.rawValue
                nextVC.receiveData = target
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
            completionHandler(true) // 액션 완료 표시
        }
        detailAction.backgroundColor = .systemBlue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "삭제") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            self.deleteItem(at: indexPath.row)
            completionHandler(true) // 액션 완료 표시
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, detailAction])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = filteredItems[indexPath.row]
        
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "QRPopViewController") as? QRPopViewController else { return }
        
        nextVC.receiveData = target.content
        nextVC.isCamera = false
        nextVC.modalPresentationStyle = .custom
        nextVC.transitioningDelegate = halfSizeTransitioningDelegate
        
        self.present(nextVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
}
