# StockInfo

> This is a practice iOS project displaying stock information project with Coordinator pattern, MVVM structure.

|  登入   | 自選股 | 分時走勢 | K線 |
|  ----  | ----  | ----  | ----  |
| ![](https://github.com/H-CLo/StockInfo/assets/13503418/bd8c2027-862f-4b21-9f5d-75ecd8e26b85) | ![](https://github.com/H-CLo/StockInfo/assets/13503418/c82e776e-9c82-4ea1-acee-b9a54fa42b8b) | ![](https://github.com/H-CLo/StockInfo/assets/13503418/3dfe1e1e-dc4c-48b5-9b32-4d59756ff50b) | ![](https://github.com/H-CLo/StockInfo/assets/13503418/48080b6a-7bbd-4ac9-9940-2a910af673fc) |

# Requirement
- Xcode 15.x
- Swift 5.x.x
- iOS 13+

# Features

## 登入
- 登入介面實作
- 密碼保護功能實作
- 可以顯示隱藏起來的密碼
- 帳號跟密碼都有輸入資料的狀態下，按鈕才會高亮
- 進行登入行為，登入成功後將Token 儲存到本地端，並開始後續流程

### Dev notes
1. 使用 `{{domain}}/auth/login/` 進行登入，並將Token 使用UserDefault 儲存下來供其他Api headers使用
2. Api request 架構, 使用泛型供使用者可帶入想要的型別，搭配 `Alamofire` 進行請求
3. 使用UserDefault 儲存 AccessToken 的資訊

## 自選股清單
- 自選股列表顯示
- 客製化可共用的PageList, 可以切換來看各個群組的股票資訊
- 列表資訊標題，提供排序功能，清單順序 > 升冪 > 降冪 
- 每五秒鐘進行股票資料的刷新，若有排序，則顯示已排序後的為主
- 點擊列表可以進入到個股資訊頁面

### Dev Notes
1. 使用 `{{domain}}/stockinfo/tw/commoditybaseinfo/` 取得台股 上市/上櫃/興櫃 股票代號 vs. 股票名稱
2. 使用策略模式來設計ApiCacheRepository 的架構，對台股資料進行一天時間的儲存
3. 使用 `{{domain}}/watchlists/info/` 取得所有 watchlist
4. 使用 `{{domain}}/stockinfo/tw/watchliststocks/` 取得 watchlist 中，stock_ids 的參考價、現價、漲跌、漲跌輻
5. 使用 timer 建置每五秒鐘請求一次 `{{domain}}/stockinfo/tw/watchliststocks/` 來更新資訊，並透過life cycle 來取消跟重新請求

## 個股
- 實作可帶入多筆個股，並能夠切換個股顯示資訊的功能
- 顯示個股即時資訊
- 使用 PageList + PageViewController 來實現ViewPager 切換頁面的功能
- 自定義Protocol 來實現PageViewController 切換時更新其子畫面

### Dev Notes
1. 使用 `{{domain}}/stockinfo/tw/watchliststocks/` 取得 watchlist 中，stock_ids 的參考價、現價、漲跌、漲跌輻

## 個股 - 即時走勢
- 左側價位，根據開盤參考價，大於為紅色，小於為綠色，平盤則為白色
- 長按後可以是十字線對應到的價格與時間資訊，並在右上方顯示詳細資訊
- 個股線圖目前以紅色顯示，並且有填滿紅色
- 實現長按查價線功能，垂直的線要對到時間，水平的線要對到價格

### Dev Notes
1. 使用 DGCharts 來實作分時走勢的線圖，並透過繼承的方式來實現高清的功能以及數值的顯示
2. 使用 `{{domain}}/stockinfo/tw/stockdtrend/{stock_id}/` 取得台股 股票代號 vs. 日走勢資料
3. 使用 `{{domain}}/stockinfo/tw/watchliststocks/` 取得 watchlist 中，stock_ids 的參考價、現價、漲跌、漲跌輻

## 個股 - K線
- 實現日、週、月、分、還原的按鈕介面
- 實現開、高、低、收以及均線的顯示介面
- 右側價位，顯示個股價格
- 下方資訊顯示個股 K棒時間
- K棒的部分，紅色k棒表示 open < close, 綠色k棒表示 open > close
- 實現長按查價線功能，垂直的線要對到日期，水平的線要對到價格
- 實現均線計算功能，根據要計算的均線，有資料就進行計算

### Dev Notes
1. 使用 DGCharts 來實作分時走勢的線圖，並透過繼承的方式來實現高清的功能以及數值的顯示
2. 使用 `{{domain}}/stockinfo/tw/stockkline/v2/{stock_id}/` 取得台股 股票代號 vs. 日線 OHLC 資料

## Others
- Implementing dependency injection.
- Implementing local caching of data for faster app loading.
---

# Tech
- Swift
- UIKit
- Combine
- UserDefault
- Swift Package Manager

## Dependencies
- Alamofire 網路請求
- SnapKit 介面 Code layout
- DGCharts 線圖套件
- SVProgressHUD Loading畫面套件

# TODO
- 單元測試
- 登入頁各個功能實現，UISwitch 樣式調整
- 各種錯誤處理，以及新增Log 上傳到後台
- 列表應紀錄當前選擇的群組
- 分時走勢，目前只有顯示紅色的線以及紅色填充顏色，須調整為根據參考價顯示漲跌顏色
- 調整十字線等高亮顯示，在Touch 到介面時進行隱藏
