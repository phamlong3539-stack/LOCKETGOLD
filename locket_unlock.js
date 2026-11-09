/*
  Locket Widget - All-in-One Unlock Script (Gold, Filters, Photobooth, Streaks)
*/
let body = $response.body;
try {
    let obj = JSON.parse(body);
    
    // Kiểm tra và mở khóa thông tin tài khoản (Gold / Premium)
    if (obj.data && obj.data.user) {
        obj.data.user.is_premium = true;
        obj.data.user.is_gold = true; // Mở khóa gói Gold nếu app kiểm tra trường này
        obj.data.user.premium_since = "2026-01-01T00:00:00.000Z";
        
        // Kích hoạt các tính năng nâng cao (Filters, Photobooth, Layouts...)
        if (!obj.data.user.features) {
            obj.data.user.features = {};
        }
        obj.data.user.features.filters_enabled = true;
        obj.data.user.features.photobooth_enabled = true;
        obj.data.user.features.premium_filters = true;
        obj.data.user.features.gold_features = true;
    }

    // Kích hoạt cấu hình chung trong ứng dụng nếu có
    if (obj.data && obj.data.settings) {
        obj.data.settings.photobooth = true;
        obj.data.settings.filters = true;
        obj.data.settings.gold_mode = true;
    }

    body = JSON.stringify(obj);
} catch (e) {
    console.log("Locket Script Error: " + e);
}

$done({ body });
