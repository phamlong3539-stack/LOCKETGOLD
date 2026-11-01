# LOCKETGOLD

Kho lưu trữ cấu hình & script Locket Gold cho các ứng dụng proxy/tinh chỉnh mạng (Shadowrocket, Loon, Quantumult X, Surge).

## Danh sách tệp (Files)

| Tên tệp | Mô tả |
| :--- | :--- |
| `forceGold4.2.js` | Tùy biến cấu hình Firebase Remote Config (`firebaseremoteconfig.googleapis.com`) |
| `locketfix.js` | Xử lý và kích hoạt gói đăng ký qua RevenueCat (`api.revenuecat.com`) |
| `locketheader.js` | Xóa/tùy chỉnh header `X-RevenueCat-ETag` để tránh bị cache cấu hình cũ |
| `Locketgold.js` | Script tổng hợp Locket Gold |

## Hướng dẫn cấu hình (Cơ bản)

### 1. MITM (Hostname)
Thêm các hostname sau vào danh sách MITM / Decryption:
```text
firebaseremoteconfig.googleapis.com, api.revenuecat.com
```

### 2. Rewrite / Scripting

- **Header Rewrite (Request):**
  - URL Regex: `^https?:\/\/api\.revenuecat\.com\/.+\/(receipts|subscribers\/?(.*?)*$)`
  - Script: `locketheader.js`
  - Type: `http-request`

- **Response Body Rewrite (RevenueCat):**
  - URL Regex: `^https?:\/\/api\.revenuecat\.com\/.+\/(receipts|subscribers\/?(.*?)*$)`
  - Script: `locketfix.js`
  - Type: `http-response`

- **Response Body Rewrite (Firebase Remote Config):**
  - URL Regex: `^https?:\/\/firebaseremoteconfig\.googleapis\.com\/v1\/projects\/locket-.*\/namespaces\/firebase:fetch`
  - Script: `forceGold4.2.js`
  - Type: `http-response`

