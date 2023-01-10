//
//  UIHelper.swift
//  LightsOut
//
//  Created by Murat Baykor on 8.06.2022.
//

import UIKit

struct UIHelper {

    enum SettingsSection {
        case userSettings, gameSettings, aboutGame
    }
    
    static func createOnlineRecordVCLayout(isHeaderOn: Bool = false) -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        group.contentInsets.top = Constants.globalPadding / 2
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = Constants.globalPadding
        section.contentInsets.trailing = Constants.globalPadding

        if isHeaderOn {
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        }
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    static func createLocalRecordVCLayout(isHeaderOn: Bool = true) -> UICollectionViewCompositionalLayout {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(100)), subitems: [item])
        group.contentInsets.top = Constants.globalPadding / 2
       // group.contentInsets.bottom = 5
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets.leading = Constants.globalPadding
        section.contentInsets.trailing = Constants.globalPadding
        
        if isHeaderOn {
            section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .topLeading)]
        }

        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    
    
    
    static func createLeagueVCLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env in
            
            if sectionNumber == 0 || sectionNumber == 1 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.15)), subitems: [item])
                group.contentInsets.leading = Constants.globalPadding
                group.contentInsets.trailing = Constants.globalPadding
                group.contentInsets.bottom = Constants.globalPadding
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.50), heightDimension: .absolute(100)))
                
                item.contentInsets.trailing = Constants.globalPadding
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(100)), subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                
                section.contentInsets.trailing = Constants.globalPadding
                section.contentInsets.top = Constants.globalPadding / 2
                
                section.boundarySupplementaryItems = [.init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: Constants.HeaderReuseID.leagueCategoryHeader, alignment: .topLeading)
                ]
                return section
            }
        }
    }
    
    static func configureNumberOfRowsInSection(_ sectionNumber: Int) -> Int {
        switch sectionNumber {
        case 0:
            return Constants.ItemCounts.settingsVCSection0
        case 1:
            return Constants.ItemCounts.settingsVCSection1
        case 2:
            return Constants.ItemCounts.settingsVCSection2
        default:
            return 0
        }
    }
    
    static func configureSectionsTitle(_ sectionNumber: Int) -> String? {
        switch sectionNumber {
        case 0:
            return nil
        case 1:
            return LocalizedStrings.gameSettings
        case 2:
            return LocalizedStrings.aboutGame
        default:
            return ""
        }
    }
    
    
    static func configureCells(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        let cell2 = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        cell2.accessoryType = .disclosureIndicator
        
        var cellTitle = ""
        var cellSubtitle = ""
        
        let isPro = UserDefaults.standard.bool(forKey: Constants.Keys.getPro)
        
        switch indexPath {
        case [0, 0]: // Pro cell
            if isPro {
                cellTitle = LocalizedStrings.proCell
                cellSubtitle = LocalizedStrings.proCellSub
                cell.accessoryType = .none
            } else {
                cellTitle = LocalizedStrings.becomeProCell
                cellSubtitle = LocalizedStrings.becomeProCellSub
            }
        case [0, 1]:
            cellTitle = LocalizedStrings.statisticsCell
            cellSubtitle = LocalizedStrings.statisticsCellSub
        case [1, 0]:
            cellTitle = LocalizedStrings.soundEffectCell
            if UserDefaults.standard.bool(forKey: Constants.Keys.soundSettings) {
                cellSubtitle = LocalizedStrings.soundEffectOn
            } else {
                cellSubtitle = LocalizedStrings.soundEffectOff
            }
        case [2, 0]:
            cellTitle = LocalizedStrings.aboutGameCell
        case [2, 1]:
            cellTitle = LocalizedStrings.rateCell
        case [2,2]:
            cellTitle = LocalizedStrings.contactCell
        case [2, 3]:
            cellTitle = LocalizedStrings.shareCell
        default:
            cellTitle = "Hello"
        }
    
        var content = cell.defaultContentConfiguration()
        content.text = cellTitle
        content.secondaryText = cellSubtitle
        content.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .light)
        content.secondaryTextProperties.color = UIColor.systemGray
        
        cell.contentConfiguration = content
        
        var content2 = cell2.defaultContentConfiguration()
        content2.text = cellTitle
        content2.secondaryText = cellSubtitle
        content2.secondaryTextProperties.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        content2.secondaryTextProperties.color = UIColor.systemGray
        cell2.contentConfiguration = content2
        
        
        if indexPath == [1, 0] || indexPath == [1,1] || indexPath == [1,3] {
            return cell2
        } else {
            return cell
        }
    }
}
